#!/usr/bin/env bash

ROFI_THEME="$HOME/.config/rofi/clipboard.rasi"
ROFI_PROMPT=" Clipboard"

CLIPHIST_CMD="cliphist"
COPY_CMD="wl-copy"

# =========================
# Functions
# =========================

run_rofi() {
    rofi \
        -dmenu \
        -config "$ROFI_THEME"
}

get_clipboard() {
    $CLIPHIST_CMD list
}

decode_clipboard() {
    $CLIPHIST_CMD decode
}

copy_to_clipboard() {
    $COPY_CMD
}

main() {
    choice=$(get_clipboard | run_rofi)

    [ -z "$choice" ] && exit 0

    echo "$choice" | decode_clipboard | copy_to_clipboard
}

main
