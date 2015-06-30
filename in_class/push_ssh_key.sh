#!/bin/bash

read -p "Please input password:" password
pid_arr=()
for ip in $@
do
	/usr/bin/expect << ZYANG
	spawn ssh-copy-id -i $ip
	expect {
		"*yes/no" {send "yes\r"; exp_continue}
		"*password:" {send "${password}\r"}
	}
	expect eof
ZYANG
done

wait ${pid_arr[@]}

echo "push ssh key finished"
