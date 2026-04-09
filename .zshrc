# ------------------------------------------------------------------------------
# Fast startup / global setup
# ------------------------------------------------------------------------------

skip_global_compinit=1

[[ -f "$HOME/.zshenv-local" ]] && source "$HOME/.zshenv-local"

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ------------------------------------------------------------------------------
# Environment
# ------------------------------------------------------------------------------

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi
export EDITOR='vim'
export GOPATH="$HOME/go"

# manage PATH with zsh's array syntax (instead of colon-separated string)
typeset -U path PATH
path+=(
  "$HOME/.local/bin"
  "$HOME/.krew/bin"
  "$GOPATH/bin"
)

[[ -n "$GOROOT" ]] && path+=("$GOROOT/bin")

# Force emacs mode for shell navigation (even with vim as editor)
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

# ------------------------------------------------------------------------------
# Aliases
# ------------------------------------------------------------------------------

alias reload='source ~/.zshrc'
alias ffs='sudo $(history -p \!\!)'
alias myip='curl -fsSL https://ipecho.net/plain; echo'
alias ep='print -l ${(s/:/)PATH}'

alias d='docker'

if (( $+commands[lsd] )); then
  alias ls='lsd --color=auto'
  alias l='lsd'
  alias la='lsd -a'
  alias ll='lsd -lah'
fi

# ------------------------------------------------------------------------------
# Zinit bootstrap
# ------------------------------------------------------------------------------

ZINIT_BASE="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit"
ZINIT_HOME="${ZINIT_BASE}/zinit.git"

