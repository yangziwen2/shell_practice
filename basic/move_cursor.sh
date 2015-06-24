#/bin/bash

line_pos=$(( `tput lines` / 2 ))
col_pos=$(( `tput cols` / 2 ))

step=1

while [ 0 ]
do
	clear
	tput cup $line_pos $col_pos
	printf '#'
	tput cup $line_pos $col_pos
	read -n 1 pressed_key &> /dev/null

	lines=$((`tput lines` - 1))
	cols=$((`tput cols` - 1))

	case $pressed_key in 
	'a')
		[ $col_pos -gt 0 ] && let col_pos-=$step
	;;
	'd')
		let col_pos+=$step
	;;
	'w')
		[ $line_pos -gt 0 ] && let line_pos-=$step
	;;
	's')
		let line_pos+=$step
	;;
	'q')
		clear
		tput cup $lines 0
		exit 0
	;;
	*)
	;;
	esac
	[ $line_pos -gt $lines ] && line_pos=$lines
	[ $col_pos -gt $cols ] && col_pos=$cols
done

