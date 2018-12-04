#!/bin/bash

# PART 1

A=0
B=0

while read p; do
  A_RET=$(echo -ne "$p" | grep -o . | sort | uniq -c | grep "2" -c)
  if [ $A_RET -ne 0 ]; then
    A=$(( $A+1 ))
  fi

  B_RET=$(echo -ne "$p" | grep -o . | sort | uniq -c | grep "3" -c)
  if [ $B_RET -ne 0 ]; then
    B=$(( $B+1 ))
  fi
done <input0

echo "A: $A B: $B A x B: $(( $A * $B ))"

# PART 2

while read p; do
  while read q; do
    NUM_DIFF=$(cmp -bl <(echo -n $p) <(echo -n $q) | wc -l)
    # echo "$p vs $q ($NUM_DIFF)"
    if [ $NUM_DIFF -eq 1 ]; then
      echo "$p vs $q ($NUM_DIFF)"
    fi
  done <input0
done <input0
