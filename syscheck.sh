#!/bin/bash

set -e 

check_disk() {
	FILE_PATH="$1"
	USAGE=$(df -h "$FILE_PATH" | grep "/$" | awk '{print $5}')
	echo "Disk usage for $FILE_PATH: $USAGE"
}

check_users() {
	USERNAME="$1"
	who | grep "^$USERNAME"
}

check_memory() {
	free -h 
}

check_disk "/"
check_users "sammy"
check_memory