[ ! -d "$ZINIT_HOME" ] && mkdir -p "$(dirname "$ZINIT_HOME")"
[ ! -d "$ZINIT_HOME/.git" ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"

source "${ZINIT_HOME}/zinit.zsh"

autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zinit light-mode for \
  zdharma-continuum/z-a-rust \
  zdharma-continuum/z-a-bin-gem-node

# ------------------------------------------------------------------------------
# Oh My Zsh snippets only
# ------------------------------------------------------------------------------

zinit snippet OMZL::completion.zsh
zinit snippet OMZL::history.zsh
zinit snippet OMZL::key-bindings.zsh

zinit snippet OMZP::colored-man-pages/colored-man-pages.plugin.zsh
zinit snippet OMZP::git/git.plugin.zsh
zinit snippet OMZP::git-auto-fetch/git-auto-fetch.plugin.zsh
zinit snippet OMZP::dirhistory/dirhistory.plugin.zsh
zinit snippet OMZP::docker/docker.plugin.zsh
zinit snippet OMZP::kubectl/kubectl.plugin.zsh
zinit snippet OMZP::helm/helm.plugin.zsh
zinit snippet OMZP::terraform/terraform.plugin.zsh
zinit snippet OMZP::colorize/colorize.plugin.zsh

if (( $+commands[brew] )); then
  zinit snippet OMZP::brew/brew.plugin.zsh
fi

# ------------------------------------------------------------------------------
# Prompt
# ------------------------------------------------------------------------------

zinit ice depth=1
zinit light romkatv/powerlevel10k

# ------------------------------------------------------------------------------
# Completions
# ------------------------------------------------------------------------------

zinit ice blockf
zinit light zsh-users/zsh-completions

autoload -Uz compinit
compinit -d "${XDG_CACHE_HOME:-$HOME/.cache}/zcompdump-${ZSH_VERSION}"

# If you ever need bash completion scripts in zsh, uncomment:
# autoload -U +X bashcompinit && bashcompinit

zstyle ':completion:*' menu select

# ------------------------------------------------------------------------------
# Shell UX plugins
# ------------------------------------------------------------------------------

zinit ice wait"1" lucid
zinit light zsh-users/zsh-autosuggestions

zinit ice wait"1" lucid
zinit light zdharma-continuum/fast-syntax-highlighting

# ------------------------------------------------------------------------------
# CLI tools installed via Zinit
# ------------------------------------------------------------------------------

# Go
zinit ice silent as"program" extract pick"go/bin/go"
zinit snippet "https://go.dev/dl/go1.23.5.${platform}-${arch}.tar.gz"

for go_bin in \
  "$ZINIT_BASE/snippets/go/go/bin" \
  "$ZINIT_BASE/plugins/_local---go/go/bin"
do
  [[ -d "$go_bin" ]] && path+=("$go_bin")
done

# kubectl
zinit ice silent as"program"
zinit snippet "https://dl.k8s.io/release/v1.32.1/bin/${platform}/${arch}/kubectl"

# helm
zinit ice silent as"program" extract pick"${platform}-${arch}/helm"
zinit snippet "https://get.helm.sh/helm-v3.17.1-${platform}-${arch}.tar.gz"

# terraform
zinit ice silent as"program" extract pick"terraform"
zinit snippet "https://releases.hashicorp.com/terraform/1.11.4/terraform_1.11.4_${platform}_${arch}.zip"

# sops
zinit ice silent from"gh-r" as"program" \
  mv"sops-* -> sops" \
  atclone'chmod +x sops' \
  atpull'%atclone'
zinit load getsops/sops

# bat
if [[ -n "$rust_target" ]]; then
  zinit ice silent from"gh-r" as"program" \
    bpick"bat-v*-${rust_target}.tar.gz" \
    mv"bat-v*-${rust_target} -> bat" \
    pick"bat/bat"
  zinit load sharkdp/bat
fi

# k9s
zinit ice silent from"gh-r" as"program"
zinit load derailed/k9s

# yq
zinit ice silent from"gh-r" as"program" \
  mv"yq_* -> yq" \
  atclone'chmod +x yq' \
  atpull'%atclone'
zinit load mikefarah/yq

# yh
zinit ice silent from"gh-r" as"program"
zinit load andreazorzetto/yh

# kubecolor
zinit ice silent from"gh-r" as"program"
zinit load kubecolor/kubecolor

# lsd
if [[ -n "$rust_target" ]]; then
  zinit ice silent from"gh-r" as"program" \
    bpick"lsd-v*-${rust_target}.tar.gz" \
    mv"lsd-v*-${rust_target} -> lsd" \
    pick"lsd/lsd"
  zinit load lsd-rs/lsd
fi

# krew
zinit ice silent from"gh-r" as"program" \
  bpick"krew-${platform}_${arch}.tar.gz" \
  mv"krew-${platform}_${arch} -> krew" \
  pick"krew"
zinit load kubernetes-sigs/krew

# helmfile
zinit ice silent from"gh-r" as"program"
zinit load helmfile/helmfile

# hubble
zinit ice silent from"gh-r" as"program"
zinit load cilium/hubble

# kubeseal
zinit ice silent from"gh-r" as"program"
zinit load bitnami-labs/sealed-secrets

# argocd
zinit ice silent from"gh-r" as"program" \
  mv"argocd-${platform}-${arch} -> argocd" \
  atclone'chmod +x argocd' \
  atpull'%atclone'
zinit load argoproj/argo-cd

# cilium
zinit ice silent from"gh-r" as"program"
zinit load cilium/cilium-cli

# uv only
zinit ice silent from"gh-r" as"program" pick"uv-*/uv"
zinit load astral-sh/uv

# ------------------------------------------------------------------------------
# Docker Compose v2 plugin (Linux only, enables `docker compose`)
# ------------------------------------------------------------------------------

if $is_linux && [[ -n "$docker_compose_arch" ]]; then
  mkdir -p "$HOME/.docker/cli-plugins"

  if [[ ! -x "$HOME/.docker/cli-plugins/docker-compose" ]]; then
    curl -fL "https://github.com/docker/compose/releases/download/v2.35.1/docker-compose-linux-${docker_compose_arch}" \
      -o "$HOME/.docker/cli-plugins/docker-compose" && \
      chmod +x "$HOME/.docker/cli-plugins/docker-compose"
  fi
fi

# ------------------------------------------------------------------------------
# Tool-dependent aliases
# ------------------------------------------------------------------------------

if (( $+commands[kubecolor] )); then
  alias kubectl=kubecolor
  compdef kubecolor=kubectl
fi

# ------------------------------------------------------------------------------
# Prompt config
# ------------------------------------------------------------------------------

[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
