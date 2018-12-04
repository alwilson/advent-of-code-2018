#!/bin/bash

#PART 1
echo "setting up $((1000 * 1000)) item array..."
declare -a fabric
for y_idx in $(seq 0 999); do
  for x_idx in $(seq 0 999); do
    fabric[$(( $y_idx * 1000 + $x_idx ))]=0
  done
  echo -n '.'
done
echo

echo "walking input file and placing fabric"
while read ID X Y W H; do
  for y_idx in $(seq $Y $(( $Y+$H-1 ))); do
    for x_idx in $(seq $X $(( $X+$W-1 ))); do
      next_val=$(( 1 + ${fabric[$(( $y_idx * 1000 + $x_idx))]} ))
      fabric[$(( $y_idx * 1000 + $x_idx))]=$next_val
    done
  done
  echo -n '.'
done < <(cat input | tr -dc '0-9,x \n' | tr ',x' ' ')
echo

rm fabric_image
echo "counting overlaps"
num=0
for y_idx in $(seq 0 999); do
  echo -n "$y_idx: " >> fabric_image
  for x_idx in $(seq 0 999); do
    echo -n "${fabric[$(( $y_idx * 1000 + $x_idx ))]}" >> fabric_image
    if [ ${fabric[$(( $y_idx * 1000 + $x_idx ))]} -gt 1 ]; then
      num=$(( $num + 1 ))
    fi
  done
  echo >> fabric_image
done
echo "$num overlapping sections"

# PART 2 - by inspection XD
# pass fabric_image through tr to turn 0's to spaces
# open in gedit, turn off word wrap, make font smaller, search for '1', then look for a nice, lonely rectangle
