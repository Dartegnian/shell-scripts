#! /usr/bin/env bash

function print_memory_status() {
	local total_memory=$(grep MemTotal /proc/meminfo | grep -o -P "\d{1,}")
	local available_memory=$(grep MemAvailable /proc/meminfo | grep -o -P "\d{1,}")

	printf "\ntotal real memory        = ${total_memory}\n"
	echo "total available memory   = ${available_memory}"
}
function get_os_release() {
	local distrib_release=$(cat /etc/*-release | grep -o -P DISTRIB_RELEASE.* | grep -o -P '[^DISTRIB_RELEASE="].*[^"]')
	local version_id=$(cat /etc/*-release | grep -o -P VERSION_ID.* | grep -o -P '[^VERSION_ID="].*[^"]')
	
	if [[ ! -z $distrib_release ]]; then
		echo $distrib_release
	elif [[ ! -z $version_id ]]; then
		echo $version_id
	fi
}
function print_os_info() {
	local os_name=$(uname -o)
	local os_distro=$(cat /etc/*-release | grep PRETTY_NAME.*)
	local os_version=$(uname -r | grep -o -P "\d{1,}.\d{1,}.\d{1,}")
	os_distro=${os_distro/PRETTY_NAME=/}
	local os_release=$(get_os_release)

	printf "\n"
	if [[ "$1" != "user" ]]; then
		printf "${os_name} "
	fi

	printf "${os_distro//\"/} Release ${os_release^} Version ${os_version}\n"
}
function print_system_node() {
	local node=$(uname -n)
	printf "\nNode: ${node}\n"
	printf "The system is coming up. Please wait.\n"
	printf "The system is ready.\n\n"
}
function print_copyrights() {
	printf "\nCopyright (c) 1991, 1992 Linus Torvalds\n"
	printf "Copyright (c) 1998-2021 Free Software Foundation, Inc.\n"
	printf "All Rights Reserved\n"
}
function get_hostname() {
	local cat_hostname=$(cat /etc/hostname)
	local command_hostname=$(hostname)

	if [[ ! -z $command_hostname ]]; then
		echo $command_hostname
	else
		echo $cat_hostname
	fi
}
function print_welcome_message() {
	local os_name=$(uname -o)
	local host_name=$(get_hostname)
	local architecture=$(uname -m)

	printf "\nWelcome to the ${os_name} ${architecture} System\n"
	printf "System name: ${host_name}\n"

	if [[ ! -z "$1" ]]; then
		local days_remaining=$(bash ~/SYGtech/goteki-git/shell-scripts/mortality.sh -d)
		printf "Days: ${days_remaining}\n"
	fi
		
}
function print_user_login_info() {
	printf "\nConsole Login: ${USER}\n"
	printf "Password: "
}
function print_last_login() {
	local last_login=$(last ${USER} -n 1 --time-format full | head -n 1 | xargs)
	local login_date=$(grep -o -P "... ... *\d* ..:..:.." <<<${last_login} | head -n 1)
	local terminal_name=$(awk '{print $2}' <<<${last_login})
	echo "Last login: ${login_date} on ${terminal_name}"
}
function main() {
	print_memory_status
	print_os_info
	print_copyrights
	# print_system_node
	print_welcome_message "days"
	print_user_login_info
	print_os_info "user"
	print_last_login
}

main
