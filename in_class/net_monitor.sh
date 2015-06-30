#!/bin/bash

declare -A network_cards
declare -A rec_bytes_dict
declare -A rec_packets_dict
declare -A send_bytes_dict
declare -A send_packets_dict

prepare() {
	while read line
	do
		infos=(`echo $line`)
		network_card="${infos[0]}"
		rec_bytes_dict[$network_card]=${infos[1]}
		rec_packets_dict[$network_card]=${infos[2]}
		send_bytes_dict[$network_card]=${infos[3]}
		send_packets_dict[$network_card]=${infos[4]}
	done <<< "$(cat /proc/net/dev |  tail -n +3 | sed 's/^[ ]\+//g' | awk  'BEGIN{FS="[: \t]+"} {print $1, $2, $3, $10, $11}')"
	# 上面这行的手法很重要，既可以保持引用结果的换行格式，又能保证循环中的作用域为全局引用
}

sep_line="+--------------+-----------------+-----------------+-----------------+-----------------+"

poll() {
	echo $sep_line
	printf "| %-12s | %15s | %15s | %15s | %15s| \n" "network" "rec_bytes/sec" "rec_packets/sec" "send_bytes/sec" "send_packets/sec"
	echo $sep_line
	while read line
	do
		infos=(`echo $line`)

		network_card="${infos[0]}"

		rec_bytes=${infos[1]}
		rec_packets=${infos[2]}
		send_bytes=${infos[3]}
		send_packets=${infos[4]}
		
		prev_rec_bytes=${rec_bytes_dict[$network_card]}
		prev_rec_packets=${rec_packets_dict[$network_card]}
		prev_send_bytes=${send_bytes_dict[$network_card]}
		prev_send_packets=${send_packets_dict[$network_card]}
	
		rec_bytes_per_sec=$(( $rec_bytes - $prev_rec_bytes ))
		rec_packets_per_sec=$(( $rec_packets - $prev_rec_packets ))
		send_bytes_per_sec=$(( $send_bytes - $prev_send_bytes ))
		send_packets_per_sec=$(( $send_packets - $prev_send_packets ))

		rec_bytes_dict[$network_card]=$rec_bytes
		rec_packets_dict[$network_card]=$rec_packets
		send_bytes_dict[$network_card]=$send_bytes
		send_packets_dict[$network_card]=$send_packets
		
		printf "| %-12s | %15d | %15d | %15d | %15d | \n" $network_card $rec_bytes_per_sec $rec_packets_per_sec $send_bytes_per_sec $send_packets_per_sec
	done <<< "$(cat /proc/net/dev | tail -n +3 | sed 's/^[ ]\+//g' | awk  'BEGIN{FS="[: \t]+"} {print $1, $2, $3, $10, $11}')"
	echo $sep_line
}

prepare
while [ 0 ]
do
	clear
	poll
	sleep 1
done

