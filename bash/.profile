# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login exists.
# See /usr/share/doc/bash/examples/startup-files for examples,
# the files are located in the bash-doc package.

# The default umask is set in /etc/profile; for setting the umask for ssh logins,
# install and configure the libpam-umask package (umask 022)




### If running bash
###################

if [[ -n "$BASH_VERSION" ]]; then
    [[ -f "$HOME/.bashrc" ]] && . "$HOME/.bashrc"
fi




### Set PATH to include /var/lib/flatpak/exports/bin (if it exists)
###################################################################

if [[ -d "/var/lib/flatpak/exports/bin" ]]; then
    PATH="$PATH:/var/lib/flatpak/exports/bin"
fi




### Set PATH to include ~/.local/bin (if it exists)
###################################################

if [[ -d "$HOME/.local/bin" ]]; then
    PATH="$PATH:$HOME/.local/bin"
fi




### Set PATH to include ~/bin (if it exists) and its subdirs
############################################################

if [[ -d "$HOME/bin" ]]; then
    PATH="$PATH:$( find $HOME/bin/ -maxdepth 2 -type d -not -path "/.git/*" -printf ":%p" )"
fi




### i3-sensible-variables
#########################

export EDITOR="/bin/vim"
export VISUAL="/bin/vim"
export TERMINAL="/bin/lxterm"




### Create and/or source xinput variables
#########################################

[[ -f ~/.xinput.bash ]] || printf "TOUCHPADID=''\nTOUCHPADST='on'\n\nWACOMID=''\nWACOMRO='0'\nWACOMMO='master'\n\nAUTORANDR='master'\n\nGUIEDITOR='code'" > ~/.xinput.bash
source $HOME/.xinput.bash
