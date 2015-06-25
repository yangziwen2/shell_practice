#!/bin/bash

height=$1
if [[ ! $1 =~ ^[0-9]+$ ]]; then
	echo "Please input a valid number as the height of the tree!"
	exit 0
fi

for ((i=0; i<$height; i++ )); do 
	for ((j=0; j<$(($height - $i - 1)); j++ )); do
		echo -n " "
	done
	for ((j=0; j<$(($i * 2 + 1)) ; j++)); do
		echo -n "*"
	done
	echo ""
done

