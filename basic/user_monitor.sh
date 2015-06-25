#!/bin/bash

pad_left() {
	content=$1
	width=$2
	placeholder=$3
	[ -z "$placeholder" ] && placeholder=" "
	echo -n "$content"
	for (( i=0; i<$(($width - ${#content})); i++ )); do echo -n "$placeholder"; done;
}

pad_right() {
	content=$1
	width=$2
	placeholder=$3
	[ -z "$placeholder" ] && placeholder=' '
	for (( i=0; i<$(($width - ${#content})); i++ )); do echo -n "$placeholder"; done;
	echo -n "$content"
}

write_sep_line() {
	pad_left "+" 10 "-"
	echo -n "+"
	pad_right "+" 10 "-"
	pad_right "+" 10 "-"
	echo ""
}

monitor() {

	is_head=0
	declare -A cpu_stats
	declare -A mem_stats

	ps_arr=(`ps aux | awk '{print $1,$3,$4}'`)
	arr_len=${#ps_arr[@]}
	col_per_line=3
	line_num=$(( $arr_len / $col_per_line ))

	for ((i=0; i<$line_num; i++ ))
	do
		idx=$(( $col_per_line * $i ))
		info=(`echo ${ps_arr[@]:$idx:3}`)
		if [ $is_head -eq 0 ]; then
			is_head=1
			continue
		fi
		user=${info[0]}	
		cpu_percent=${info[1]}
		mem_percent=${info[2]}
		[ -z ${cpu_stats[$user]} ] && cpu_stats[$user]=0
		[ -z ${mem_stats[$user]} ] && mem_stats[$user]=0
	
		summed_cpu_percent=`echo "${cpu_stats[$user]} + $cpu_percent" | bc`
		summed_mem_percent=`echo "${mem_stats[$user]} + $mem_percent" | bc`
		cpu_stats[$user]=$summed_cpu_percent
		mem_stats[$user]=$summed_mem_percent
	done 

	clear

	write_sep_line	

	pad_left "| USER" 10
	echo -n "|"
	pad_right "CPU% |" 10
	pad_right "MEM% |" 10
	echo ""

	write_sep_line

	for user in ${!cpu_stats[@]}
	do
		pad_left "| $user" 10
		echo -n "|"
		pad_right "${cpu_stats[$user]} |" 10
		pad_right "${mem_stats[$user]} |" 10
		echo ''
	done

	write_sep_line
}

while [ 0 ]; do
	monitor	
	sleep 1
done
