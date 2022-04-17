#! /bin/sh

print_memory_status() {
	local total_memory=$(grep MemTotal /proc/meminfo | grep -o -P "\d{1,}")
	local available_memory=$(grep MemAvailable /proc/meminfo | grep -o -P "\d{1,}")

	printf "\ntotal real memory        = ${total_memory}\n"
	echo "total available memory   = ${available_memory}"
}
print_os_info() {
	local os_name=$(uname -o)
	local os_distro=$(cat /etc/*-release | grep PRETTY_NAME.*)
	local os_version=$(uname -r | grep -o -P "\d{1,}.\d{1,}.\d{1,}")
	os_distro=${os_distro/PRETTY_NAME=/}

	printf "\n"
	if [[ "$1" != "user" ]]; then
		printf "${os_name} "
	fi
	printf "${os_distro//\"/} Rolling Release Version ${os_version}\n"
}
print_system_node() {
	local node=$(uname -n)
	printf "\nNode: ${node}\n"
	printf "The system is coming up. Please wait.\n"
	printf "The system is ready.\n\n"
}
print_copyrights() {
	printf "\nCopyright (c) 1991, 1992 Linus Torvalds\n"
	printf "Copyright (c) 1998-2021 Free Software Foundation, Inc.\n"
	printf "All Rights Reserved\n"
}
print_welcome_message() {
	local os_name=$(uname -o)
	local host_name=""
	local architecture=$(uname -m)

	if [[ ! $(which hostname) == "not found" ]]; then
		host_name=$(echo /etc/hostname)
	else
		host_name=$(hostname)
	fi

	printf "\nWelcome to the ${os_name} ${architecture} System\n"
	printf "System name: ${host_name}\n"
}
print_user_login_info() {
	printf "\nConsole Login: ${USER}\n"
	printf "Password: "
}
print_last_login() {
	local last_login=$(last ${USER} -n 1 --time-format full | head -n 1 | xargs)
	local login_date=$(grep -o -P "... ... *\d* ..:..:.." <<<${last_login} | head -n 1)
	local terminal_name=$(awk '{print $2}' <<<${last_login})
	echo "Last login: ${login_date} on ${terminal_name}"
}
main() {
	print_memory_status
	print_os_info
	print_copyrights
	# print_system_node
	print_welcome_message
	print_user_login_info
	print_os_info "user"
	print_last_login
}

main
