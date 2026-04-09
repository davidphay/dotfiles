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
