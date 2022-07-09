#! /usr/bin/env bash

function restic_backup() {
	local directories=(
		"/mnt/hdd1/[DATA]/SFX/SFX"
		"/mnt/hdd2/[DATA]/Adobe PSD"
		"/mnt/hdd1/Pictures/Camera Roll/"
		"/mnt/hdd1/Pictures/Saved Folders/Screenshots/"
		"/mnt/hdd1/Pictures/Cloud Pictures/"
		"/mnt/hdd1/Pictures/Wallpapers/"
		"/mnt/hdd1/Documents/Cloud Documents/"
		"/mnt/hdd1/Videos/Cloud Videos/"
	)

	local tags=(
		"Archives"
		"PSDs"
		"Camera Roll"
		"Screenshots"
		"Pictures"
		"Wallpapers"
		"Documents"
	)

	echo "Backing up directories"
	for i in "${!directories[@]}"; do
		printf "\n\nBacking up directory ${directories[i]}\n"
		restic backup "--tag=${tags[i]}" "${directories[i]}"
	done
}
function restic_cleanup() {
	local snapshot_amount="2"
	restic forget --keep-last $snapshot_amount --prune
}
function main() {
	if [[ $USER == "root" ]]; then
		source /etc/restic-env
		restic_backup
		restic_cleanup
	else
		echo "Re-run as root."
	fi
}

main
