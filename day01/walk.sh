#!/bin/bash

declare -A freqs

num=0
freqs[$num]=1

while true; do
  while read p; do
    num=$(( $num $p ))
    if [ -n "${freqs[$num]}" ]; then
      echo "found $num twice"
      exit
    fi
    freqs[$num]=1
  done <star0
done
