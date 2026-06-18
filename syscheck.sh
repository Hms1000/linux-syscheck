#!/bin/bash

set -e 

check_disk() {
	FILE_PATH="$1"
	USAGE=$(df -h "$FILE_PATH" | grep "/$" | awk '{print $5}')
	TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
	echo "$TIMESTAMP - Disk usage for $FILE_PATH: $USAGE" >> syscheck.log
	echo "$TIMESTAMP - Disk usage for $FILE_PATH: $USAGE"
	echo " " >> syscheck.log
	echo " " 
}

check_users() {
	USERNAME="$1"
	LOGGEDUSERS=$(who | grep "^$USERNAME")
	TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
	echo "$TIMESTAMP - Logged in sessions for $USERNAME:">> syscheck.log 
	echo "$LOGGEDUSERS" >> syscheck.log
	echo "$TIMESTAMP - Logged in sessions for $USERNAME:"
       	echo "$LOGGEDUSERS"
	echo " " >> syscheck.log
        echo " "
}

check_memory() {
	RAM=$(free -h)
	TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
	echo "$TIMESTAMP - Memory usage:" >> syscheck.log
	echo "$RAM" >> syscheck.log
        echo "$TIMESTAMP - Memory usage:" 
        echo "$RAM"       	
	echo " " >> syscheck.log
}

check_disk "/"
check_users "sammy"
check_memory
