#!/usr/bin/env bats

setup() {
	source ./syscheck.sh
}

@test "Warning: Disk almost full" {
	df() {
		echo "Filesystem      Size  Used Avail Use% Mounted on"
		echo "/dev/sda1       92G   34G   54G  95%  /"
	}
	export -f df 
	run check_disk
	[[ "$output" = *"95"* ]]
}

@test "Logged in sessions for user" {
	run check_users sammy
	[[ "$output" == *"sammy"* ]]
}

@test "Warning: Low Memory" {
	free() {
		echo "               total        used        free      shared  buff/cache   available"
                echo "Mem:         7916644     3807456     2691556      607880     2307276     1000"
	}
	export -f free
	run check_memory	
	[[ "$output" == *"Warning: Low Memory"* ]]
}

@test "Process not running" {
	ps() {
		echo "USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND"
		echo "root           1  0.0  0.1  24648 15344 ?        Ss   07:51   0:01 /sbin/init"
		echo "sammy        99		          0.1                       0.5     nginx"
	}
	export -f ps
	run check_process ssh
	[[ "$output" == *"NOT RUNNING"* ]]
}

