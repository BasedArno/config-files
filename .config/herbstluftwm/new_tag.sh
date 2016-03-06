#!/bin/bash

HSCRIPT=$HOME/.config/herbstluftwm
Win=Mod4

hc() {
	herbstclient "$@"
}


### start ###
new_tag=$($HSCRIPT/herbstinput.sh "new tag") # get the name of the new tab

if ! hc tag_status | grep "$new_tag" >/dev/null ; then
	TAGS=$(hc tag_status | wc -w)
	hc add "$new_tag"
	if [ $TAGS -ge 9 ]
	then
		echo "$0: too many tags; will not get a keybinding" >&2
	else
		hc keybind "$Win-$(( TAGS + 1 ))" use "$new_tag"
		hc keybind "$Win-Shift-$(( TAGS + 1 ))" chain , move "$new_tag" , use "$new_tag"
	fi

	hc use "new_tag"
fi
