#! /usr/bin/env bash

restic_backup() {
	local directories=(
		"/mnt/hdd1/[DATA]/SFX/SFX"
		"/mnt/hdd2/[DATA]/Adobe PSD"
	)

	local tags=(
		"Archives"
		"PSDs"
	)

	for i in "${!directories[@]}"; do
		restic backup "--tag=${tags[i]}" "${directories[i]}"
	done
}
main() {
	if [[ $USER == "root" ]]; then
		source /etc/restic-env
		restic_backup
	else
		echo "Re-run as root."
	fi
}

main
