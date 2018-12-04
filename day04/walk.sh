#!/bin/bash

declare -a guards

for guard_idx in $(seq 0 9999); do
  for min_idx in $(seq 0 60); do
    guards[$(( $guard_idx * 61 + $min_idx ))]=0
  done
done

current_guard=0
last_nap=0
while read DATE HOUR MIN ACTION ID GARBAGE; do
  #echo "date: $DATE hour: $HOUR minute: $MIN action: $ACTION id: $ID"
  case $ACTION in
    "Guard")
      echo "Guard #$ID starts shift at minute $MIN"
      current_guard=$ID
      ;;
    "falls")
      echo -e "\tHe falls asleep at minute $MIN"
      last_nap=$(expr $MIN + 0)
      ;;
    "wakes")
      nap_time=$(( $(expr $MIN + 0) - $last_nap ))
      echo -e "\tHe awakes at minute $MIN after a $nap_time minute nap"
      guards[$current_guard * 61 + 60]=$(( ${guards[$current_guard * 61 + 60]} + $nap_time ))
      for min_idx in $(seq $last_nap $(expr $MIN - 1)); do
        guards[$current_guard * 61 + $min_idx]=$(( ${guards[$current_guard * 61 + $min_idx]} + 1 ))
      done
      ;;
    *)
      echo "This shouldn't happen"'!'
      ;;
  esac
done < <(sort input | tr -d '#[]' | tr ':' ' ')

max_nap=-1
max_guard=-1
max_date=""
sleep_time=0
for guard_idx in $(seq 0 9999); do
  sleep_time=${guards[$(( $guard_idx * 61 + 60 ))]}
  if [ $sleep_time -ne 0 ]; then
    echo "Guard #$guard_idx slep $sleep_time minutes"
  fi
  if [ $sleep_time -gt $max_nap ]; then
    max_nap=$sleep_time
    max_guard=$guard_idx
  fi
done

max_count=-1
actual_min=-1
for min_idx in $(seq 0 59); do
  min_count=${guards[$(( $max_guard * 61 + $min_idx ))]}
  echo -ne "$min_count "
  if [ $min_count -gt $max_count ]; then
    max_count=$min_count
    actual_min=$min_idx
  fi
done
echo

echo "Guard #$max_guard slept the most at $max_nap minutes and most often at minute $actual_min"'!'
echo "Guard ID x max minute = $(( $max_guard * $actual_min ))"


global_max_count=-1
global_min=-1
global_guard=-1
for guard_idx in $(seq 0 9999); do
  sleep_time=${guards[$(( $guard_idx * 61 + 60 ))]}
  if [ $sleep_time -ne 0 ]; then
    max_count=-1
    actual_min=-1
    for min_idx in $(seq 0 59); do
      min_count=${guards[$(( $guard_idx * 61 + $min_idx ))]}
      if [ $min_count -gt $max_count ]; then
        max_count=$min_count
        actual_min=$min_idx
      fi
    done
    if [ $max_count -gt $global_max_count ]; then
      global_max_count=$max_count
      global_min=$actual_min
      global_guard=$guard_idx
    fi
  fi
done

echo "Guard #$global_guard slept the most frequently of all guards at minute $global_min a total of $global_max_count times"'!'
echo "Guard ID * most frequent minute = $(( $global_guard * $global_min ))"
