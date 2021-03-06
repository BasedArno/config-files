#!/bin/bash

## Init
function hc() {
	herbstclient "$@"
}

HSCRIPT="$HOME/.config/herbstluftwm"

monitor=${1:-0}
geometry=( $(herbstclient monitor_rect "$monitor") )
if [ -z "$geometry" ] ;then
    echo "Invalid monitor $monitor"
    exit 1
fi
# geometry has the format W H X Y
#padding_width=100
padding_width=$(($(herbstclient get frame_gap) * 2 + $(herbstclient get window_gap) * 2))
x=$((${geometry[0]} + $padding_width/2)) # center it
y=${geometry[1]}
panel_width=$((${geometry[2]} - $padding_width))
panel_height=24
font="-*-fixed-medium-*-*-*-13-*-*-*-*-*-*-*"
font="-*-Pointfree-*-*-*-*-13-*-*-*-*-*-*-*"
iconfont="-*-FontAwesome-medium-*-*-*-13-*-*-*-*-*-*-*"
bgcolor='#333333'
fgcolor='#efefef'

# extract colors from color file
colorfile="$HOME/.config/herbstluftwm/colors.txt"
eins=$(sed '1q;d' "$colorfile")
zwei=$(sed '2q;d' "$colorfile")
drei=$(sed '3q;d'  "$colorfile")
vier=$(sed '4q;d'  "$colorfile")
fuenf=$(sed '5q;d'  "$colorfile")
sechs=$(sed '6q;d'  "$colorfile")
sieben=$(sed '7q;d'  "$colorfile")
acht=$(sed '8q;d'  "$colorfile")
separator="^bg()^fg($vier)^r(1x16)^fg($fgcolor)"
#separator="^bg()^fg($drei)|^fg($fgcolor)"


### Utility Functions ###
function uniq_linebuffered() {
	# for flushing buffer after each newline
	awk '$0 != l { print ; l=$0 ; fflush(); }' "$@"
}

function icon() {
	printf "^fn($iconfont)$@^fn()"
}

function cerr() {
	# for debugging purposes
	cat <<< "$@" >&2
}

function battery() {
	attr=${1:-capacity}
	cat "/sys/class/power_supply/BAT0/$attr"
}

function get_volume() {
	amixer get Master \
			| grep -o '[0-9]\+%' \
			| tr -d '%'
}

function wlan() {
	cmd=${1:-quality}

	if [ "$cmd" = "quality" ]
	then
		grep wlan0 /proc/net/wireless \
			| awk '{ print int($3 * 100 / 70) }'
	elif [ "$cmd" = "network" ]
	then
		iw dev wlan0 link \
			| grep SSID \
			| cut -d " " -f 2-
	fi
}

function CPU() {
	ps -eo pcpu \
		| awk '
			BEGIN { sum = 0.0f }
			{ sum += $1 }
			END { print sum }
			'
}

function song_info() {
	artist=$(mocp -i | grep Artist: | cut -d' ' -f2-)
	songtitle=$(mocp -i | grep SongTitle: | cut -d' ' -f2-)
	printf "$artist - $songtitle\n"
}

function get_layout() {
	herbstclient layout \
		| grep FOCUS \
		| sed 's/:.*//g' \
		| sed 's/.*-- //g'
}

### Go! ###

hc pad $monitor $panel_height

function event_generator() {
    ### Event generator ###
    # based on different input data (mpc, date, hlwm hooks, ...) this generates events, formed like this:
    #   <eventname>\t<data> [...]
    # e.g.
    #   date    ^fg(#efefef)18:33^fg(#909090), 2013-10-^fg(#efefef)29

    # time updated every second
    while true ; do
		date +"time	^fg($sieben)%I:%M^fg()"
		printf "%s\n" "layout	$(get_layout)"
        sleep 1 || break
    done > >(uniq_linebuffered) &
    childpid1=$!

	# wifi and volume updated every 5 seconds
    while true ; do
		printf "%s\n" "wifi	$(wlan network)"
		printf "%s\n" "volume	$(get_volume)"
        sleep 5 || break
    done > >(uniq_linebuffered) &
    childpid2=$!

	# battery and date updated every minute
	while true
	do
		printf "%s\n" "bat_cap	$(battery capacity)"
		date +"date	^fg($sechs)%Y-%m-^fg($sieben)%d^fg()"
		sleep 60 || break
	done > >(uniq_linebuffered) &
	childpid3=$!

    hc --idle
    kill $childpid1 $childpid2 $childpid3
}

