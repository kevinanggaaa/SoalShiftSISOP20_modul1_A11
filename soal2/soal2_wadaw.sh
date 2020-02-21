#!/bin/bash

# get password
password=`cat $1`

## prepare decode ROT cypher

# get offset
offset=$((`date -r "$1" "+%H"`))

# get filename from command line argument
old_IFS="$IFS"
IFS='.'
read -ra inp <<< "$1"
filename="${inp[0]}"
fileext="${inp[1]}"
IFS="$old_IFS"

# set tr regex
lower=( {a..z} )
tr_regex=${lower[$offset]}"-za-"${lower[$(($offset-1))]};

# decode ROT cypher
filename=`echo "$filename" | tr "$tr_regex" "a-z"`
filename="${filename}.${fileext}"

# save pass to original filename to file
`echo $password > $filename`
