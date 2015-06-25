#!/bin/bash

# 判断: 如果vsftpd启动，输出以下信息
#vsftpd服务器已启动...
#vsftpd监听的地址是:
#vsftpd监听的端口是:
#vsftpd监听的pid是:
#netstat -tnpl | grep vsftpd

info=`netstat -tnpl | grep vsftpd | sed 's/[ ][ ]*/ /g'`

if [ -z "$info" ]; then
	echo "vsftp未运行"
	exit 0
fi

local_addr=`echo $info | cut -d ' ' -f 4`
addr=${local_addr%:%}
port=${local_addr#*:}
pid=`echo $info | cut -d ' ' -f 7 | cut -d '/' -f 1`

cat << EOF
vsftpd服务器已启动...
vsftpd监听的地址是: $addr
vsftpd监听的端口是: $port
vsftpd的进程PID是: $pid
EOF
