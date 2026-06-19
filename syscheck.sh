#!/bin/bash

set -e 

check_disk() {
	FILE_PATH="$1"
	USAGE=$(df -h "$FILE_PATH" | grep "/$" | awk '{print $5}')
	TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
	if [[ "$USAGE" -ge 95% ]];then
		echo "$TIMESTAMP - Warning: Disk almost full $USAGE" | tee -a syscheck.log
		exit
	else
		echo "$TIMESTAMP - Disk usage for $FILE_PATH: $USAGE" | tee -a syscheck.log
		echo " " | tee -a syscheck.log
	fi
}

check_users() {
	USERNAME="$1"
	LOGGEDUSERS=$(who | grep "^$USERNAME")
	TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
	echo "$TIMESTAMP - Logged in sessions for $USERNAME:" | tee -a syscheck.log
	echo "$LOGGEDUSERS" | tee -a syscheck.log
	echo " " | tee -a syscheck.log
}

check_memory() {
	RAM=$(free -h)
	LOWRAM=$(echo "$RAM" | grep "^Mem" | awk '{print $7}') 
	TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
	if [[ "$LOWRAM" -le 1 ]];then
		echo "$TIMESTAMP - Warning: Low Memory $LOWRAM" | tee -a syscheck.log
        else
 		echo "$TIMESTAMP - Memory usage:" | tee -a syscheck.log
		echo "$RAM" | tee -a syscheck.log
		echo " " | tee -a syscheck.log
	fi
}


check_disk "/"
check_users "sammy"
check_memory
