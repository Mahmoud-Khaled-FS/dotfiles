# Make Ctrl+Arrow work as word navigation
bindkey '^[[1;5D' backward-word   # Ctrl + Left
bindkey '^[[1;5C' forward-word    # Ctrl + Right

# prompot
eval "$(starship init zsh)"

# Plugins
fpath=(~/.zsh/plugins/zsh-completions/src $fpath)
source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/plugins/zsh-completions/zsh-completions.plugin.zsh
source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

autoload -U compinit;compinit
source ~/.zsh/plugins/fzf-tab/fzf-tab.plugin.zsh

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no

# Aliases
alias ls='eza'
alias ll='eza -l'
alias la='eza -la'

alias vim='nvim'
alias xi='sudo xbps-install'
alias xq='xbps-query -Rs'
alias xu='sudo xbps-install -S && sudo xbps-install -u xbps && sudo xbps-install -u'
alias xuni='sudo xbps-remove'

alias pa='php artisan'

alias mytodo='grep -rnosE \"(TODO|FIXME|NOTE|WARN) \(MAHMOUD\)\"'

# Shell utils
eval "$(fzf --zsh)"

# Keybinding

# bun completions
[ -s "/home/mahmoud/.bun/_bun" ] && source "/home/mahmoud/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export QT_QPA_PLATFORMTHEME=qt5ct

# PATH
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.scripts:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

# opencode
export PATH=/home/mahmoud/.opencode/bin:$PATH

DOTNET_CLI_TELEMETRY_OPTOUT=1
