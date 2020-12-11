#! /bin/sh

print_memory_status () {
	local total_memory=$(grep MemTotal /proc/meminfo | grep -o -P "\d{1,}")
	local available_memory=$(grep MemAvailable /proc/meminfo | grep -o -P "\d{1,}")

	echo "total real memory         = ${total_memory}"
	echo "total available memory    = ${available_memory}"
}
print_os_info () {
	local os_name=$(uname -o)
	local os_distro=$(uname -n)
	local os_version=$(uname -r | grep -o -P "\d{1,}.\d{1,}.\d{1,}")
	printf "\n${os_name} System ${os_distro} Rolling Release Version ${os_version}\n"
}

print_memory_status;
print_os_info;
