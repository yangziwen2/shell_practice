#!/bin/bash

# 使用普通数组和关联数组的例子

declare -A grade_dict
declare -A times_dict

while read line
do
	info=(`echo $line | cut -d' ' -f1,3`)
	name=${info[0]}
	grade=${info[1]}
	#grade_dict[$name]=$(( ${grade_dict[$name]} + $grade  ))
	let grade_dict[$name]+=grade
	let times_dict[$name]++
done < grades.txt

for name in ${!grade_dict[@]}
do
	echo "$name的平均分为$(( ${grade_dict[$name]} / ${times_dict[$name]}  )) "
done
