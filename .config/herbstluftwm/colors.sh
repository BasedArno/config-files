#!/bin/bash

full_pic_file="$1"
color_file="$HOME/.config/herbstluftwm/colors.txt"
cache_file="$HOME/.config/herbstluftwm/colors.cache"
cached=false

# any file given?
if [[ -z "$full_pic_file" ]]
then
	echo "Error: No picture file given." 1>&2
	exit 1
fi

pic_file=$(basename "$full_pic_file")

# make sure it's a PNG
if [[ "${pic_file: -4}" != ".png" ]]
then
	echo "Error: File given is not a png." 1>&2
	exit 2
fi

# try to find pic_file inside cache_file
while read line
do
	# get the first entry from the line
	cache_pic=$(echo "$line" | awk -F ',' '{ print $1; }')
	# if it matches the filename we're searching for
	if [[ "$cache_pic" == "$pic_file" ]]
	then
		# retrieve it from the cache file
		cached=true
		echo -n "" > "$color_file" # clear the file
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
			| tr ',' '\n' >> "$color_file"
		break
	fi
done <$cache_file

# debugging
echo "cached = $cached"

if ! $cached
then
	# get the dominant colors from the image
	$HOME/repos/colors-0.3/colors -n 8 -e "$full_pic_file" > "$color_file"
	cached_colors="$pic_file"
	# put the image name and colors into comma separated form
	while read line
	do
		cached_colors="$cached_colors,$line"
		#
		#echo "$cached_colors"
	done <$color_file
	# debugging
	echo "txt -> colors"
	echo "$cached_colors"
	# put these into the cache file
	echo "$cached_colors" >> "$cache_file"
fi
