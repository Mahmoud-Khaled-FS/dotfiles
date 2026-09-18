#!/usr/bin/env bash

# Check if wpctl not exists
if ! command -v wpctl &> /dev/null; then
  echo "wpctl not found"
  exit 1
fi

# check arg size 
if [ "$#" -ne 1 ]; then
  echo "Usage: volume {up|down|mute}"
  exit 1
fi


case "$1" in
  up)
    wpctl set-mute @DEFAULT_SINK@ 0
    wpctl set-volume @DEFAULT_SINK@ 5%+ -l 1
    ;;
  down)
    wpctl set-volume @DEFAULT_SINK@ 5%-
    ;;
  mute)
    wpctl set-mute @DEFAULT_SINK@ toggle
    ;;
  *)
    echo "Usage: volume {up|down|mute}"
    exit 1
    ;;
esac