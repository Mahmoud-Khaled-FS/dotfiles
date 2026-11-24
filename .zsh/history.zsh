HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt extended_history     # save when each command ran
setopt share_history        # all open terminals share one history
setopt hist_ignore_all_dups # repeating a command removes the older copy
setopt hist_save_no_dups
setopt hist_find_no_dups
setopt hist_ignore_space    # a command that starts with a space is not saved
setopt hist_reduce_blanks
setopt hist_verify          # show !! / !$ expansions before running them
