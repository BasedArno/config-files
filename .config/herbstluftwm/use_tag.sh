#!/bin/bash

HSCRIPT=$HOME/.config/herbstluftwm

hc() {
	herbstclient "$@"
}


### start ###
use_tag=$($HSCRIPT/herbstinput.sh "use tag") # get the name of the tab to switch to

hc use "$use_tag"
