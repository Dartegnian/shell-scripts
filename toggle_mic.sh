#! /usr/bin/env bash

toggle_mic_script_directory="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}";)" &> /dev/null && pwd 2> /dev/null;)"
export toggle_mic_script_directory

function query_pulseaudio() {
	local err_message=("No PulseAudio default source was found. Exiting." "Nothing was changed.")
	local default_source="$(pactl info | grep -P 'Default Source')"
	local mic_description=""
	default_source=${default_source/Default\ Source\: /}
	mic_description=$(pactl list sources | grep -A 1 $default_source | tail -n 1 | sed -E 's/Analog Stereo|Digital Stereo//g' | xargs)

	if [[ $default_source ]]; then
		query_microphone_mute_status "$default_source" "${mic_description/Description\: /}"
	else
		echo $err_message
		notify-send "$err_message" "${err_message[1]}"
	fi
}
function query_microphone_mute_status() {
	local mute_status=$(pactl list sources | grep -A 6 $1 | tail -n 1 | xargs)
	set_source_mute_status "${mute_status/Mute\: /}" "$1" "$2"
}
function set_source_mute_status() {
	local mute_action_type=""

	if [[ -f "/tmp/microphone-status-pid" ]]; then
		remove_systray_icon
	fi

	if [[ $1 == "yes" ]]; then
		pactl set-source-mute $2 false
		mute_action_type="unmuted"
	else
		pactl set-source-mute $2 true
		mute_action_type="muted"
		set_systray_icon
	fi

	send_desktop_notification "$mute_action_type" "$3"
}
function send_desktop_notification() {
	local header="Your microphone was $1"
	local description="The device $2 was $1"

	notify-send "$header" "$description"
	echo $description
}
function unmute_mic() {
	sh "$toggle_mic_script_directory/toggle_mic.sh"
}
export -f unmute_mic
function remove_systray_icon() {
	microphone_status_pid=$(cat /tmp/microphone-status-pid)
	kill -9 $microphone_status_pid
	rm /tmp/microphone-status-pid
}
function set_systray_icon() {
	yad --notification --command='bash -c unmute_mic' --image="${toggle_mic_script_directory}/assets/fa-microphone-slash.png" --listen &
	echo $! > /tmp/microphone-status-pid
}
function main() {
	query_pulseaudio
}

main
