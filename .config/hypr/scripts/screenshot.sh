#!/usr/bin/env bash

DIR="$HOME/Pictures/Screenshots"
FILE="$DIR/satty-$(date '+%Y%m%d-%H:%M:%S').png"

mkdir -p "$DIR"

case "$1" in
  full)
    # fullscreen (all monitors)
    grim -t ppm - | satty --filename - --fullscreen --output-filename "$FILE"
    ;;

  monitor)
    # select monitor + region
    grim -g "$(slurp -o -r -c '#ff0000ff')" -t ppm - | \
      satty --filename - --fullscreen --output-filename "$FILE"
    ;;

  select)
    # select monitor only (no region)
    grim -g "$(slurp -o)" -t ppm - | satty -f - --copy-command wl-copy -o "~/Pictures/Screenshots/%Y%m%d_%H%M%S.png"
    ;;
  *)
    echo "Usage: satty-shot {full|select|monitor}"
    exit 1
    ;;
esac

