line_regex='Card.*([[:digit:]]+): (.*) \| (.*)'

function compare_strings() {
    found_matches=0
    while IFS=" "; read -ra numbers; do
        for number in "${numbers[@]}"; do
            regex="([[:blank:]]+|^)$number([[:blank:]]+|$)"
            if [[ "$1" =~ $regex ]]; then
                ((found_matches++))
            fi
        done
    done <<< "$2"
    echo "$found_matches"
}

function day4() {
    sum=0
    while read l; do
        if [[ $l =~ $line_regex ]]; then
            matches=$(compare_strings "${BASH_REMATCH[2]}" "${BASH_REMATCH[3]}")
            if (( $matches > 0 )); then
                sum=$(( $sum + 2 ** ($matches - 1) ))
            fi
        fi
    done <<< "$1"
    echo "$sum"
}

day4 "$1"
