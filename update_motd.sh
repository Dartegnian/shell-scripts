#! /bin/sh

print_memory_status () {
	local total_memory=$(grep MemTotal /proc/meminfo | grep -o -P "\d{1,}")
	local available_memory=$(grep MemAvailable /proc/meminfo | grep -o -P "\d{1,}")

	echo "total real memory         = ${total_memory}"
	echo "total available memory    = ${available_memory}"
}

print_memory_status;
