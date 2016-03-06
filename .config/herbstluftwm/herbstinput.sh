#!/bin/bash

colorfile="$HOME/.config/herbstluftwm/colors.txt"
eins=$(sed '1q;d' "$colorfile")
zwei=$(sed '2q;d' "$colorfile")
drei=$(sed '3q;d'  "$colorfile")
vier=$(sed '4q;d'  "$colorfile")
fuenf=$(sed '5q;d'  "$colorfile")
sechs=$(sed '6q;d'  "$colorfile")
sieben=$(sed '7q;d'  "$colorfile")
acht=$(sed '8q;d'  "$colorfile")

name="${1:-herbsteigang}"
stub="${2:-$HOME/.config/herbstluftwm/stub.sh}"

output=$(rofi -i3 \
	-modi "$name:$stub" \
	-show "$name" \
	-sidebar-mode \
	-eh 2 \
	-width 100 \
	-padding 300 \
	-bw 0 \
	-bc "argb:af333333" \
	-bg "argb:66333333" \
	-fg "#e4e4e4" \
	-hlbg "$zwei" \
	-hlfg "$acht" \
	-font "Terminus 24" \
	2>&1 \
	| tr -d '\n')

echo "$output"
