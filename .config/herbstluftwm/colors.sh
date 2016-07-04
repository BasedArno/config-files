#!/bin/bash

picfile="$1"
colorfile="$HOME/.config/herbstluftwm/colors.txt"
cachefile="$HOME/.config/herbstluftwm/colors.cache"
cached=false

# grab each line
while read line
do
	# get the first entry from the line
	cachepic=$(echo "$line" | awk -F ',' '{ print $1; }')
	# if it matches the filename we're searching for
	if [ "$cachepic" = "$picfile" ]
	then
		# retrieve it from the cache file
		cached=true
		echo -n "" > "$colorfile" # clear the file
		# debugging
		echo "cache -> txt"
		echo "$line" \
			| sed -e 's/^[[:space:]]*//' \
			| sed -e 's/[[:space:]]*$//' \
			| cut -d',' -f1 --complement \
			| tr ',' '\n'
		# actual placement into text file for other scripts
		echo "$line" \
			| sed -e 's/^[[:space:]]*//' \
			| sed -e 's/[[:space:]]*$//' \
			| cut -d',' -f1 --complement \
			| tr ',' '\n' >> "$colorfile"
		break
	fi
done <$cachefile # read from the cache file

#
echo "cached = $cached"

if ! $cached
then
	# get the dominant colors from the image
	$HOME/repos/colors-0.3/colors -n 8 -e "$picfile" > "$colorfile"
	cached_colors="$picfile"
	# put the image name and colors into comma separated form
	while read line
	do
		cached_colors="$cached_colors,$line"
		#
		#echo "$cached_colors"
	done <$colorfile
	# debugging
	echo "txt -> colors"
	echo "$cached_colors"
	# put these into the cache file
	echo "$cached_colors" >> "$cachefile"
fi
