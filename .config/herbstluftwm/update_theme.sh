#!/bin/bash

### Herbstluftwm Theme Updater
### Arno Byrd

Alt=Mod1 # Use Alt key instead
Win=Mod4 # Use Windows key instead
HSCRIPT="$HOME/.config/herbstluftwm"
#Mod=Mod4

function hc() {
	herbstclient "$@"
}

random_picfile="$(ls $HOME/media/pics/Wallpapers/*.png \
	| shuf \
	| head -n 1)"
picfile="${1:-$random_picfile}"

colorfile="$HSCRIPT/colors.txt"

feh --bg-scale "$picfile" # set the background image
#/home/arno/installations/colors-0.3/colors -n 8 "$picfile" > "$colorfile" # get the dominant colors
$HSCRIPT/colors.sh "$picfile"

# assign them to variables darker colors first
eins=$(sed '1q;d' "$colorfile")
zwei=$(sed '2q;d' "$colorfile")
drei=$(sed '3q;d'  "$colorfile")
vier=$(sed '4q;d'  "$colorfile")
fuenf=$(sed '5q;d'  "$colorfile")
sechs=$(sed '6q;d'  "$colorfile")
sieben=$(sed '7q;d'  "$colorfile")
acht=$(sed '8q;d'  "$colorfile")

hc set frame_bg_normal_color "$eins"
hc set frame_bg_active_color "$eins"
hc set frame_bg_urgent_color "$eins"
hc set frame_border_normal_color "$zwei"
hc set frame_border_active_color "$vier"
hc set frame_border_urgent_color "$zwei"
hc set window_border_normal_color "$fuenf"
hc set window_border_active_color "$acht"
hc set window_border_urgent_color "$sechs"

hc chain , emit_hook quit_panel , spawn $HSCRIPT/panel.sh &
