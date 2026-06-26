#!/bin/bash

set -e 

LOGFILE="$HOME/linux-syscheck/syscheck.log"

# function to check disk usage
check_disk() {
	FILE_PATH="$1"
	USAGE=$(df -h "$FILE_PATH" | grep "/$" | awk '{print $5}')
	CLEAN_USAGE=$(echo "$USAGE" | sed s/%//)
	TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
	if [[ "$CLEAN_USAGE" -ge 95 ]];then
		echo "$TIMESTAMP - Warning: Disk almost full $USAGE" | tee -a "$LOGFILE"
		exit
	else
		echo "$TIMESTAMP - Disk usage for $FILE_PATH: $USAGE" | tee -a "$LOGFILE"
		echo " " | tee -a "$LOGFILE"
	fi
}

# function to check logged in users
check_users() {
	USERNAME="$1"
	LOGGEDUSERS=$(who | grep "^$USERNAME")
	TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
	echo "$TIMESTAMP - Logged in sessions for $USERNAME:" | tee -a "$LOGFILE"
	echo "$LOGGEDUSERS" | tee -a "$LOGFILE"
	echo " " | tee -a "$LOGFILE"
}

# function to check memory usage
check_memory() {
	RAM=$(free -h)
	AVAILABLE_MB=$(free -m | grep "^Mem" | awk '{print $7}') 
	TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
       	if [[ "$AVAILABLE_MB" -le 1000 ]];then
		echo "$TIMESTAMP - Warning: Low Memory ${AVAILABLE_MB}MB available" | tee -a "$LOGFILE"
        else
 		echo "$TIMESTAMP - Memory usage:" | tee -a "$LOGFILE"
		echo "$RAM" | tee -a "$LOGFILE"
		echo " " | tee -a "$LOGFILE"
	fi
}

# function to check running process
check_process() {
	PROCESS=$1
	TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
	if [[ -z "$PROCESS" ]];then
		echo "$TIMESTAMP - Service Name Required" | tee -a "$LOGFILE"
	else
		RUNNING=$(ps aux | grep "$PROCESS" | grep -v grep || true)
		if [[ -z "$RUNNING" ]];then
			echo "$TIMESTAMP - $PROCESS NOT RUNNING" | tee -a "$LOGFILE"
		else
			echo "$TIMESTAMP - $PROCESS RUNNING" | tee -a "$LOGFILE"
			echo "" | tee -a "$LOGFILE"
		fi
	fi
}

# required flags
for arg in "$@";do
	if [[ "$arg" == --disk ]];then
		check_disk "/"
	elif [[ "$arg" == --users ]];then
		check_users "sammy"
	elif [[ "$arg" == --memory ]];then
		check_memory
	elif [[ "$arg" == --process ]];then
		check_process "ssh"
	elif [[ "$arg" == --all ]];then
		check_disk "/"	
		check_users "sammy"
		check_memory 
		check_process "ssh"
	else
		echo "Invalid Entry"
	fi
done
