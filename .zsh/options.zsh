bindkey -e                  # emacs keys. Needed: EDITOR=nvim would switch zsh to vi mode
setopt autocd               # type a folder name to cd into it
setopt auto_pushd pushd_ignore_dups pushd_silent   # folder history: cd -<Tab>
setopt interactive_comments # allow # comments on the command line
setopt extended_glob
setopt no_beep
WORDCHARS='*?_[]~&;!#$%^(){}<>'   # Ctrl+W / Ctrl+Backspace stop at / - . =
