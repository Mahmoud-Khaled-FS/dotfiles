typeset -U path PATH

path=(
  $HOME/.local/bin
  $HOME/.scripts
  $HOME/.cargo/bin
  $HOME/.bun/bin
  $HOME/.opencode/bin
  $path
)

export BUN_INSTALL=$HOME/.bun
export EDITOR=nvim
export VISUAL=nvim
export MANPAGER="sh -c 'col -bx | bat -l man -p'"   # coloured man pages
export MANROFFOPT=-c
export DOTNET_CLI_TELEMETRY_OPTOUT=1

[[ -r ~/.zshenv.local ]] && source ~/.zshenv.local   # machine-only secrets / overrides
