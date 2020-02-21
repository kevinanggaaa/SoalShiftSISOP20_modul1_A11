#!/bin/bash
# random string with lower, upper, number

lower=( {a..z} )
upper=( {A..Z} )
num=( {0..9} )
all=( "${lower[@]}" "${upper[@]}" "${num[@]}" )

#random 1 number
idx=$(($RANDOM % 10))
pass_res+="${num[$idx]}"
#random 1 upper
idx=$(($RANDOM % 26))
pass_res+="${lower[$idx]}"
#random 1 lower
idx=$(($RANDOM % 26))
pass_res+="${upper[$idx]}"

for i in {1..30}; do
  idx=$(($RANDOM % 62))
  pass_res+="${all[$idx]}"
done

pass_res=`echo "$pass_res" | sed 's/./&\n/g' | shuf | tr -d '\n'`

echo "$pass_res"
