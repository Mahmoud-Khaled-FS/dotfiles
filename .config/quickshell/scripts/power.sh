#!/usr/bin/env bash

set -euo pipefail

ACTION="${1:-menu}"

confirm() {
    command -v zenity >/dev/null || return 0

    zenity \
        --question \
        --title="Power Menu" \
        --text="$1" \
        --width=300
}

case "$ACTION" in
    poweroff)
        loginctl poweroff
        ;;

    reboot)
        loginctl reboot
        ;;

    lock)
        if command -v loginctl >/dev/null; then
            loginctl lock-session
        elif command -v hyprlock >/dev/null; then
            pidof hyprlock >/dev/null || hyprlock
        fi
        ;;

    suspend)
        loginctl suspend
        ;;

    logout)
        if command -v hyprctl >/dev/null; then
            hyprctl dispatch exit
        fi
        ;;

    hibernate)
        loginctl hibernate
        ;;

    *)
        echo "Usage:"
        echo "  $0 poweroff"
        echo "  $0 reboot"
        echo "  $0 lock"
        echo "  $0 suspend"
        echo "  $0 hibernate"
        echo "  $0 logout"
        exit 1
        ;;
esac