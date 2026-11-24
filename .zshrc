# ~/.zshrc: loads the parts in ~/.zsh/ in this exact order (see the note for why).
for f in options history completion aliases abbr plugins keys tools; do
  source ~/.zsh/$f.zsh
done
unset f
