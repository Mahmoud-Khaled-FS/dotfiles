typeset -gA abbrs=(
  xi   'sudo xbps-install'
  xq   'xbps-query -Rs'
  xuni 'sudo xbps-remove'
  pa   'php artisan'
  g    'git'
  gs   'git status'
  ga   'git add'
  gc   'git commit'
  gp   'git push'
  gl   'git log --oneline --graph'
)
_abbr_expand() {
  emulate -L zsh -o extendedglob
  local word=${LBUFFER##*[[:space:]|;&]}
  local before=${LBUFFER%$word}
  # expand only in command position: start of line, or after | ; && ||
  local cmdpos='([[:space:]]#|*[|;&][[:space:]]#)'
  if [[ -n $word && -n ${abbrs[$word]} && $before == ${~cmdpos} ]]; then
    LBUFFER=$before${abbrs[$word]}
  fi
}
abbr-space() { _abbr_expand; zle self-insert }
abbr-enter() { _abbr_expand; zle accept-line }
zle -N abbr-space
zle -N abbr-enter
bindkey ' '  abbr-space
bindkey '^M' abbr-enter
bindkey '^ ' magic-space
bindkey -M isearch ' ' magic-space
