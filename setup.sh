#!/usr/bin/env bash

# This '.udot' setup script will install a minimal environment complete
# with all the bells and whistles needed to start working properly.

# There are no worries of losing a potential old configuration: il will be
# stored in a separate folder in order to be restored on demand apon uninstall.




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

_kill_apps () {
    while read -r app; do
        wmctrl -i -c "$app"
    done < <(wmctrl -l | awk '{print $1}')
}

_error () {
    clear
    printf "ERROR: %s\n" "$1" >&2
    exit 1
}

_clean () {
    if [[ -L $1 ]]; then
        unlink $1
    else
        mv $1 $RESTORE
    fi
}

_backup () {
    # bash
    [[ -f $HOME/.bash_aliases ]] && _clean $HOME/.bash_aliases
    [[ -f $HOME/.bash_functions ]] && _clean $HOME/.bash_functions
    [[ -f $HOME/.bash_logout ]] && _clean $HOME/.bash_logout
    [[ -f $HOME/.bash_profile ]] && _clean $HOME/.bash_profile
    [[ -f $HOME/.bashrc ]] && _clean $HOME/.bashrc
    [[ -f $HOME/.git-prompt.sh ]] && _clean $HOME/.git-prompt.sh
    [[ -f $HOME/.profile ]] && _clean $HOME/.profile

    # bin
    [[ -d $HOME/bin ]] && _clean $HOME/bin

    # fzf
    [[ -d $HOME/.config/fzf ]] && _clean $HOME/.config/fzf

    # i3
    [[ -d $HOME/.config/i3 ]] && _clean $HOME/.config/i3
    [[ -d $HOME/.config/i3status ]] && _clean $HOME/.config/i3status

    # kitty
    [[ -d $HOME/.config/kitty ]] && _clean $HOME/.config/kitty

    # tmux
    [[ -f $HOME/.tmux.conf ]] && _clean $HOME/.tmux.conf

    # vim
    [[ -d $HOME/.vim ]] && _clean $HOME/.vim
    [[ -f $HOME/.vimrc ]] && _clean $HOME/.vimrc

    # x11
    [[ -f $HOME/.Xdefaults ]] && _clean $HOME/.Xdefaults
    [[ -f $HOME/.xinitrc ]] && _clean $HOME/.xinitrc
    [[ -f $HOME/.Xresources ]] && _clean $HOME/.Xresources
    [[ -f $HOME/.xsettingsd ]] && _clean $HOME/.xsettingsd
}




### Start installing
####################

clear
_banner
_warning

if ! uname -a | grep Ubuntu &> /dev/null; then
    read -p "    WARNING: this is not a Ubuntu distro (enter to continue)"
    printf "\n"
fi

if [[ ! -d $HOME/.udot-restore ]]; then
    mkdir $HOME/.udot-restore
    RESTORE="$HOME/.udot-restore"
else
    printf "    '.udot' is already setup\n"
    printf "    Launch ./restore.sh first\n\n"
    exit 1
fi

read -p "    Confirm to start the '.udot' setup script (enter to continue)"
printf "\n"




### Syncing
###########

read -p "    Syncing and updating repos (enter to continue)"
printf "\n"

sudo apt update && sudo apt upgrade -qq -y || _error "syncing repos"




### Utilities
#############

printf "\n"
read -p "    Installing utilities (enter to continue)"
printf "\n"

sudo apt install -qq -y \
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
    coreutils \
    xdg-utils \
    fbset




### Main packages
#################

printf "\n"
read -p "    Installing main packages (enter to continue)"
printf "\n"

sudo apt install -qq -y \
    i3-wm \
    arandr \
    xterm \
    kitty \
    bash \
    bash-completion \
    tmux \
    vim \
    blueman \
    network-manager \
    system-config-printer \
    pavucontrol \
    diodon \
    flameshot \
    lxappearance \
    qt5ct \
    xournalpp \
    adwaita-icon-theme-full \
    gnome-themes-extra \
    adwaita-qt




### Add snap packages
#####################

printf "\n"
read -p "    Installing snap (enter to continue)"
printf "\n"

# snap
if [[ ! -x "$(command -v snap)" ]]; then
    sudo apt install -qq -y snapd
    printf "\n"
fi

# brave, code
sudo snap install brave
sudo snap install --classic code




### Remove xdg-desktop-gnome
############################

sudo apt remove -qq -y xdg-desktop-portal-gnome
systemctl --user restart xdg-desktop-portal




### Backup + add symlinks
#########################

_backup

stow bash
stow bin
stow fzf
stow i3
stow kitty
stow tmux
stow vim
stow x11




### Logout
##########

read -p "    Installation completed (enter to logout)"
printf "\n"

_kill_apps
kill $(pgrep X)
