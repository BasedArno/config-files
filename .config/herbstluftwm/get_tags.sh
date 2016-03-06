#!/bin/bash

HSCRIPT=$HOME/.config/herbstluftwm

hc() {
	herbstclient "$@"
}

IFS=$'\t' read -ra tags <<< "$(hc tag_status $monitor)" # read the tags

for tag in "${tags[@]}"
do
	printf "%s\n" "${tag:1}"
done

response="$@"

echo "$response" 1>&2

exit
