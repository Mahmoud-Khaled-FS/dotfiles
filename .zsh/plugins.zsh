# ORDER MATTERS: fzf-tab after compinit and fzf, before anything that wraps widgets;
# syntax-highlighting after all widgets; history-substring-search after syntax-highlighting.
P=/usr/share/zsh/plugins

export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude .git'
export FZF_DEFAULT_OPTS='--height 40% --layout reverse --border'
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range :200 {}'"
eval "$(fzf --zsh)"          # Ctrl+R history, Ctrl+T files, Alt+C folders

source ~/.zsh/plugins/fzf-tab/fzf-tab.plugin.zsh   # after fzf, so it owns Tab

ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=40
source $P/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(abbr-enter)   # don't leave grey text behind after Enter

source $P/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1
source $P/zsh-history-substring-search/zsh-history-substring-search.zsh
unset P
