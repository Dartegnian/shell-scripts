#! /bin/sh

query_pulseaudio() {
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
query_microphone_mute_status() {
	local mute_status=$(pactl list sources | grep -A 6 $1 | tail -n 1 | xargs)
	set_source_mute_status "${mute_status/Mute\: /}" "$1" "$2"
}
set_source_mute_status() {
	local mute_action_type=""

	if [[ $1 == "yes" ]]; then
		pactl set-source-mute $2 false
		mute_action_type="unmuted"
	else
		pactl set-source-mute $2 true
		mute_action_type="muted"
	fi

	send_desktop_notification "$mute_action_type" "$3"
}
send_desktop_notification() {
	notify-send "Your microphone was $1" "The device $2 was $1"
}
main() {
	query_pulseaudio
}

main
