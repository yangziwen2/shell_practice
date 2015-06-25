#!/bin/bash

# 判断一个用户是否存在

username=$1

if [ -z $username ]; then
	echo "请输入有效的用户名"
	exit 0
fi

line=`cat /etc/passwd | grep ^${username}:`

if [ -z $line  ]; then
	echo -e "用户[\033[31m$username\033[0m]不存在"
else 
	echo -e "用户[\033[32m$username\033[0m]存在"
fi
