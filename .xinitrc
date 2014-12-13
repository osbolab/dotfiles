#!/bin/sh

# X settings
xset -b
xrdb -merge .xresources

# Multimonitor
[ -e .screens ] && source .screens

# Wallpaper
[ -e .fehbg ] && source .fehbg

# Hide mouse cursor when not used
unclutter -root -visible &

# Keyboard layout 
xmodmap .xmodmap
