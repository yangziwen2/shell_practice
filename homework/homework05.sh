#!/bin/bash

# 判断制定的主机是否能ping通，必须使用$1变量

ip=$1

if [ -z $ip ]; then
	echo "Please input a valid ip address!"
	exit 0
fi

ping -c1 $ip &> /dev/null

[ $? -eq 0 ] && echo "$ip is available" || echo "$ip is not available"
