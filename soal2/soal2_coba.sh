#!/bin/bash

# get filename from input
old_IFS="$IFS"
IFS='.'
read -ra inp <<< "$1"
filename="${inp[0]}"
fileext="${inp[1]}"
IFS="$old_IFS"

offset=$((`date +"%H"`))
lower=( {a..z} )

tr_regex=${lower[$offset]}"-za-"${lower[$(($offset-1))]};
filename=`echo "$filename" | tr "a-z" $tr_regex`
filename="${filename}.${fileext}"

`echo $(bash soal2.sh) > $filename`
