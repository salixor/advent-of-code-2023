#!/bin/bash

tmp=$(echo "$1" | sed -r "s/^[[:alpha:]]*([[:digit:]]{1})[[:alnum:]]*([[:digit:]]{1})[[:alpha:]]*$/\1\2/" | sed -r "s/^[[:alpha:]]*([[:digit:]]{1})[[:alpha:]]*$/\1\1/")

echo "$tmp" | awk '{ sum += $1 }; END { print sum }'
