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

_ask () {
    while true; do
        if [ "${2:-}" = "Y" ]; then
            prompt="Y/n"
            default=Y
        elif [ "${2:-}" = "N" ]; then
            prompt="y/N"
            default=N
        else
            prompt="y/n"
            default=
        fi

        # Ask the question
        read -p "$1 [$prompt] " REPLY

        # Default?
        if [ -z "$REPLY" ]; then
            REPLY=$default
        fi

        # Check if the reply is valid
        case "$REPLY" in
            Y*|y*) return 0 ;;
            N*|n*) return 1 ;;
        esac
    done
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

    # ctags
    [[ -d $RESTORE/ctags ]] && mv $RESTORE/ctags $HOME

    # fzf
    [[ -d $RESTORE/fzf ]] && mv $RESTORE/fzf $HOME/.config

    # i3
    [[ -d $RESTORE/i3 ]] && mv $RESTORE/i3 $HOME/.config
    [[ -d $RESTORE/i3status ]] && mv $RESTORE/i3status $HOME/.config

    # kakoune
    [[ -d $RESTORE/kak ]] && mv $RESTORE/kak $HOME/.config

    # kitty
    [[ -d $RESTORE/kitty ]] && mv $RESTORE/kitty $HOME/.config

    # nano
    [[ -f $RESTORE/.nanorc ]] && mv $RESTORE/.nanorc $HOME

    # sxiv
    [[ -d $RESTORE/sxiv ]] && mv $RESTORE/sxiv $HOME/.config

    # tig
    [[ -f $RESTORE/.tigrc ]] && mv $RESTORE/.tigrc $HOME

    # tmux
    [[ -f $RESTORE/.tmux.conf ]] && mv $RESTORE/.tmux.conf $HOME

    # vim/neovim
    [[ -d $RESTORE/.vim ]] && mv $RESTORE/.vim $HOME
    [[ -f $RESTORE/.vimrc ]] && mv $RESTORE/.vimrc $HOME
    [[ -d $RESTORE/nvim ]] && mv $RESTORE/nvim $HOME/.config

    # x11
    [[ -f $RESTORE/.Xdefaults ]] && mv $RESTORE/.Xdefaults $HOME
    [[ -f $RESTORE/.xinitrc ]] && mv $RESTORE/.xinitrc $HOME
    [[ -f $RESTORE/.Xmodmap ]] && mv $RESTORE/.Xmodmap $HOME
    [[ -f $RESTORE/.Xresources ]] && mv $RESTORE/.Xresources $HOME
    [[ -f $RESTORE/.xsettingsd ]] && mv $RESTORE/.xsettingsd $HOME

    # zathura
    [[ -d $RESTORE/zathura ]] && mv $RESTORE/zathura $HOME/.config
}




### Start uninstalling
######################

clear
_banner
_warning

if ! uname -a | grep Ubuntu &> /dev/null; then
    if ! _ask "    This is not a Ubuntu distro, continue anyway?" N; then
        printf "\n"
        exit 0
    fi
fi

if [[ -d $HOME/.udot-restore ]]; then
    RESTORE="$HOME/.udot-restore"
else
    printf "    Nothing to restore\n"
    printf "    Launch ./setup.sh first\n\n"
    exit 1
fi

if ! _ask "    Confirm to start the '.udot' restore script" Y; then
    printf "\n"
    exit 0
fi




### Remove gtk3-classic
#######################

printf "\n"
read -p "    Adding gtk3-classic (enter to continue)"
printf "\n"

sudo apt-get install ppa-purge
sudo ppa-purge ppa:lah7/gtk3-classic




### Disable FTP
###############

printf "\n"
read -p "    Disabling FTP (enter to continue)"
printf "\n"

sudo systemctl stop vsftpd
sudo systemctl disable vsftpd
sudo ufw deny 20/tcp
sudo ufw deny 21/tcp




### Remove symlinks
###################

stow -D bash
stow -D bin
stow -D ctags
stow -D fzf
stow -D i3
stow -D kakoune
stow -D kitty
stow -D nano
stow -D sxiv
stow -D tig
stow -D tmux
stow -D vim
stow -D x11
stow -D zathura

_restore

[[ -d $RESTORE ]] && rm -rf $RESTORE
[[ -d $HOME/.tmp ]] && rm -rf $HOME/.tmp
[[ -f $HOME/.fehbg ]] && rm $HOME/.fehbg
[[ -f $HOME/.xtemp ]] && rm $HOME/.xtemp




### Remove packages
###################

printf "\n"
read -p "    Uninstalling packages (enter to continue)"
printf "\n"

# the following packages aren't going to be uninstalled:
# ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
# wmctrl git curl wget libx11-dev libxinerama-dev libxft-dev libncurses-dev libxrandr-dev make
# gcc wamerican witalian fonts-ubuntu network-manager adwaita-icon-theme gnome-themes-extra

sudo apt purge -qq -y \
    wmctrl \
    xtermcontrol \
    stow \
    autorandr \
    atool \
    trash-cli \
    htop \
    ncal \
    tree \
    lxpolkit \
    xclip \
    fzf \
    ripgrep \
    source-highlight \
    mesa-utils \
    xdo \
    feh \
    mediainfo \
    brightnessctl \
    texlive-full \
    pandoc \
    fonts-jetbrains-mono \
    # jq \
    xdotool \
    exuberant-ctags \
    dconf-editor \
    gnome-shell-extension-prefs \
    vsftpd \
    bat \
    i3-wm \
    xautolock \
    arandr \
    kitty \
    xterm \
    tmux \
    kakoune \
    vim-gtk3 \
    nano \
    tig \
    zathura \
    zathura-djvu \
    zathura-pdf-poppler \
    zathura-ps \
    mpv \
    sxiv \
    blueman \
    papirus-icon-theme \
    adwaita-qt \
    arc-theme \
    lxappearance \
    qt5ct \
    xournalpp \
    sct \
    flameshot \
    diodon \
    pavucontrol \
    synaptic \
    gparted \
    # lxterminal \
    # pcmanfm \
    # xarchiver \
    vlc \
    simplescreenrecorder \
    libreoffice \
    mypaint \
    gpick \
    kupfer \
    neovim




### Remove snap/extra packages
##############################

printf "\n"
read -p "    Removing snap/extra packages (enter to continue)"
printf "\n"

if [[ -x "$(command -v snap)" ]]; then
    [[ -x "$(command -v code)" ]] && sudo snap remove --purge code
    [[ -x "$(command -v codium)" ]] && sudo snap remove --purge codium
    [[ -x "$(command -v brave)" ]] && sudo snap remove --purge brave
    [[ -x "$(command -v chromium)" ]] && sudo snap remove --purge chromium
    [[ -x "$(command -v google-chrome)" ]] && sudo apt purge google-chrome-stable
fi




### Remove NodeJS for Coc.nvim
##############################

printf "\n"
read -p "    Removing NodeJS (enter to continue)"
printf "\n"

sudo rm -rf $(find $(echo $PATH | sed 's/:/ /g') -name "node" 2>/dev/null)




### Remove language support
###########################

printf "\n"
read -p "    Removing language support (enter to continue)"
printf "\n"

# the following packages aren't going to be uninstalled:
# ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
# build-essential python3 ...

sudo apt purge -qq -y \
    valgrind \
    gdb \
    default-jdk \
    default-jdk-doc \
    ant \
    maven \
    gradle \
    python3-pip \
    golang-go \
    golang-golang-x-tools \
    ocaml-batteries-included \
    ocaml-man \
    opam \
    opam-doc




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
