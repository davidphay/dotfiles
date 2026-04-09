# ------------------------------------------------------------------------------
# Tool versions
# For GitHub releases:
#   latest or empty string => latest release
#   otherwise => fixed version
#
# For direct-download tools (go/kubectl/helm/terraform/docker_compose),
# use explicit versions.
# ------------------------------------------------------------------------------

typeset -gA TOOL_VERSIONS

TOOL_VERSIONS=(
  go              1.23.5
  kubectl         v1.32.1
  helm            v3.17.1
  terraform       1.11.4
  docker_compose  v2.35.1

  bat             latest
  lsd             latest
  sops            latest
  yq              latest
  argocd          latest
  uv              latest
  kubecolor       latest
  k9s             latest
  helmfile        latest
  kubeseal        latest
  yh              latest
  cilium          latest
  hubble          latest
  krew            latest
)

# ------------------------------------------------------------------------------
# Helpers
# ------------------------------------------------------------------------------

zinit_maybe_ver() {
  local version="$1"
  [[ -n "$version" && "$version" != "latest" ]] && zinit ice ver"$version"
}

# ------------------------------------------------------------------------------
# CLI tools installed via Zinit
# ------------------------------------------------------------------------------

# Go
zinit ice silent as"program" extract pick"go/bin/go"
zinit snippet "https://go.dev/dl/go${TOOL_VERSIONS[go]}.${platform}-${arch}.tar.gz"

for go_bin in \
  "$ZINIT_BASE/snippets/go/go/bin" \
  "$ZINIT_BASE/plugins/_local---go/go/bin"
do
  [[ -d "$go_bin" ]] && path+=("$go_bin")
done

# kubectl
zinit ice silent as"program"
zinit snippet "https://dl.k8s.io/release/${TOOL_VERSIONS[kubectl]}/bin/${platform}/${arch}/kubectl"

# helm
zinit ice silent as"program" extract pick"${platform}-${arch}/helm"
zinit snippet "https://get.helm.sh/helm-${TOOL_VERSIONS[helm]}-${platform}-${arch}.tar.gz"

# terraform
zinit ice silent as"program" extract pick"terraform"
zinit snippet "https://releases.hashicorp.com/terraform/${TOOL_VERSIONS[terraform]}/terraform_${TOOL_VERSIONS[terraform]}_${platform}_${arch}.zip"

# sops
zinit_maybe_ver "${TOOL_VERSIONS[sops]}"
zinit ice silent from"gh-r" as"program" \
  mv"sops-* -> sops" \
  atclone'chmod +x sops' \
  atpull'%atclone'
zinit load getsops/sops

# bat
if [[ -n "$rust_target" ]]; then
  zinit_maybe_ver "${TOOL_VERSIONS[bat]}"
  zinit ice silent from"gh-r" as"program" \
    bpick"bat-v*-${rust_target}.tar.gz" \
    mv"bat-v*-${rust_target} -> bat" \
    pick"bat/bat"
  zinit load sharkdp/bat
fi

# k9s
zinit_maybe_ver "${TOOL_VERSIONS[k9s]}"
zinit ice silent from"gh-r" as"program"
zinit load derailed/k9s

# yq
zinit_maybe_ver "${TOOL_VERSIONS[yq]}"
zinit ice silent from"gh-r" as"program" \
  mv"yq_* -> yq" \
  atclone'chmod +x yq' \
  atpull'%atclone'
zinit load mikefarah/yq

# yh
zinit_maybe_ver "${TOOL_VERSIONS[yh]}"
zinit ice silent from"gh-r" as"program"
zinit load andreazorzetto/yh

# kubecolor
zinit_maybe_ver "${TOOL_VERSIONS[kubecolor]}"
zinit ice silent from"gh-r" as"program"
zinit load kubecolor/kubecolor

# lsd
if [[ -n "$rust_target" ]]; then
  zinit_maybe_ver "${TOOL_VERSIONS[lsd]}"
  zinit ice silent from"gh-r" as"program" \
    bpick"lsd-v*-${rust_target}.tar.gz" \
    mv"lsd-v*-${rust_target} -> lsd" \
    pick"lsd/lsd"
  zinit load lsd-rs/lsd
fi

# krew
zinit_maybe_ver "${TOOL_VERSIONS[krew]}"
zinit ice silent from"gh-r" as"program" \
  bpick"krew-${platform}_${arch}.tar.gz" \
  mv"krew-${platform}_${arch} -> krew" \
  pick"krew"
zinit load kubernetes-sigs/krew

# helmfile
zinit_maybe_ver "${TOOL_VERSIONS[helmfile]}"
zinit ice silent from"gh-r" as"program"
zinit load helmfile/helmfile

# hubble
zinit_maybe_ver "${TOOL_VERSIONS[hubble]}"
zinit ice silent from"gh-r" as"program"
zinit load cilium/hubble

# kubeseal
zinit_maybe_ver "${TOOL_VERSIONS[kubeseal]}"
zinit ice silent from"gh-r" as"program"
zinit load bitnami-labs/sealed-secrets

# argocd
zinit_maybe_ver "${TOOL_VERSIONS[argocd]}"
zinit ice silent from"gh-r" as"program" \
  mv"argocd-${platform}-${arch} -> argocd" \
  atclone'chmod +x argocd' \
  atpull'%atclone'
zinit load argoproj/argo-cd

# cilium
zinit_maybe_ver "${TOOL_VERSIONS[cilium]}"
zinit ice silent from"gh-r" as"program"
zinit load cilium/cilium-cli

# uv
zinit_maybe_ver "${TOOL_VERSIONS[uv]}"
zinit ice silent from"gh-r" as"program" pick"uv-*/uv"
zinit load astral-sh/uv

# ------------------------------------------------------------------------------
# Docker Compose v2 plugin (Linux only, enables `docker compose`)
# ------------------------------------------------------------------------------

if $is_linux && [[ -n "$docker_compose_arch" ]]; then
  mkdir -p "$HOME/.docker/cli-plugins"

  if [[ ! -x "$HOME/.docker/cli-plugins/docker-compose" ]]; then
    curl -fL "https://github.com/docker/compose/releases/download/${TOOL_VERSIONS[docker_compose]}/docker-compose-linux-${docker_compose_arch}" \
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
