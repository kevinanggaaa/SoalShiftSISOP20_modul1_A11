#!/bin/bash

wd=$(pwd);

if [ ! -d kenangan ]; then
  mkdir kenangan;
fi

if [ ! -d duplicate ]; then
  mkdir duplicate;
fi

if [ ! -f location.log ]; then
  echo "" > location.log;
fi



# find last filename
last_file_num=$(ls "kenangan" | awk -F "_" 'BEGIN {max = 0} {if ($2 > max) {max = $2} } END {print max}')
start_num=$(( ${last_file_num}+1 ));

end_num=$(($start_num+27));
# end_num=$(( ${start_num}+3 ));

file_arr=( )
for (( i = $start_num; i <= $end_num; i++ )); do
  file_arr+=("pdkt_kusuma_${i}")
  wget -O "pdkt_kusuma_${i}" https://loremflickr.com/320/240/cat -a wget.log
done

# get all download location from the currently downloaded one
link_arr=( $(awk '/Location:/ {print}' wget.log) )


# check duplicates
for (( i = 0; i <= $end_num-$start_num; i++ )); do
  is_dup=$(awk -v pattern="${link_arr[$1]}" '$0 ~ pattern {a=1} END {if (a==1) {print 1}}' location.log )
  if [[ $is_dup == "1" ]]; then
    temp=$((${i}+${start_num}))
    `mv pdkt_kusuma_$temp duplicate/duplicate_$temp`
  else
    temp=$((${i}+${start_num}))
    `mv pdkt_kusuma_$temp kenangan/kenangan_$temp`
  fi
done

# appned to location.log
for i in "${link_arr[@]}"; do
  is_dup=$(awk -v pattern="${link_arr[$1]}" '$0 ~ pattern {a=1} END {if (a==1) {print 1}}' location.log )

  if [[ $is_dup != "1" ]]; then
    `printf '%s\n' "$i" >> location.log`
  fi
done

# backup logs
$(mv wget.log "wget $(date).bak.log")
