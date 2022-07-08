# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login exists.
# See /usr/share/doc/bash/examples/startup-files for examples,
# the files are located in the bash-doc package.

# The default umask is set in /etc/profile; for setting the umask for ssh logins,
# install and configure the libpam-umask package (umask 022)




### If running bash
###################

if [ -n "$BASH_VERSION" ]; then
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi




### Set PATH so it includes just '~/.local/bin' if it exists
############################################################

if [ -d "$HOME/.local/bin" ] ; then
    PATH="$PATH:$HOME/.local/bin"
fi




### Set PATH so it includes just '~/bin' (if it exists) and its subdirs
#######################################################################

if [ -d "$HOME/bin" ] ; then
    PATH="$PATH:$( find $HOME/bin/ -maxdepth 2 -type d -not -path "/.git/*" -printf ":%p" )"
fi




### Set PATH to include '~/.emacs.d/bin' (apt install emacs)
############################################################

[[ -d $HOME/.emacs.d/bin ]] && PATH="$PATH:$HOME/.emacs.d/bin"




### Add golang binary directory (apt install golang-go)
#######################################################

[[ -d $HOME/go/bin ]] && PATH="$PATH:$HOME/go/bin"




### Add rustup settings (curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh)
########################################################################################

[[ -d $HOME/.cargo/bin ]] && PATH="$PATH:$HOME/.cargo/bin"




### Add ghcup settings (curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh)
################################################################################################

[[ -d $HOME/.ghcup ]] && source $HOME/.ghcup/env




### Set keyboard layout and special keys
########################################

[[ -f /bin/setxkbmap ]] && setxkbmap -layout it
[[ -d $HOME/.Xmodmap ]] && xmodmap $HOME/.Xmodmap
