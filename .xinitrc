#!/bin/bash

# X settings
xset b off
xrdb -merge .xresources

# Multimonitor
[ -e ~/.screens ] && source ~/.screens

# Wallpaper
[ -e ~/.fehbg ] && source ~/.fehbg

# Keyboard layout 
[ -e ~/.xmodmap ] && xmodmap ~/.xmodmap

/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 &
/usr/bin/clipit -d &

eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
