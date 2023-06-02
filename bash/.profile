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




### Add golang binary directory (apt install golang-go)
#######################################################

[[ -d $HOME/go/bin ]] && PATH="$PATH:$HOME/go/bin"




### Add rustup settings (curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh)
########################################################################################

[[ -d $HOME/.cargo/bin ]] && PATH="$PATH:$HOME/.cargo/bin"




### Add ghcup settings (curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh)
################################################################################################

[[ -d $HOME/.ghcup ]] && source $HOME/.ghcup/env




### Add opam configuration (remember to run 'opam init' first)
##############################################################

if [[ -d $HOME/.opam/opam-init ]]; then
    eval $(opam env)
    test -r $HOME/.opam/opam-init/init.sh && . $HOME/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true
fi




### i3-sensible-variables
#########################

export EDITOR="/bin/vim"
export VISUAL="/bin/vim"
export TERMINAL="/bin/lxterm"

if command -v glxinfo >/dev/null 2>&1 && glxinfo | awk '/OpenGL version/ { exit !($4 > 3.3) }'; then
    [[ -x "$(command -v kitty)" ]] && export TERMINAL="/bin/kitty"
fi




### Create and/or source xinput variables
#########################################

[[ -f ~/.xinput.bash ]] || printf "TOUCHPADID=''\nTOUCHPADST='on'\n\nWACOMID=''\nWACOMRO='0'\nWACOMMO='master'\n\nAUTORANDR='master'\n\nGUIEDITOR='code'" > ~/.xinput.bash
source $HOME/.xinput.bash
