# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
 
export MACHINE_NAME=$(hostname)
 
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
# update PATH
export PATH=$PATH:~/.local/share/zinit/snippets/go/bin:~/.krew/bin:~/.local/bin
export GOPATH=$HOME
 
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
 
ZSH_THEME="powerlevel10k/powerlevel10k"
 
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
  terraform
)
autoload -U compinit && compinit
autoload -U +X bashcompinit && bashcompinit
 
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
export EDITOR='vim'
 
# Compilation flags
# export ARCHFLAGS="-arch x86_64"
 
# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
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
 
## Useful variables for installs
kernel="$(uname -r)"
platform="$(uname -s | tr '[:upper:]' '[:lower:]')"
architecture="$(uname -m)"
case $architecture in
  x86_64)
    arch="amd64"
    ;;
  arm64)
    architecture="aarch64"
    arch="arm64"
    ;;
esac
 
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
    zdharma-continuum/z-a-rust \
    zdharma-continuum/z-a-as-monitor \
    zdharma-continuum/z-a-patch-dl \
    zdharma-continuum/z-a-bin-gem-node
 
### End of Zinit's installer chunk
zinit snippet OMZL::completion.zsh
zinit snippet OMZL::history.zsh
zinit snippet OMZP::colored-man-pages/colored-man-pages.plugin.zsh
zinit snippet OMZP::git/git.plugin.zsh
zinit snippet OMZP::kubectl/kubectl.plugin.zsh
zinit snippet OMZP::terraform/terraform.plugin.zsh



# Package could be install cross plateform without issue
zinit ice depth=1
zinit light romkatv/powerlevel10k
ln -sf ~/.local/share/zinit/plugins/romkatv---powerlevel10k/ $ZSH_CUSTOM/themes/powerlevel10k
 
zinit ice blockf
zinit light zsh-users/zsh-completions
 
zinit ice as"program" id-as"terraform" extract
zinit snippet https://releases.hashicorp.com/terraform/1.10.4/terraform_1.10.4_${platform}_${arch}.zip
 
zinit ice lucid wait'1' as"program" id-as"go" extract"!"
zinit snippet https://go.dev/dl/go1.23.5.${platform}-${arch}.tar.gz
 
zinit ice as"program" id-as"auto"
zinit snippet https://dl.k8s.io/release/v1.32.1/bin/linux/amd64/kubectl
 
zinit id-as"helm" as="readurl|command" extract \
  pick"${platform}-${arch}/helm" \
  dlink"https://get.helm.sh/helm-v%VERSION%-${platform}-${arch}.tar.gz" \
  for https://github.com/helm/helm/releases/
  #atload"helm plugin install https://github.com/databus23/helm-diff" \
 
# Install package based on distro
if [[ "${kernel}" == *"-WSL2" ]];then
  # Install package for WSL only
  zinit ice from"gh-r" ver"v1.1.5" as"program" bpick"lsd-*-${architecture}-unknown-${platform}-gnu.tar.gz" \
    mv"lsd-*-${architecture}-unknown-${platform}-gnu -> lsd" pick"lsd/lsd"
  zinit load lsd-rs/lsd
 
  zinit ice from"gh-r" ver"v0.4.4" as"program" bpick"krew-${platform}_${arch}.tar.gz" \
    mv"krew-${platform}_${arch} -> krew" pick"krew"
  zinit load kubernetes-sigs/krew
 
  zinit ice from"gh-r" ver"v0.170.0" as"program"
  zinit load helmfile/helmfile
 
  zinit ice from"gh-r" ver"v1.16.5" as"program"
  zinit load cilium/hubble
 
  zinit ice from"gh-r" ver"v0.28.0" as"program"
  zinit load bitnami-labs/sealed-secrets
 
  zinit ice as"command" from"gh-r" ver"v0.25.0" mv"bat* -> bat" pick"bat/bat"
  zinit load sharkdp/bat
 
  zinit ice from"gh-r" ver"v0.5.0" as"program"
  zinit load kubecolor/kubecolor
 
  zinit ice from"gh-r" ver"v4.45.1" as"program" mv"yq_*-> yq"
  zinit load mikefarah/yq
 
  zinit ice from"gh-r" ver"v0.32.7" as"program"
  zinit load derailed/k9s
 
  zinit ice from"gh-r" ver"v2.13.3" as"program" mv"argocd-${platform}-${arch} -> argocd"
  zinit load argoproj/argo-cd
 
  zinit ice from"gh-r" ver"v0.16.23" as"program"
  zinit load cilium/cilium-cli
else
  zinit ice as"command" from"gh-r" mv"bat* -> bat" pick"bat/bat"
  zinit load sharkdp/bat
 
  zinit ice from"gh-r" as"program"
  zinit load derailed/k9s
 
  zinit ice from"gh-r" as"program" mv"yq_*-> yq"
  zinit load mikefarah/yq
 
  zinit ice from"gh-r" as"program"
  zinit load andreazorzetto/yh
 
  zinit ice from"gh-r" as"program"
  zinit load kubecolor/kubecolor
 
  zinit ice from"gh-r" as"program" bpick"lsd-*-${architecture}-unknown-${platform}-gnu.tar.gz" \
    mv"lsd-*-${architecture}-unknown-${platform}-gnu -> lsd" pick"lsd/lsd"
  zinit load lsd-rs/lsd
 
  zinit ice from"gh-r" as"program" bpick"krew-${platform}_${arch}.tar.gz" \
    mv"krew-${platform}_${arch} -> krew" pick"krew"
  zinit load kubernetes-sigs/krew
 
  zinit ice from"gh-r" as"program" mv"helmfile_${platform}_${arch} -> helmfile"
  zinit load helmfile/helmfile
 
  zinit ice from"gh-r" as"program"
  zinit load cilium/hubble
 
  zinit ice from"gh-r" as"program"
  zinit load bitnami-labs/sealed-secrets
 
  zinit ice from"gh-r" as"program" mv"argocd-${platform}-${arch} -> argocd"
  zinit load argoproj/argo-cd
 
  zinit ice from"gh-r" as"program"
  zinit load cilium/cilium-cli
 
  if [[ "${architecture}" == "x86_64" ]];then
    zinit ice from"gh-r" as"program" mv"docker* -> docker-compose"
    zinit load docker/compose
  elif [[ "${architecture}" == "arm64" ]];then
    zinit ice from"gh-r" as"program" mv"docker* -> docker-compose" bpick"*darwin-aarch64*"
    zinit load docker/compose
 
    zinit ice from"gh-r" as"program" pick"usr/local/bin/helm-docs"
    zinit load norwoodj/helm-docs
  fi
fi
 
# Two regular plugins loaded without investigating.
zinit light zsh-users/zsh-autosuggestions
zinit ice atinit'zicompinit'
zinit light zdharma-continuum/fast-syntax-highlighting
 
# Kubecolor
alias kubectl=kubecolor
compdef kubecolor=kubectl
 
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
