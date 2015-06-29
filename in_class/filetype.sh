#!/bin/bash

# stats the number of files with the same type inside a folder[$1]

path=$1

ls -Rl $path | awk 'BEGIN {
	folder="."
} $1 ~ /:$/ {
	split($1, arr, ":")
	folder=arr[1]
} $1 ~ /^-/ {
	i = 9
	filepath = folder"/"$i
	while(i<NF) {
		i++
		filepath = filepath" "$i
	}
	printf "%s \"%s\"\n", "file", filepath
}' | sh | awk -F: '{print $2}' | awk '{print $1}' | sort | uniq -c | sort -n -r | awk '{printf "%-15s%6d\n", $2, $1}'

