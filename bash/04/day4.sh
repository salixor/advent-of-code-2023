line_regex="Card[[:blank:]]+([[:digit:]]+)\: (.*) \| (.*)"

function compare_strings() {
    found_matches=0
    numbers=($2)
    for number in "${numbers[@]}"; do
        regex="([[:blank:]]+|^)$number([[:blank:]]+|$)"
        [[ "$1" =~ $regex ]] && ((found_matches++))
    done
    echo "$found_matches"
}

function day4_part1() {
    sum=0
    while read l; do
        [[ $l =~ $line_regex ]]
        matches=$(compare_strings "${BASH_REMATCH[2]}" "${BASH_REMATCH[3]}")
        (( $matches > 0 )) && ((sum+=2**($matches-1)))
    done <<< "$1"
    echo "$sum"
}

function day4_part2() {
    sum=0
    instances=()
    while read l; do
        [[ $l =~ $line_regex ]]
        current_game="${BASH_REMATCH[1]}"

        ((sum+=${instances["$current_game"]:=1}))
        matches=$(compare_strings "${BASH_REMATCH[2]}" "${BASH_REMATCH[3]}")

        for (( i=$current_game+1; i <= $current_game + matches; i++ )); do
            instances["$i"]=$(( ${instances[$i]:=1} + ${instances["$current_game"]} ))
        done
    done <<< "$1"
    echo "$sum"
}

day4_part1 "$1"
day4_part2 "$1"
