#!/bin/sh

# This is just the xinitrc file to use as argument for startx if you don't have
# a login manager. It only launches i3 (`exec i3` or `/usr/bin/i3 start`)
# because all the startup programs are taken care in ~/.config/i3/config.




## LOAD SHIT
############

xrdb -load ~/.Xresources &
xsettingsd &
systemctl --user import-environment DISPLAY




## START WM
###########

exec i3 2>~/.i3.err
