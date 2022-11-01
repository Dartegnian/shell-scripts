#! /usr/bin/env bash

context=$(pwd)
git_directory="/home/${USER}/SYGtech/goteki-git/darts-dots"
device_category="pc"
distro_name=$(cat /etc/*-release | grep DISTRIB_ID.* | grep -o -P "[^DISTRIB_ID=].*" | sed 's/"//g'| awk '{print tolower($0)}')
computer_name="main-pc"
backup_folder_location="${git_directory}/${device_category}/${distro_name}-${computer_name}"
conf_folder_location="${backup_folder_location}/config"

programs=(
	alacritty
	alsa
	bspwm
	ckb-next
	miniplayer
	mpDris2
	nomacs
	picom
	sxhkd
	wal
	zsh
)

cd ${conf_folder_location}

for folder in "${programs[@]}"; do
	stow $folder -t ~/
done

chmod +x ~/.config/bspwm/*

cd "$context"
