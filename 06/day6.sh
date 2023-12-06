times_regex="Time: (.*)"
distances_regex="Distance: (.*)"

function day6() {
    times_line=${1%$'\n'*}
    distances_line=${1#*$'\n'}

    [[ $times_line =~ $times_regex ]]
    times=($(echo "${BASH_REMATCH[1]}"))

    [[ $distances_line =~ $distances_regex ]]
    distances=($(echo "${BASH_REMATCH[1]}"))

    prod=1
    for (( i=0; i < ${#times[@]}; i++ )); do
        max=$(echo "scale=0; (${times["$i"]} + sqrt(${times["$i"]}^2 - 1 - 4 * ${distances["$i"]} )) / 2" | bc)
        min=$(echo "scale=2; (${times["$i"]} - sqrt(${times["$i"]}^2 - 1 - 4 * ${distances["$i"]} )) / 2" | bc)
        min=$(echo "($min+1)/1" | bc)
        ((prod*=max-min+1))
    done
    echo "$prod"
}

day6 "$1"
