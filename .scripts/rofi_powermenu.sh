#!/bin/bash

THEME_PATH="~/.themes/rofi/powermenu.rasi"

SHUTDOWN_COMMAND="⏻ Shutdown"
RESTART_COMMAND=" Restart"
EXIT_COMMAND="󰍃 Log out"

uptime="`uptime -p | sed -e 's/up //g'`"

rofi_command(){
	rofi -dmenu -theme ${THEME_PATH} -mesg "Uptime: $uptime"
}

run_rofi() {
	echo -e "$SHUTDOWN_COMMAND\n$RESTART_COMMAND\n$EXIT_COMMAND" | rofi_command
}

choise="$(run_rofi)"

case ${choise} in
	$SHUTDOWN_COMMAND)
		shutdown -P 0
		;;
	$RESTART_COMMAND)
		reboot
		;;
	$EXIT_COMMAND)
		pkill dwm
		;;
esac
