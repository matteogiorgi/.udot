# This script defines the settings for a user when running a login shell.
# In this case it just launch ~/.profile and ~/.bashrc.
# In case you do not use a login-manager, add `exec startx`.




### ~/.bash_profile
###################

. ~/.profile
case $- in *i*) . ~/.bashrc;; esac
