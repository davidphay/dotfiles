# ------------------------------------------------------------------------------
# Environment
# ------------------------------------------------------------------------------

export EDITOR='vim'
export GOPATH="$HOME/go"

typeset -U path PATH

path+=(
  "$HOME/.local/bin"
  "$HOME/.krew/bin"
  "$GOPATH/bin"
)

[[ -n "$GOROOT" ]] && path+=("$GOROOT/bin")

bindkey -e

# ------------------------------------------------------------------------------
# Platform detection
# ------------------------------------------------------------------------------

os="$(uname -s)"
platform="$(printf '%s' "$os" | tr '[:upper:]' '[:lower:]')"
machine="$(uname -m)"

case "$os:$machine" in
  Linux:x86_64)
    arch="amd64"
    rust_target="x86_64-unknown-linux-gnu"
    docker_compose_arch="x86_64"
    ;;
  Darwin:arm64)
    arch="arm64"
    rust_target="aarch64-apple-darwin"
    docker_compose_arch=""
    ;;
  *)
    arch="$machine"
    rust_target=""
    docker_compose_arch=""
    ;;
esac

is_linux=false
[[ "$os" == "Linux" ]] && is_linux=true
