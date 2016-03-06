#!/bin/bash

picfile="$1"
colorfile="$HOME/.config/herbstluftwm/colors.txt"
cachefile="$HOME/.config/herbstluftwm/colors.cache"
cached=false

while read line
do
	cachepic=$(echo "$line" | awk '{ print $1; }')
	if [ "$cachepic" = "$picfile" ]
	then
		cached=true
		echo -n "" > "$colorfile" # clear the file
		#
		echo "cache -> txt"
		echo "$line" \
			| sed -e 's/^[[:space:]]*//' \
			| sed -e 's/[[:space:]]*$//' \
			| cut -d' ' -f1 --complement \
			| tr ' ' '\n'
		echo "$line" \
			| sed -e 's/^[[:space:]]*//' \
			| sed -e 's/[[:space:]]*$//' \
			| cut -d' ' -f1 --complement \
			| tr ' ' '\n' >> "$colorfile"
		break
	fi
done <$cachefile

#
echo "cached = $cached"

if ! $cached
then
	$HOME/repos/colors-0.3/colors -n 8 -e "$picfile" > "$colorfile" # get the dominant colors
	cached_colors="$picfile"
	while read line
	do
		cached_colors="$cached_colors $line"
		#
		#echo "$cached_colors"
	done <$colorfile
	#
	echo "txt -> colors"
	echo "$cached_colors"
	echo "$cached_colors" >> "$cachefile"
fi
