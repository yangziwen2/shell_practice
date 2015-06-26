#!/bin/bash

bound=$1
[ -z "$bound" ] && bound=0
bound=$(echo "$bound + 0" | bc)
[ $bound -eq 0 ] && bound=100

start_time=`date +%s`

prime_arr=(2)
n=1

echo -n "2"

for ((i=3; i<=$bound; i+=2 ))
do
	for j in ${prime_arr[@]}
	do
		[ $(( $j * $j )) -gt $i ] && break
		[ $(( $i % $j )) -eq 0 ] && continue 2
	done

	prime_arr[$n]=$i
	let n++
	echo -n " $i"
done

echo ""

end_time=`date +%s`

echo "spend $(($end_time - $start_time)) s"
