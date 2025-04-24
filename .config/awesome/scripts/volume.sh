#!/bin/env bash

is_muted="$(pactl get-sink-mute @DEFAULT_SINK@ | cut -d ' ' -f2)"

get_volume() {
	if [[ "$is_muted" == "yes" ]]; then
		echo "0"
	else
		echo "`pulsemixer --get-volume | cut -d' ' -f1`"
	fi
}

inc_volume() {
	if [[ "$is_muted" == "yes" ]]; then
		pactl set-sink-mute @DEFAULT_SINK@ 0
	fi
	pulsemixer --max-volume 100 --change-volume +5
	notify-send "Volume: `get_volume`"
}

dec_volume() {
	if [[ "$is_muted" == "yes" ]]; then
		pactl set-sink-mute @DEFAULT_SINK@ 0
	fi
	pulsemixer --max-volume 100 --change-volume -5
	notify-send "Volume: `get_volume`"
}

toggle_mute() {
	pactl set-sink-mute @DEFAULT_SINK@ toggle
}

if [[ "$1" == "--get" ]]; then
	get_volume
elif [[ "$1" == "--inc" ]]; then
	inc_volume
elif [[ "$1" == "--dec" ]]; then
	dec_volume
elif [[ "$1" == "--mute" ]]; then
	toggle_mute
else
	echo "unknown command"
fi