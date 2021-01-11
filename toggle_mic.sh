#! /bin/sh

query_pulseaudio () {
	local default_source=$(pactl info | grep -P "Default Source" | sed 's/Default\ Source\: //g')
	printf "${default_source}\n"
	if [ -z "$default_source" ]; then
		echo "No PulseAudio default source was found. Exiting."
	else
		query_microphone_mute_status $default_source
	fi
}
query_microphone_mute_status () {
	local mute_status=$(pactl list sources | grep -C 6 $1 | tail -n 1)
	local is_muted=$(echo $mute_status | grep -P -o "[^Mute\: ].*")
	printf "${is_muted}\n"
	set_source_mute_status $is_muted $1
}
set_source_mute_status () {
	if [ $1 == "yes" ]; then
		$(pactl set-source-mute $2 false)
	else 
		$(pactl set-source-mute $2 true)
	fi

	send_desktop_notification $1 $2
}
send_desktop_notification () {
	local mute_action_type=""
	local mic_description=$(pactl list sources | grep -C 1 $2 | sed 's/Description\: //g' | sed -E -e 's/Analog Stereo|Digital Stereo//g' | tail -n 1 | xargs)

	if [ $1 == "yes" ]; then
		mute_action_type="unmuted"
	else 
		mute_action_type="muted"
	fi

	printf "${mic_description}\n"
	$(notify-send "Your microphone was ${mute_action_type}" "The device ${mic_description} was ${mute_action_type}")
}

query_pulseaudio
