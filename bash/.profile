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




### Set PATH so it includes just '~/bin' (and its subdirs) if it exists
#######################################################################

if [ -d "$HOME/bin" ] ; then
    PATH="$PATH:$( find $HOME/bin/ -maxdepth 2 -type d -not -path "/.git/*" -printf ":%p" )"
fi




### Set PATH so it includes just '~/.emacs.d/bin', '~/.cargo/bin', '~/go/bin' if they exist
###########################################################################################

[[ -d $HOME/.emacs.d/bin ]] && PATH="$PATH:$HOME/.emacs.d/bin"
[[ -d $HOME/.cargo/bin ]] && PATH="$PATH:$HOME/.cargo/bin"
[[ -d $HOME/go/bin ]] && PATH="$PATH:$HOME/go/bin"




### Add ghcup settings (curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh)
################################################################################################

[[ -d $HOME/.ghcup ]] && source $HOME/.ghcup/env
