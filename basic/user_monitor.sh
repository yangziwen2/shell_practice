#!/bin/bash

# 监控系统中每个用户的cpu和内存的使用情况

pad_left() {
	content=$1
	width=$2
	placeholder=`[ -z "$3" ] && echo " " || echo "$3"`
	content_len=`[ -z "$4" ] && echo "${#content}" || echo "$4" `
	echo -ne "$content"
	for (( i=0; i<$(($width - ${content_len})); i++ )); do echo -n "$placeholder"; done;
}

pad_right() {
	content=$1
	width=$2
	placeholder=`[ -z "$3" ] && echo " " || echo "$3"`
	content_len=`[ -z "$4" ] && echo "${#content}" || echo "$4" `
	for (( i=0; i<$(($width - ${content_len})); i++ )); do echo -n "$placeholder"; done;
	echo -ne "$content"
}

output_sep_line() {
	pad_left "+" 10 "-"
	echo -n "+"
	pad_right "+" 10 "-"
	pad_right "+" 10 "-"
	echo ""
}

add_color() {
	content=$1
	color=$2
	echo -n "\033[${color}m${content}\033[0m"
}

monitor() {

	is_head=0
	declare -A cpu_stats
	declare -A mem_stats

	ps_arr=(`ps aux | awk '{print $1,$3,$4}'`)
	arr_len=${#ps_arr[@]}
	cols_per_line=3
	line_num=$(( $arr_len / $cols_per_line ))

	for ((i=0; i<$line_num; i++ ))
	do
		idx=$(( $cols_per_line * $i ))
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

	output_sep_line	

	pad_left "| USER" 10
	echo -n "|"
	pad_right "CPU% |" 10
	pad_right "MEM% |" 10
	echo ""

	output_sep_line

	for user in ${!cpu_stats[@]}
	do
		cpu_usage=`printf "%.2f" ${cpu_stats[$user]}`
		mem_usage=`printf "%.2f" ${mem_stats[$user]}`
		critical_value=$1
		colored_cpu_usage=$([ `printf "%.0f" $cpu_usage` -ge $critical_value ] && add_color ${cpu_usage} 31 || echo $cpu_usage)
		colored_mem_usage=$([ `printf "%.0f" $mem_usage` -ge $critical_value ] && add_color ${mem_usage} 31 || echo $mem_usage)

		pad_left "| $user" 10
		echo -n "|"
		pad_right "$colored_cpu_usage |" 10 " " $(( ${#cpu_usage} + 2))
		pad_right "$colored_mem_usage |" 10 " " $(( ${#mem_usage} + 2))
		echo ''
	done

	output_sep_line
}

# highlight the user whose usage of cpu or memory is higher than the critical value
critical_value=$([ -z "$1" ] && echo "0" || echo "$1")
critical_value=`echo "$critical_value + 0" | bc`
[ $critical_value -eq 0 ] && critical_value=50	# use 50 as default value

while [ 0 ]; do
	monitor	$critical_value
	sleep 1
done
