#!/bin/bash

monitor() {
	ps aux | tail -n +2 | awk '
	{
		user=$1
		cpu_used[user] += $3
		mem_used[user] += $4
	}
	END {
		color_red = "\033[31m"
		color_none = "\033[0m"
		output_tmpl = "%s%10.2f\033[0m |"
		critical_value = 50
		sep_line = "+------------+-----------+-----------+"
		
		print sep_line
		printf "| %-10s |%10s |%10s |\n", "USER", "CPU%", "MEM%"
		print sep_line

		for ( user in cpu_used ) {
			printf "| %-10s |", user

			color = cpu_used[user] >= critical_value? color_red: color_none
			printf output_tmpl, color, cpu_used[user]
			
			color = mem_used[user] >= critical_value? color_red: color_none
			printf output_tmpl, color, mem_used[user]

			printf "\n"
		}
		print sep_line
	}
	'
}

read_key() {
	trap '' SIGINT
	read -n 1 -t 1 -s key_value
	if [ "$key_value" = "q" -o "$key_value" = "Q" ]; then
		echo -ne "\033[?25h"
		exit 0
	fi
}

tput sc  # mark the cursor position
while [ 0 ]
do
	tput rc
	tput ed  # reset the cursor position
	monitor
	read_key
done
