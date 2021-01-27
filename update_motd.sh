#! /bin/sh

print_memory_status () {
	local total_memory=$(grep MemTotal /proc/meminfo | grep -o -P "\d{1,}")
	local available_memory=$(grep MemAvailable /proc/meminfo | grep -o -P "\d{1,}")

	printf "\ntotal real memory         = ${total_memory}\n"
	echo "total available memory    = ${available_memory}"
}
print_os_info () {
	local os_name=$(uname -o)
	local os_distro=$(cat /etc/*-release | grep PRETTY_NAME.* | grep -o -P "[^PRETTY_NAME=].*" | sed 's/"//g')
	local os_version=$(uname -r | grep -o -P "\d{1,}.\d{1,}.\d{1,}")
	printf "\n${os_name} ${os_distro} Rolling Release Version ${os_version}\n"
}
print_welcome_message () {
	local os_name=$(uname -o)
	local host_name=$(hostname)
	printf "\nWelcome to the ${os_name} System\n"
	printf "System name: ${host_name}\n"
}
print_user_login_info () {
	printf "\nConsole Login: ${USER}\n"
	printf "Password: "
}
print_last_login () {
	local login_date=$(last ${USER} -n 1 | grep -o -P "[^begins] ... ...  *\d* ..:.." | tr -s " ")
	local terminal_name=$(last $USER -n 1 | grep -o -P "^((?!wtmp).)*$" | awk '{print $2}')
	echo "Last login:${login_date} on ${terminal_name}"
}


print_memory_status;
print_os_info;
print_welcome_message;
print_user_login_info;
print_os_info;
print_last_login;
