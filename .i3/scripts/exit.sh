#!/bin/bash

echo -e "lock\nsuspend\nlogout\nreboot\nshutdown"

if [ -n "$@" ]
then
	OPT="$@"
#read OPT

	if [ x"lock" = x"$OPT" ]
	then
		lock &
	elif [ x"suspend" = x"$OPT" ]
	then
		lock &
		systemctl suspend
	elif [ x"logout" = x"$OPT" ]
	then
		i3-msg exit
	elif [ x"reboot" = x"$OPT" ]
	then
		shutdown -r now
	elif [ x"shutdown" = x"$OPT" ]
	then
		shutdown now
	else
		echo -e "Unknown option:\n${OPT}" >> /home/arno/fail
	fi
fi
