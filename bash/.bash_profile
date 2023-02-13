### ~/.bash_profile
###################

. ~/.profile
case $- in *i*) . ~/.bashrc;; esac




### Autostart
#############

exec startx