function event_handler() {
	# placeholder variables
	IFS=$'\t' read -ra tags <<< "$(hc tag_status $monitor)" # read the tags
	visible=true
	volume="100" # <-- not true - just needed to keep shell from shitting itself
	bat_cap="100" # <-- not true - just needed to keep shell from shitting itself
	bat_stat=""
	time=""
	date=""
    windowtitle="i can haz window title?"

	## Icons
	layout_icon=$(icon "\uf0c9")
	#sys_icon=$(icon "\uf17a")
	sys_icon=$(icon "\uf080")
	wifi_icon=$(icon "\uf1eb")
	vol_icon=$(icon "\uf028")
	bat_icon=$(icon "\uf240")
	time_icon=$(icon "\uf017")
	date_icon=$(icon "\uf073")

    while true
	do
        ### Output ###
        # This part prints dzen data based on the _previous_ data handling run,
        # and then waits for the next event to happen.

		## start left aligned text
        # draw tags
        for i in "${tags[@]}" ; do
			# set the foreground/background colors
            case ${i:0:1} in
                '#') # focused workspace
                    printf "%s" "^bg($zwei)^fg($acht)"
                    ;;
                '+') # on monitor and unfocused
                    printf "%s" "^bg($eins)^fg($fuenf)"
                    ;;
                ':') # non empty tag (what?)
                    printf "%s" "^bg()^fg($fuenf)"
                    ;;
                '!') # urgent window contained
                    printf "%s" "^bg()^fg($sieben)"
                    ;;
                *) # no content?
                    printf "%s" "^bg()^fg(#ababab)"
                    ;;
            esac
			# make them into clickable buttons
			if [ ${i:0:1} = '.' ] # workspace has nothing on it
			then
				#cerr "no content on tag"
                printf "%s" "^ca(1,\"herbstclient\" "
                printf "%s" "focus_monitor \"$monitor\" && "
                printf "%s" "\"herbstclient\" "
                printf "%s" "use \"${i:1}\") ^c(10) ^ca()" # light grey circle
			else # an actual tag with stuff on it
				#cerr "working as expected"
                printf "%s" "^ca(1,\"herbstclient\" "
                printf "%s" "focus_monitor \"$monitor\" && "
                printf "%s" "\"herbstclient\" "
                printf "%s" "use \"${i:1}\") ${i:1} ^ca()"
			fi
			# clear the colors
			printf "%s" "^bg()^fg()"
        done
        printf "%s" " $separator"
		# window title (not name of program)
		printf "%s" " ^bg($drei)^fg() ${windowtitle//^/^^} ^bg()^fg()"

		## start right aligned text
		right=" ^fg($fuenf)$layout_icon^fg() "
		symbols="$layout_icon"
		text=""

		# sysinfo widget
		right="$right$separator ^ca(1, $HSCRIPT/sysinfo_widget)^fg($fuenf)$sys_icon^fg()^ca() "
		symbols="$symbols$sys_icon"
		text="$text $separator "

		# wifi widget
		right="$right$separator ^ca(1, $HSCRIPT/wifi_widget)^fg($fuenf)$wifi_icon^fg()^ca() "
		symbols="$symbols$wifi_icon"
		text="$text $separator "

		# volume widget
		right="$right$separator ^ca(1, $HSCRIPT/volume_widget)^fg($fuenf)$vol_icon^fg()^ca() "
		symbols="$symbols$vol_icon"
		text="$text $separator "

		# battery widget
		right="$right$separator ^ca(1, $HSCRIPT/battery_widget)^fg($fuenf)$bat_icon^fg()^ca() "
		symbols="$symbols$bat_icon"
		text="$text $separator "

		# time
		right="$right$separator ^ca(1, $HSCRIPT/time_widget)^fg($fuenf)$time_icon^fg() $time^ca() "
		symbols="$symbols$time_icon"
		text="$text $separator $time "

		# date
		#right="$right$separator ^fg($fuenf)$date_icon^fg() $date "
		right="$right$separator ^ca(1, $HSCRIPT/calendar_widget)^fg($fuenf)$date_icon^fg() $date^ca() "
		symbols="$symbols$date_icon"
		text="$text $separator $date "

		# calculate width of right side to get padding right
        #right_text_only=$(printf "%s" "$right" | sed 's.\^[^(]*([^)]*)..g')
		# get width of right aligned text... and add some space...
        #width=$(( $(dzen2-textwidth "$font" "$right_text_only") + 270))
        #width=$(( $(dzen2-textwidth "$font" "$right_text_only") + $(dzen2-textwidth "$iconfont" "$right_text_only") ))
        width=$(( $(dzen2-textwidth "$font" "$text") + $(dzen2-textwidth "$iconfont" "$symbols") ))

		# print it (with a newline at the end to signal being done)
        printf "%s\n" "^pa($(($panel_width - $width)))$right"


        ### Data handling ###
        # This part handles the events generated in the event loop, and sets
        # internal variables based on them. The event and its arguments are
        # read into the array cmd, then action is taken depending on the event
        # name.
        # "Special" events (quit_panel/togglehidepanel/reload) are also handled
        # here. You use `herbstclient emit_hook` to activate these events.

        # wait for next event
        IFS=$'\t' read -ra cmd || break
        # find out event origin
        case "${cmd[0]}" in
            tag*)
				cerr "changing tags"
                IFS=$'\t' read -ra tags <<< "$(hc tag_status $monitor)"
                ;;
            focus_changed|window_title_changed)
                windowtitle="${cmd[@]:2}"
                ;;
			layout)
				layout="${cmd[@]:1}"
				case "$layout" in
					'vertical')
						layout_icon=$(icon "\uf07d")
						;;
					'horizontal')
						layout_icon=$(icon "\uf07e")
						;;
					'max')
						layout_icon=$(icon "\uf0c9")
						;;
					'grid')
						layout_icon=$(icon "\uf009")
						;;
					*)
						cerr "layout not recognized"
						;;
				esac
				;;
			wifi)
				network="${cmd[@]:1}"
				cerr "wifi icon updated"

				if [ -n "$network" ] # there's a connection
				then
					wifi_icon=$(icon "\uf1eb") # wifi signal
				else # there's no connection
					wifi_icon=$(icon "\uf071") # warning symbol
				fi
				;;
			volume)
				volume="${cmd[@]:1}"
				cerr "volume icon updated"

				# change the volume icon based on volume level
				if [ "$volume" -ge 67 ] # full-ish
				then
					vol_icon=$(icon "\uf028")
				elif [ "$volume" -ge 34 ] # mid-range
				then
					vol_icon=$(icon "\uf027")
				else # pretty quiet
					vol_icon=$(icon "\uf026")
				fi
				;;
			bat_cap)
				bat_cap="${cmd[@]:1}"
				bat_stat="${cmd[@]:2}"
				cerr "battery icon updated"

				# change the batter icon based on the capacity
				if [ "$bat_cap" -ge 87 ] # full-ish
				then
					bat_icon=$(icon "\uf240")
				elif [ "$bat_cap" -ge 63 ] # 3/4
				then
					bat_icon=$(icon "\uf241")
				elif [ "$bat_cap" -ge 37 ] # 1/2
				then
					bat_icon=$(icon "\uf242")
				elif [ "$bat_cap" -ge 13 ] # 1/4
				then
					bat_icon=$(icon "\uf243")
				else # empty-ish
					bat_icon=$(icon "\uf244")
				fi

				if [ "$bat_stat" = "Discharging" ] && ([ "$bat_cap" = 86 ] || [ "$bat_cap" = 62 ] || [ "$bat_cap" = 36 ] || [ "$bat_cap" = 12 ] || [ "$bat_cap" = 5 ])
				then
					#cerr "battery icon updated"
					$HSCRIPT/notify_widget "Info" "Battery is at $bat_cap%!"
				fi
				;;
            time)
                #cerr "time updated"
                time="${cmd[@]:1}"
                ;;
            date)
                cerr "date updated"
                date="${cmd[@]:1}"
                ;;
            quit_panel)
                exit
                ;;
            reload)
                exit
                ;;
            togglehidepanel)
                currentmonidx=$(hc list_monitors | sed -n '/\[FOCUS\]$/s/:.*//p')
                if [ "${cmd[1]}" -ne "$monitor" ] ; then
                    continue
                fi
                if [ "${cmd[1]}" = "current" ] && [ "$currentmonidx" -ne "$monitor" ] ; then
                    continue
                fi
                echo "^togglehide()"
                if $visible ; then
                    visible=false
                    hc pad $monitor 0
                else
                    visible=true
                    hc pad $monitor $panel_height
                fi
                ;;
        esac
    done
}

function panel() {
    ### dzen2 ###
    # After the data is gathered and processed, the output of the previous block
    # gets piped to dzen2.

	dzen2 -dock \
		-x $x -y $y -w $panel_width -h $panel_height \
		-fn "$font" \
	    -e 'button3=' \
	    -ta l \
		-bg "$bgcolor" -fg "$fgcolor"
		"$@"
}

function main() {
	event_generator \
		| event_handler \
		| panel
}

main
