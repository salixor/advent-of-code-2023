#!/bin/sh

declare -rA max=(["red"]="12" ["green"]="13" ["blue"]="14")
set_regex="[[:space:]]?([[:digit:]]+)[[:space:]]([[:alpha:]]+).*"
line_regex="Game ([[:digit:]]+): (.*)"

function handle_line_part1() {
    while IFS=';'; read -ra ADDR; do
        for i in "${ADDR[@]}"; do
            while IFS=","; read -ra COL_WITH_VAL; do
				for j in "${COL_WITH_VAL[@]}"; do
					if [[ $j =~ $set_regex ]]; then
						number=${BASH_REMATCH[1]}
						color=${BASH_REMATCH[2]}
						if [ "$number" -gt "${max["$color"]}" ]; then
							return 1
						fi
					fi
				done
			done <<< "$i"
        done
    done <<< "$1"
}

function handle_line_part2() { 
    declare -A balls=(["red"]="0" ["green"]="0" ["blue"]="0")
    while IFS=';'; read -ra ADDR; do
        for i in "${ADDR[@]}"; do
			while IFS=","; read -ra COL_WITH_VAL; do
				for j in "${COL_WITH_VAL[@]}"; do
					if [[ $j =~ $set_regex ]]; then
						count=${BASH_REMATCH[1]}
						color=${BASH_REMATCH[2]}
						balls["$color"]=$(( $count > ${balls["$color"]} ? $count : ${balls["$color"]} ))
					fi
				done
			done <<< "$i"
        done
    done <<< "$1"
    echo $((balls["red"] * balls["blue"] * balls["green"]))
}

function day2() {
	sum_part_1=0
	sum_part_2=0

	while read l; do
		if [[ $l =~ $line_regex ]]; then
			game_id=${BASH_REMATCH[1]}
			curr_set=${BASH_REMATCH[2]}

			handle_line_part1 "$curr_set"
			is_valid=$?
			if [ $is_valid -eq 0 ]; then
				sum_part_1=$((sum_part_1 + game_id))
			fi

			power=$(handle_line_part2 "$curr_set")
			sum_part_2=$((sum_part_2 + power))
		fi
	done <<< "$1"

	echo $sum_part_1
	echo $sum_part_2
}

day2 "$1"
