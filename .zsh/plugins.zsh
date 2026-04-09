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
