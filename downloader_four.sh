#! /usr/bin/env bash

function print_usage() {
	cat << EOF
Usage:
 downloader_four.sh [URL]
EOF
}
function download_thread() {
	local title_tag=$(curl $1 | grep -oP "(?<=<title>).*(?=<\/title>)")
	local download_directory="/home/$USER/Downloads"
	local directory_name=$(echo $title_tag | grep -oP -m 1 "(?<=- )([^-]+)(?= -)" | head -1)
	local directory_name="${directory_name/\//-}"

	wget -P "$download_directory/$directory_name" -nd -r -l 1 -H -D i.4cdn.org,is2.4chan.org -A png,gif,jpg,jpeg,webm -R '?????????????s.*' $1
}
function main() {
	if [[ $1 ]]; then
		download_thread $1
	else
		print_usage
	fi
}

main $1
