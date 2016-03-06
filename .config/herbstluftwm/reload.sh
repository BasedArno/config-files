#!/bin/bash

hc() { "${herbstclient_command[@]:-herbstclient}" "$@" ;}

# prints a machine readable format of all tags and its layouts
# one tag with its layout per line

hc complete 1 use |
while read tag ; do
    echo -n "$tag: "
    hc dump "$tag"
done

while read line ; do
    tag="${line%%: *}"
    tree="${line#*: }"
    #hc add "$tag"
    hc load "$tag" "$tree"
done
