#! /bin/sh

timestamp=$(date +%Y-%m-%d--%H-%M-%S)

take_screenshot() {
	local kernel_name=$(uname -s | tr '[:upper:]' '[:lower:]')
	local file_suffix=""
	local params=""
	local location=""
	local os_name=$(cat /etc/*-release | grep PRETTY_NAME.* | tr '[:upper:]' '[:lower:]')
	os_name=${os_name/pretty_name=/}
	os_name=${os_name//\"/}
	os_name=${os_name/ $kernel_name/}

	if [[ $1 == "screen" ]]; then
		params="-m 10 -f png"
		file_suffix="-screen.png"
		location="/home/$USER/Pictures/Saved Folders/Screenshots/Arch Linux"
	elif [[ $1 == "screen-temp" ]]; then
		params="-m 10 -f png"
                file_suffix="-screenshot.png"
                location="/tmp"
	elif [[ $1 == "area" ]]; then
		params="-s -m 10 -f png"
		file_suffix="-screencap.png"
		location="/tmp"
	fi

	local file_name="${timestamp}-${os_name}-${kernel_name}-${file_suffix}"

	maim $params "$location"/$file_name
	sleep 0.5
	xclip -selection clipboard -t image/png "$location"/$file_name
}

take_screenshot $1

