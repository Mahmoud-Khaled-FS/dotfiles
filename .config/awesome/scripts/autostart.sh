#!/bin/env bash

run() {
  if ! pgrep $1 ; then 
    "$@" &
  fi
}

run "xset r rate 250 25"
run "setxkbmap -layout us,ara -variant ,digits -option grp:win_space_toggle"
run "dunst"
run "pipewire"