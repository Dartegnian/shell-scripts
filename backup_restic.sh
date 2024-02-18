#! /usr/bin/env bash

function restic_backup() {
	local directories=(
		"/mnt/hdd1/[DATA]/SFX/SFX"
		"/mnt/hdd2/[DATA]/Adobe PSD"
		"/mnt/hdd1/[DATA]/Cloud Data"
		"/mnt/hdd1/Pictures/Camera Roll/"
		"/mnt/hdd1/Pictures/Saved Pictures/"
		"/mnt/hdd1/Pictures/Saved Folders/Screenshots/"
		"/mnt/hdd1/Pictures/Cloud Pictures/"
		"/mnt/hdd1/Pictures/Wallpapers/"
		"/mnt/hdd1/Documents/Cloud Documents/"
		"/mnt/hdd1/Videos/Cloud Videos/"
		"/mnt/hdd1/Music/"
		"/home/dartegnian/SYGtech/icaras-interconnect/"
		"/home/dartegnian/SYGtech/goteki-git/"
		"/home/dartegnian/SYGtech/piranha-prototype/"
	)

	local tags=(
		"Archives"
		"PSDs"
		"General Data HDD 1"
		"Camera Roll"
		"Saved Pictures"
		"Screenshots"
		"Pictures"
		"Wallpapers"
		"Documents"
		"Videos"
		"Music"
		"SYG Icaras Backups"
		"Git Clones"
		"Production Sites"
	)

	echo "Backing up directories"
	for i in "${!directories[@]}"; do
		printf "\n\nBacking up directory ${directories[i]}\n"
		restic backup "--tag=${tags[i]}" "${directories[i]}"
	done
}
function restic_cleanup() {
	local snapshot_amount="10"
	restic forget --keep-last $snapshot_amount --prune
}
function main() {
	if [[ $USER == "root" ]]; then
		GOMAXPROCS=1
		source /etc/restic-env
		restic_backup
		restic_cleanup
	else
		echo "Re-run as root."
		exit 1
	fi
}

main
