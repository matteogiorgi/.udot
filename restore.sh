#!/usr/bin/env bash

# This '.udot' restore script will restore whatever previous
# configuration there was before `setup.sh` was launched.




### This should retrieve current script path
############################################

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"




### Colors definition
#####################

RED='\033[1;36m'
YLW='\033[1;35m'
NC='\033[0m'




### Functions definition
########################

_banner () {
    printf "\n${YLW}%s${NC}"          "     _   _ ____   ___ _____"
    printf "\n${YLW}%s ${RED}%s${NC}" "    | | | |  _ \ / _ \_   _|" "  Matteo Giorgi (Geoteo)"
    printf "\n${YLW}%s ${RED}%s${NC}" "    | | | | | | | | | || |  " "  https://www.geoteo.net"
    printf "\n${YLW}%s ${RED}%s${NC}" "    | |_| | |_| | |_| || |  " "  https://github.com/matteogiorgi/.udot"
    printf "\n${YLW}%s${NC}\n\n"      "     \___/|____/ \___/ |_|"
}

_warning () {
    if [ "$(id -u)" = 0 ]; then
        printf "\n${RED}%s${NC}"     "    This script MUST NOT be run as root user since it makes changes"
        printf "\n${RED}%s${NC}"     "    to the \$HOME directory of the \$USER executing this script."
        printf "\n${RED}%s${NC}"     "    The \$HOME directory of the root user is, of course, '/root'."
        printf "\n${RED}%s${NC}"     "    We don't want to mess around in there. So run this script as a"
        printf "\n${RED}%s${NC}\n\n" "    normal user. You will be asked for a sudo password when necessary."
        exit 1
    fi
}

_kill_apps() {
    while read -r app; do
        wmctrl -i -c "$app"
    done < <(wmctrl -l | awk '{print $1}')
}

_error () {
    clear
    printf "ERROR: %s\n" "$1" >&2
    exit 1
}

_restore () {
    # bash
    [[ -f $RESTORE/.bash_aliases ]] && mv $RESTORE/.bash_aliases $HOME
    [[ -f $RESTORE/.bash_functions ]] && mv $RESTORE/.bash_functions $HOME
    [[ -f $RESTORE/.bash_logout ]] && mv $RESTORE/.bash_logout $HOME
    [[ -f $RESTORE/.bash_profile ]] && mv $RESTORE/.bash_profile $HOME
    [[ -f $RESTORE/.bashrc ]] && mv $RESTORE/.bashrc $HOME
    [[ -f $RESTORE/.git-prompt.sh ]] && mv $RESTORE/.git-prompt.sh $HOME
    [[ -f $RESTORE/.profile ]] && mv $RESTORE/.profile $HOME

    # bin
    [[ -d $RESTORE/bin ]] && mv $RESTORE/bin $HOME

    # fzf
    [[ -d $RESTORE/fzf ]] && mv $RESTORE/fzf $HOME/.config

    # i3
    [[ -d $RESTORE/i3 ]] && mv $RESTORE/i3 $HOME/.config
    [[ -d $RESTORE/i3status ]] && mv $RESTORE/i3status $HOME/.config

    # kitty
    [[ -d $RESTORE/kitty ]] && mv $RESTORE/kitty $HOME/.config

    # tmux
    [[ -f $RESTORE/.tmux.conf ]] && mv $RESTORE/.tmux.conf $HOME

    # vim
    [[ -d $RESTORE/.vim ]] && mv $RESTORE/.vim $HOME
    [[ -f $RESTORE/.vimrc ]] && mv $RESTORE/.vimrc $HOME

    # x11
    [[ -f $RESTORE/.Xdefaults ]] && mv $RESTORE/.Xdefaults $HOME
    [[ -f $RESTORE/.xinitrc ]] && mv $RESTORE/.xinitrc $HOME
    [[ -f $RESTORE/.Xresources ]] && mv $RESTORE/.Xresources $HOME
    [[ -f $RESTORE/.xsettingsd ]] && mv $RESTORE/.xsettingsd $HOME
}




### Start uninstalling
######################

clear
_banner
_warning

if ! uname -a | grep Ubuntu &> /dev/null; then
    read -p "    WARNING: this is not a Ubuntu distro (enter to continue)"
    printf "\n"
fi

if [[ -d $HOME/.udot-restore ]]; then
    RESTORE="$HOME/.udot-restore"
else
    printf "    Nothing to restore\n"
    printf "    Launch ./setup.sh first\n\n"
    exit 1
fi

read -p "    Confirm to start the '.udot' restore script (enter to continue)"
printf "\n"




### Remove symlinks
###################

stow -D bash
stow -D bin
stow -D fzf
stow -D i3
stow -D kitty
stow -D tmux
stow -D vim
stow -D x11

_restore

[[ -d $RESTORE ]] && rm -rf $RESTORE
[[ -f $HOME/.fehbg ]] && rm $HOME/.fehbg




### Remove packages
###################

printf "\n"
read -p "    Uninstalling packages (enter to continue)"
printf "\n"

# the following packages aren't going to be uninstalled:
# coreutils, xdg-utils, fbset, bash, bash-completion,
# network-manager, adwaita-icon-theme gnome-themes-extra.

sudo apt purge -qq -y \
    wmctrl \
    xdotool \
    autorandr \
    lxpolkit \
    mesa-utils \
    git \
    curl \
    wget \
    stow \
    htop \
    atool \
    trash-cli \
    xclip \
    fzf \
    ripgrep \
    batcat \
    chafa \
    feh \
    xdo \
    fonts-firacode \
    wamerican \
    witalian \
    i3-wm \
    arandr \
    xterm \
    kitty \
    tmux \
    vim \
    blueman \
    system-config-printer \
    pavucontrol \
    diodon \
    flameshot \
    lxappearance \
    qt5ct \
    xournalpp \
    adwaita-qt




### Remove snap packages
########################

printf "\n"
read -p "    Removing snap packages (enter to continue)"
printf "\n"

if [[ -x "$(command -v snap)" ]]; then
    sudo snap remove --purge brave
    sudo snap remove --purge code
fi




### Autoremove
##############

printf "\n"
read -p "    Launching autoremove (enter to continue)"
printf "\n"

sudo apt autoremove -qq -y || _error "autoremove"




### Reboot
##########

printf "\n"
read -p "    Restoring completed (enter to reboot)"
printf "\n"

_kill_apps
systemctl reboot
