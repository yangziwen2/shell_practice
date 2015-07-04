#!/bin/bash

monitor() {
	critical_value=$1
	ps aux | awk -v critical_value=$critical_value -v order_by=$order_by -v order_direct=$order_direct '
	function msort(arr, key_arr, order_direct) {
		order_direct = order_direct > 0? 1: -1
		i = 0
		for(key in arr) {
			key_arr[i] = key
			i ++
		}
		n = i
		for(i=n-1; i>0; i--) {
			for(j=0; j<i; j++) {
				key1 = key_arr[j]
				key2 = key_arr[j+1] 
				if(order_direct > 0 && arr[key1] <= arr[key2]) {
					continue
				} else if (order_direct < 0 && arr[key1] >= arr[key2]) {
					continue
				}
				key_arr[j+1] = key1
				key_arr[j] = key2
			}
		}
		return n
	}

	NR > 1 {
		user=$1
		cpu_used[user] += $3
		mem_used[user] += $4
		users[user] = user
	}
	END {
		color_red = "\033[31m"
		color_none = "\033[0m"
		output_tmpl = "%s%10.2f\033[0m |"
		sep_line = "+------------+-----------+-----------+"
		
		print sep_line
		printf "| %-10s |%10s |%10s |\n", "USER", "CPU%", "MEM%"
		print sep_line
		
		n = 0
		if(order_by == "c") {
			n = msort(cpu_used, sorted_users, order_direct)
		} else if (order_by == "m") {
			n = msort(mem_used, sorted_users, order_direct)
		} else {
			n = msort(users, sorted_users, order_direct)
		}

		for( i = 0; i < n; i++ ) {
			user = sorted_users[i]
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

order_direct=1 # 1:asc, -1:desc
order_by="u"

# press 'q' to exit
# press 'u' to sort result order by user
# press 'c' to sort result order by cpu usage
# press 'm' to sort result order by memory usage
read_key() {
	trap '' SIGINT
	read -n 1 -t 1 -s key_value
	case $key_value in
	q|Q)
		echo -ne "\033[?25h"
		exit 0
	;;
	u|U)
		if [ "$order_by" = "u" ]; then
			let order_direct*=-1
		else 
			order_direct=1
		fi
		order_by="u"
	;;
	c|C)
		if [ "$order_by" = "c" ]; then
			let order_direct*=-1
		else
			order_direct=-1
		fi
		order_by="c"
	;;
	m|M)
		if [ "$order_by" = "m" ]; then
			let order_direct*=-1
		else
			order_direct=-1
		fi
		order_by="m"
	;;
	esac
}

critical_value=$([ -z "$1" ] && echo "0" || echo "$1")
critical_value=`echo "$critical_value + 0" | bc`
[ $critical_value -eq 0 ] && critical_value=50


tput sc  # mark the cursor position
while [ 0 ]
do
	tput rc
	tput ed  # reset the cursor position
	monitor $critical_value
	read_key
done
