#! /usr/bin/env bash

function restic_backup() {
	local directories=(
		"/mnt/hdd1/[DATA]/SFX/SFX"
		"/mnt/hdd2/[DATA]/Adobe PSD"
		"/mnt/hdd1/Pictures/Saved Folders/Camera Roll"
	)

	local tags=(
		"Archives"
		"PSDs"
		"Camera Roll"
	)

	for i in "${!directories[@]}"; do
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
