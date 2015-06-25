#!/bin/bash

# 判断vsftpd软件包是否安装，如果没有，则自动安装

result=`rpm -qa | grep vsftpd`
if [ ${#result} -gt 0 ]; then
	echo "vsftpd已安装"
else 
	echo "vsftpd未安装,开始安装..."
	`yum install vsftpd -y &> /dev/null` 
	if [ $? -eq 0 ]; then
		echo "vsftpd安装成功"
	else 
		echo "vsftpd安装失败"
	fi
fi
