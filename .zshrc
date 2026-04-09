skip_global_compinit=1

[[ -f "$HOME/.zshenv-local" ]] && source "$HOME/.zshenv-local"

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

for file in \
  "$HOME/.zsh/env.zsh" \
  "$HOME/.zsh/aliases.zsh" \
  "$HOME/.zsh/plugins.zsh" \
  "$HOME/.zsh/tools.zsh"
do
  [[ -f "$file" ]] && source "$file"
done

[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
