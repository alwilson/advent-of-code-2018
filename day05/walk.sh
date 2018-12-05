#!/bin/bash

polymer=$(cat input)
count=$(echo -n $polymer | wc -c)
prev_count=0
while [ $count -ne $prev_count ]; do
	polymer=$(echo -n $polymer | sed -e 's/aA\|Aa\|bB\|Bb\|cC\|Cc\|dD\|Dd\|eE\|Ee\|fF\|Ff\|gG\|Gg\|hH\|Hh\|iI\|Ii\|jJ\|Jj\|kK\|Kk\|lL\|Ll\|mM\|Mm\|nN\|Nn\|oO\|Oo\|pP\|Pp\|qQ\|Qq\|rR\|Rr\|sS\|Ss\|tT\|Tt\|uU\|Uu\|vV\|Vv\|wW\|Ww\|xX\|Xx\|yY\|Yy\|zZ\|Zz//g')
	prev_count=$count
	count=$(echo -n $polymer | wc -c)
done
echo "Part 1: reduced down to $count polymers"

min_count=999999999
min_alpha='0'
for alpha in {a..z}; do
	upper_alpha=$(( $(printf '%d' "'$alpha") - 32 ))
	upper_alpha=$( awk "BEGIN{printf \"%c\", $upper_alpha}" )
	polymer=$(cat input | tr -d $alpha$upper_alpha)
	count=$(echo -n $polymer | wc -c)
	prev_count=0
	while [ $count -ne $prev_count ]; do
		polymer=$(echo -n $polymer | sed -e 's/aA\|Aa\|bB\|Bb\|cC\|Cc\|dD\|Dd\|eE\|Ee\|fF\|Ff\|gG\|Gg\|hH\|Hh\|iI\|Ii\|jJ\|Jj\|kK\|Kk\|lL\|Ll\|mM\|Mm\|nN\|Nn\|oO\|Oo\|pP\|Pp\|qQ\|Qq\|rR\|Rr\|sS\|Ss\|tT\|Tt\|uU\|Uu\|vV\|Vv\|wW\|Ww\|xX\|Xx\|yY\|Yy\|zZ\|Zz//g')
		prev_count=$count
		count=$(echo -n $polymer | wc -c)
	done
	echo "$alpha count: $count"
	if [ $count -lt $min_count ]; then
		min_count=$count
		min_alpha=$alpha
	fi
done
echo "Part 2: removing type $min_alpha leaves $min_count polymers left, the fewest of all types"
