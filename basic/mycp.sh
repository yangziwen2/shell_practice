#!/bin/bash

# Display the progress bar when copy a file

if [ $# -lt 2 ]; then
	echo "`basename $0` \"src file\" \"dst file\""
	exit
fi

src_file=$1
[ -d "$2" ] && dst_file="$2/`basename $1`" || dst_file=$2

if [ ! -f $src_file  ]; then
	echo "src file [$src_file] does not exist!"
	exit
fi

NANO_PER_MILLIS=1000000

total_size=`du -b $src_file | awk '{print $1}'`
prev_size=0
cur_size=0
cur_time=`date +%s%N`
prev_time=$cur_time

cp $src_file $dst_file &

cp_pid=$!

trap "kill `echo $cp_pid`;echo -e '\r\n'; exit 2;" INT

while [ 0 ]; do
	prev_time=$cur_time
	sleep 0.2
	cur_time=`date +%s%N`
	prev_size=$cur_size
	cur_size=`du -b $dst_file | awk '{print $1}'`
	left_size=$(( $total_size - $cur_size ))

	time_diff=$(( $cur_time - $prev_time ))
	size_diff=$(( $cur_size - $prev_size ))

	size_percent=$(( cur_size * 100 / total_size ))			#
	
	speed_per_milli=$(( size_diff * NANO_PER_MILLIS / time_diff ))
	[ $speed_per_milli -le 0 ] && speed_per_milli=1

	speed=$(( $speed_per_milli * 1000 ))					#
	speed_mb=$(( $speed / 1024 / 1024 ))

	left_time_sec=$(( $left_size / speed_per_milli /1000 ))	#

	echo -ne "\r"

	# echo -n "${size_percent}%, ${speed}b/s, ${left_time_sec}s"

	# progress bar
	echo -n "["
	for (( i=0; i<100; i+=2 )); do
		[ $i -le $size_percent ] && echo -n "#" || echo -n " "
	done
	echo -n "]"

	# progress percent
	for (( i=0; i<(5-${#size_percent}); i++ )); do echo -n " "; done;
	echo -n "${size_percent}%"

	# transfer speed
	for (( i=0; i<10-${#speed_mb}; i++ )); do echo -n " "; done;
	echo -n "${speed_mb} MB/s"

	# left time
	for (( i=0; i<10-${#left_time_sec}; i++ )); do echo -n " "; done;
	echo -n "${left_time_sec} s left"
	
	[ $total_size -eq $cur_size ] && echo "" && break

done
