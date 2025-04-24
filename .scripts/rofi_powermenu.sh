#!/bin/bash
WM="awesome"

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


shutdown() {
	notify-send -u normal "Shutdown"
	sleep 1
	if [[ "$(ps --no-headers -o comm 1)" -eq "runit" ]] then
		loginctl poweroff
	else 
		shutdown -P 0
	fi
}

reboot() {
	notify-send -u normal "Reboot"
	sleep 1
	if [[ "$(ps --no-headers -o comm 1)" -eq "runit" ]] then
		loginctl reboot
	else 
		reboot
	fi
}

reboot() {
	notify-send -u normal "Logout"
	sleep 1
	if [[ "$(ps --no-headers -o comm 1)" -eq "runit" ]] then
		loginctl reboot
	else 
		reboot
	fi
}

case ${choise} in
	$SHUTDOWN_COMMAND)
		shutdown
		;;
	$RESTART_COMMAND)
		reboot
		;;
	$EXIT_COMMAND)
		pkill $WM
		;;
esac
