#!/bin/bash

# bubble sort
function sort1 {
	arr=($@)
	l=${#arr[@]}

	for ((i=l-1;i>0;i--))
	do
		for ((j=0;j<i;j++)) 
		do
			k=$(($j+1))
			if ((${arr[$j]} > ${arr[$k]}))
			then
				tmp=${arr[$j]}
				arr[$j]=${arr[$k]}
				arr[$k]=$tmp
			fi
		done
	done
	echo ${arr[@]}
}

function sort2 {
	arr=($@)
	l=${#arr[@]}

	for ((i=l; i>1; i--))
	do
		max_val=${arr[0]}
		max_idx=0
		for ((j=1; j<i; j++))
		do
			if ((${arr[$j]} > $max_val))
			then
				max_val=${arr[$j]}
				max_idx=$j
			fi
		done
		let j-=1
		arr[$max_idx]=${arr[$j]}
		arr[$j]=$max_val
	done
	echo ${arr[@]}
}

# quick sort
function sort3 {
	arr=($@)
	len=${#arr[@]}
	depth=0
	# there is no local scope for variables
	# so use an array as the stack to store params
	offsets[$depth]=0
	lens[$depth]=$len
	let depth+=1

	function quicksort {
		let depth-=1
		offset=${offsets[$depth]}
		len=${lens[$depth]}

		# echo $offset $len $depth
		# echo ${arr[@]}
		# echo -------------

		if (( $len <= 1 ))
		then 
			return
		fi
		begin_idx=$offset
		end_idx=$(($offset+$len-1))
		i=$begin_idx
		j=$end_idx
		flag=0
		v=${arr[$i]}
		#echo $v
		while (( i < j ))
		do
			if (( $flag == 0 ))
			then
				if (( $v > ${arr[$j]} )) 
				then
					# tmp=${arr[$i]}
					arr[$i]=${arr[$j]}
					# arr[$j]=$tmp
					let i+=1
					flag=1
				else
					let j-=1
				fi
			else
				if (( ${arr[$i]} > $v ))
				then
					# tmp=${arr[$i]}
					# arr[$i]=${arr[$j]}
					arr[$j]=${arr[$i]}
					let j-=1
					flag=0
				else
					let i+=1
				fi
			fi
		done
		arr[i]=$v
		
		# right section
		offsets[$depth]=$(($i+1))
		lens[$depth]=$(($end_idx - $i))
		let depth+=1
		# left section
		offsets[$depth]=$((begin_idx))
		lens[$depth]=$(($i-$begin_idx))
		let depth+=1
		quicksort
		quicksort
		# quicksort $begin_idx $(($i-$begin_idx))
		# quicksort $(($i+1)) $(($end_idx - $i ))
	}

	quicksort 0 $len

	echo ${arr[@]}

}


sort3 $@
