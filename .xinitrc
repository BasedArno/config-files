#!/bin/bash

## window manager
# i3 is kept as default
session=${1:-i3}

case $session in
    awesome           ) exec awesome;;
    bspwm             ) exec bspwm;;
    catwm             ) exec catwm;;
    cinnamon          ) exec cinnamon-session;;
    dwm               ) exec dwm;;
    enlightenment     ) exec enlightenment_start;;
    ede               ) exec startede;;
    fluxbox           ) exec startfluxbox;;
    gnome             ) exec gnome-session;;
    gnome-classic     ) exec gnome-session --session=gnome-classic;;
    herbstluftwm|hlwm ) exec herbstluftwm;;
    i3|i3wm           ) exec i3;;
    icewm             ) exec icewm-session;;
    jwm               ) exec jwm;;
    kde               ) exec startkde;;
    mate              ) exec mate-session;;
    monster|monsterwm ) exec monsterwm;;
    notion            ) exec notion;;
    openbox           ) exec openbox-session;;
    unity             ) exec unity;;
    xfce|xfce4        ) exec startxfce4;;
    xmonad            ) exec xmonad;;
    # No known session, try to run it as command
    *) exec $1;;
esac

## background
sh ~/.fehbg

xset +fp ~/.fonts
xset rehash

## Background Programs
# start compositing manager (options now in compton.conf!)
compton & #-cCGb --backend glx --paint-on-overlay --vsync opengl &
# and gnome-settings
gnome-settings-daemon &
# and dropbox
dropbox start &
# extra key bindings
xbindkeys &
