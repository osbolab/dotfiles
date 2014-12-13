#!/bin/sh

# X settings
xset b off
xset r rate 200 30
xrdb -merge .xresources

# Multimonitor
[ -e .screens ] && source .screens

# Wallpaper
[ -e .fehbg ] && source .fehbg

# Keyboard layout 
xmodmap .xmodmap
