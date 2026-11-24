autoload -Uz compinit
# full check at most once a day, otherwise load the cached dump (faster start)
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then compinit; else compinit -C; fi

[[ -s ~/.bun/_bun ]] && source ~/.bun/_bun

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu no                      # fzf-tab draws the menu
zstyle ':completion:*:descriptions' format '[%d]'   # group names in fzf-tab
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.cache/zsh/compcache

zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:*' switch-group '<' '>'
zstyle ':fzf-tab:complete:(cd|__zoxide_z):*' fzf-preview 'eza -1 --color=always --icons $realpath'
zstyle ':fzf-tab:complete:kill:argument-rest' fzf-preview 'ps -o pid,user,%cpu,cmd -p $word'
