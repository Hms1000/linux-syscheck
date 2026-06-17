#!/bin/bash

set -e 

check_disk() {
	FILE_PATH="$1"
	df -h "$FILE_PATH"
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
