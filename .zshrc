# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export MACHINE_ARCH=$(uname -m)
export MACHINE_NAME=$(hostname)

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
# Add go in PATH
export PATH=$PATH:~/.local/share/zinit/snippets/go/bin

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  colorize
  dirhistory
  git git-auto-fetch
  golang
  docker docker-compose
  kubectl helm
  brew
)


source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias l='lsd'
alias la='lsd -a'
alias ll='lsd -lah'
alias ls='lsd --color=auto'

alias reload='source ~/.zshrc'
alias ffs='sudo !!'
alias myip='curl http://ipecho.net/plain; echo'

alias d='docker'
alias k="kubectl"
alias t='terraform'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust


### End of Zinit's installer chunk

zinit snippet OMZ::lib/completion.zsh
zinit snippet OMZ::lib/history.zsh
zinit snippet OMZ::plugins/colored-man-pages/colored-man-pages.plugin.zsh
zinit snippet OMZ::plugins/git/git.plugin.zsh
zinit snippet OMZ::plugins/kubectl/kubectl.plugin.zsh

zinit ice blockf
zinit light zsh-users/zsh-completions

zinit ice depth=1
zinit light romkatv/powerlevel10k

if [[ "${MACHINE_ARCH}" == "arm64" ]];then

  zinit ice from"gh-r" as"program" mv"yq* -> yq" bpick"*darwin_arm64*"
  zinit load mikefarah/yq

  #zinit ice as"program" cp"httpstat.sh -> httpstat" pick"httpstat"
  #zinit light b4b4r07/httpstat

  #zinit ice wait"2" lucid from"gh-r" as"program" mv"exa* -> exa"
  #zinit light ogham/exa

  #zinit ice from"gh-r" as"program"
  #zinit load andreazorzetto/yh

  zinit ice lucid wait'1' as"program" id-as"auto"
  zinit snippet https://dl.k8s.io/release/v1.24.0/bin/darwin/arm64/kubectl

  zinit ice lucid wait'1' as"program" id-as"helm" extract"!"
  zinit snippet https://get.helm.sh/helm-v3.9.0-darwin-arm64.tar.gz

  zinit ice from"gh-r" as"program" mv"helmfile* -> helmfile" bpick"*darwin_arm64*"
  zinit load helmfile/helmfile

  zinit ice from"gh-r" as"program" mv"docker* -> docker-compose" bpick"*darwin-aarch64*"
  zinit load docker/compose

  zinit ice from"gh-r" as"program" pick"usr/local/bin/helm-docs"
  zinit load norwoodj/helm-docs

  zinit ice from"gh-r" as"program" bpick"krew-darwin_arm64.tar.gz" mv"krew-darwin_arm64 -> krew" pick"krew"
  zinit load kubernetes-sigs/krew 

elif [[ "${MACHINE_ARCH}" == "x86_64" ]];then
  zinit ice from"gh-r" as"program"
  zinit load andreazorzetto/yh

  zinit ice as"command" from"gh-r" mv"bat* -> bat" pick"bat/bat"
  zinit light sharkdp/bat

  zinit ice lucid wait'1' as"program" id-as"go" extract"!"
  zinit snippet https://go.dev/dl/go1.18.4.linux-amd64.tar.gz

  zinit ice lucid wait'1' id-as'kubectl' as"null" sbin"kubectl"
  zinit snippet https://storage.googleapis.com/kubernetes-release/release/v1.24.1/bin/linux/amd64/kubectl

  zinit ice lucid wait'1' as"program" id-as"helm" extract"!"
  zinit snippet https://get.helm.sh/helm-v3.9.1-linux-amd64.tar.gz

  zinit ice from"gh-r" as"program" mv"helmfile_linux_amd64 -> helmfile"
  zinit load helmfile/helmfile

  zinit ice from"gh-r" as"program" bpick"krew-linux_amd64.tar.gz" mv"krew-linux_amd64 -> krew" pick"krew"
  zinit load kubernetes-sigs/krew

  zinit ice from"gh-r" as"program" mv"docker* -> docker-compose"
  zinit load docker/compose
fi

# Two regular plugins loaded without investigating.
zinit light zsh-users/zsh-autosuggestions
zinit ice atinit'zicompinit'
zinit light zdharma-continuum/fast-syntax-highlighting


[[ ! -f ~/work/.zshrc.work ]] || source ~/work/.zshrc.work