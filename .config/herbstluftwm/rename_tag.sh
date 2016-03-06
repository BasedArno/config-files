#!/bin/bash

HSCRIPT=$HOME/.config/herbstluftwm

hc() {
	herbstclient "$@"
}

### start ###
# get the name of the tag to be renamed
old_tag=$($HSCRIPT/herbstinput.sh "rename" "$HSCRIPT/get_tags.sh")
# get the name of the new tag
new_tag=$($HSCRIPT/herbstinput.sh "to")

hc rename "$old_tag" "$new_tag"
