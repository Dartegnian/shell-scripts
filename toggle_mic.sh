#! /bin/sh

query_pulseaudio () {
	local default_source=$(pactl info | grep -P "Default Source" | sed 's/Default\ Source\: //g')
	printf "${default_source}\n"
	query_microphone_mute_status $default_source
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
}

query_pulseaudio
