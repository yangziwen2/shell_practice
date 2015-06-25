#!/bin/bash

#写一个脚本，如果
#根分区剩余空间小于20%
#内存的已用空间大于80%
#向用户alice发送警告邮件，邮件内容包含使用率相关信息

mem_info=`free | grep Mem`
mem_used=`echo $mem_info | cut -d ' ' -f 3`
mem_total=`echo $mem_info | cut -d ' ' -f 2`

mem_percent=$(( $mem_used * 100 / $mem_total ))

if [ $mem_percent -ge 80 ]; then
	echo "内存已使用${mem_percent}%,使用率大于80%"
else 
	echo "内存已使用${mem_percent}%,使用率小于80%"
fi

disk_info=`df -P | grep /$`
disk_percent=`echo $disk_info | cut -d ' ' -f 5 `
disk_percent=${disk_percent%\%}

if [ $disk_percent -ge 80 ]; then
	echo "根分区已使用${disk_percent}%,剩余空间小于20%"
else
	echo "根分区已使用${disk_percent}%,剩余空间大于20%"
fi
