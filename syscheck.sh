#!/bin/bash

set -e 

check_disk() {
	FILE_PATH="$1"
	df -h "$FILE_PATH"
}

check_users() {
	who 
}

check_memory() {
	free -h 
}

check_disk "/"
check_users
check_memory
