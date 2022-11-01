#! /usr/bin/env bash

function print_usage() {
	cat << EOF
Usage:
 screenshot_main.sh [option]

Options:
 -s, --screen		Take a full screen screenshot and save to disk
 -t, --screen-temp	Take a full screen screenshot and save to /tmp
 -a, --area		Take a screenshot of an area on the screen
 -h, --help		Print the program usage

All options (except help) copy the screenshot to your clipboard.
EOF
}
function set_global_variables() {
	timestamp=$(date +%Y-%m-%d--%H-%M-%S)

	kernel_name=$(uname -s | tr '[:upper:]' '[:lower:]')
	file_suffix=""
	params=""
	location=""

	os_name=$(cat /etc/*-release | grep PRETTY_NAME.* | tr '[:upper:]' '[:lower:]')
	os_name=${os_name/pretty_name=/}
	os_name=${os_name//\"/}
	os_name=${os_name/ $kernel_name/}
}
function decipher_params() {
	case $1 in
		-s|--screen)
			params="-m 10 -f png"
			file_suffix="-screen.png"
			location="/home/$USER/Pictures/Saved Folders/Screenshots/Arch Linux"
			take_screenshot
			;;
		-t|--screen-temp)
			params="-m 10 -f png"
			file_suffix="-screenshot.png"
			location="/tmp"
			take_screenshot
			;;
		-a|--area)
			params="-s -m 10 -f png"
			file_suffix="-screencap.png"
			location="/tmp"
			take_screenshot
			;;
		-h|--help)
			print_usage
			;;
		*)
			printf "Invalid option: $1\n\n"
			print_usage
			;;
	esac
}
function take_screenshot() {
	file_name="${timestamp}-${os_name}-${kernel_name}-${file_suffix}"

	maim $params "$location"/$file_name
	sleep 0.5
	xclip -selection clipboard -t image/png "$location"/$file_name
}
function main() {
	if [[ $1 ]]; then
		set_global_variables
		decipher_params $1
	else
		print_usage
	fi
}

main $1
