times_regex="Time: (.*)"
distances_regex="Distance: (.*)"

function get_min_to_zero() {
    min=$(echo "scale=2; ($1 - sqrt($1^2 - 1 - 4 * $2 )) / 2" | bc)
    min=$(echo "($min+1)/1" | bc)
    echo "$min"
}

function get_max_to_zero() {
    echo "scale=0; ($1 + sqrt($1^2 - 1 - 4 * $2 )) / 2" | bc
}

function get_range_of_values_to_zero() {
    time=$1
    distance=$2
    min=$(get_min_to_zero "$time" "$distance")
    max=$(get_max_to_zero "$time" "$distance")
    echo "$((max-min+1))"
}

function day6() {
    times_line=${1%$'\n'*}
    distances_line=${1#*$'\n'}

    [[ $times_line =~ $times_regex ]]
    times=($(echo "${BASH_REMATCH[1]}"))
    kerning_time=$(echo "${times[@]}" | sed "s/[[:space:]]//g")

    [[ $distances_line =~ $distances_regex ]]
    distances=($(echo "${BASH_REMATCH[1]}"))
    kerning_distance=$(echo "${distances[@]}" | sed "s/[[:space:]]//g")

    prod=1
    for (( i=0; i < ${#times[@]}; i++ )); do
        range=$(get_range_of_values_to_zero "${times["$i"]}" "${distances["$i"]}")
        ((prod*=range))
    done
    echo "$prod"

    get_range_of_values_to_zero "$kerning_time" "$kerning_distance"
}

day6 "$1"
