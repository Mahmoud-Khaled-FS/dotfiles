# ↑ / ↓: search history for what is already typed
bindkey '^[[A' history-substring-search-up
bindkey '^[OA' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^[OB' history-substring-search-down

# words: Ctrl/Alt+→ also accepts one word of the grey suggestion
bindkey '^[[1;5D' backward-word      # Ctrl+←
bindkey '^[[1;5C' forward-word       # Ctrl+→
bindkey '^[[1;3D' backward-word      # Alt+←
bindkey '^[[1;3C' forward-word       # Alt+→
bindkey '^H'      backward-kill-word # Ctrl+Backspace
bindkey '^[[3;5~' kill-word          # Ctrl+Delete

# Home / End / Delete (End or → accepts the whole suggestion)
bindkey '^[[H' beginning-of-line
bindkey '^[OH' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[OF' end-of-line
bindkey '^[[3~' delete-char

# Alt+E: edit the command in nvim
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^[e' edit-command-line

# Alt+S: add or remove sudo at the start of the line
_toggle_sudo() {
  if [[ $BUFFER == sudo\ * ]]; then BUFFER=${BUFFER#sudo }; else BUFFER="sudo $BUFFER"; fi
  zle end-of-line
}
zle -N _toggle_sudo
bindkey '^[s' _toggle_sudo
