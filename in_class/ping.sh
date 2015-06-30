#!/bin/bash

# a simple case of concurrent process

pid_arr=()
for ip_suffix in `seq 141 145`
do
	ip="192.168.230.$ip_suffix"
	(
	ping -c 1 $ip &> /dev/null
	[ $? -eq 0 ] && echo "$ip is up" || echo "$ip is down"
	)&
	pid_arr+=("$!")
done
wait ${pid_arr[@]}
echo "process finished"
