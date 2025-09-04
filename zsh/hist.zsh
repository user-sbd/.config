sk-history-widget() {
  local selected
  selected=$(tac ~/.zsh_history | awk '!seen[$0]++' | sk --color="bw" --margin 3%)
  if [[ -n "$selected" ]]; then
    BUFFER="$selected"
    CURSOR=${#BUFFER}
  fi
  zle reset-prompt
}

zle -N sk-history-widget
bindkey '^R' sk-history-widget
