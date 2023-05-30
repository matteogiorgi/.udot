# This script defines the settings for a user when running a login shell.
# It just launches ~/.profile an eventually `case $- in *i*) . ~/.bashrc;; esac`??
# To autostart X11 without login-manager, add `exec startx`.




### ~/.bash_profile
###################

. ~/.profile
