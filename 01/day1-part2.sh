#!/bin/bash

tmp=$(echo "$1" | sed -e "s/oneight/18/g;s/twone/21/g;s/threeight/38/g;s/fiveight/58/g;s/sevenine/79/g;s/eightwo/82/g;s/eighthree/83/g;s/nineight/98/g;s/one/1/g;s/two/2/g;s/three/3/g;s/four/4/g;s/five/5/g;s/six/6/g;s/seven/7/g;s/eight/8/g;s/nine/9/g")
tmp=$(./day1-part1.sh "$(echo "$tmp")")

echo $tmp
