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
        read -p "$1 [$prompt] " REPLY
        [[ -z "$REPLY" ]] && REPLY=$default
        case "$REPLY" in
            Y*|y*) return 0 ;;
            N*|n*) return 1 ;;
        esac
    done
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

    # helix
    [[ -d $HOME/.config/helix ]] && _clean $HOME/.config/helix

    # i3
    [[ -d $HOME/.config/i3 ]] && _clean $HOME/.config/i3
    [[ -d $HOME/.config/i3status ]] && _clean $HOME/.config/i3status

    # kakoune
    [[ -d $HOME/.config/kak ]] && _clean $HOME/.config/kak

    # kitty
    [[ -d $HOME/.config/kitty ]] && _clean $HOME/.config/kitty

    # sxiv
    [[ -d $HOME/.config/sxiv ]] && _clean $HOME/.config/sxiv

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

    # zathura
    [[ -d $HOME/.config/zathura ]] && _clean $HOME/.config/zathura
}

_install_chrome () {
    [[ ! -d ~/Downloads ]] && mkdir -p ~/Downloads
    cd ~/Downloads
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo apt install -qq -y ./google-chrome-stable_current_amd64.deb
    rm ./google-chrome-stable_current_amd64.deb
    cd -
}

_install_helix () {
    sudo add-apt-repository ppa:maveonair/helix-editor
    sudo apt update
    sudo apt install -qq -y helix
}

_remove_xdg-desktop_portal_gnome () {
    sudo apt remove -qq -y xdg-desktop-portal-gnome
    systemctl --user restart xdg-desktop-portal
}




### Start installing
####################

clear
_banner
_warning

if ! uname -a | grep Ubuntu &> /dev/null; then
    if ! _ask "    This is not a Ubuntu distro, continue anyway?" N; then
        printf "\n"
        exit 0
    fi
fi

if [[ ! -d $HOME/.udot-restore ]]; then
    mkdir $HOME/.udot-restore
    RESTORE="$HOME/.udot-restore"
else
    printf "    '.udot' is already setup\n"
    printf "    Launch ./restore.sh first\n\n"
    exit 1
fi

if ! _ask "    Confirm to start the '.udot' install script" Y; then
    printf "\n"
    exit 0
fi




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
    xtermcontrol \
    curl \
    wget \
    stow \
    autorandr \
    git \
    atool \
    trash-cli \
    htop \
    tree \
    make \
    gcc \
    pkg-config \
    lxpolkit \
    xclip \
    fzf \
    ripgrep \
    wamerican \
    witalian \
    mesa-utils \
    xdo \
    feh \
    ffmpeg \
    poppler-utils \
    mediainfo \
    brightnessctl \
    texlive-full \
    pandoc \
    fonts-firacode \
    poppler-utils \
    xdotool \
    gnome-shell-extension-prefs \
    chrome-gnome-shell \
    ufw \
    vsftpd \
    cups \
    bat \
    libnotify-bin \
    zenity \
    chafa \
    coreutils \
    xdg-utils \
    w3m-img \
    xdotool \
    fbset




### Main packages
#################

printf "\n"
read -p "    Installing main packages (enter to continue)"
printf "\n"

sudo apt install -qq -y \
    i3-wm \
    xautolock \
    arandr \
    kitty \
    xterm \
    tmux \
    kak \
    vim \
    zathura \
    zathura-djvu \
    zathura-pdf-poppler \
    zathura-ps \
    mpv \
    sxiv \
    blueman \
    network-manager \
    adwaita-icon-theme-full \
    gnome-themes-extra \
    adwaita-qt \
    lxappearance \
    qt5ct \
    xournalpp \
    cherrytree \
    flameshot \
    diodon \
    pavucontrol \
    gparted \
    filezilla \
    simplescreenrecorder \
    transmission \
    vlc \
    mypaint \
    system-config-printer \
    input-remapper \
    bash \
    bash-completion

_install_chrome
_install_helix
_remove_xdg-desktop_portal_gnome




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

# slides, brave, chromum, code, codium
sudo snap install slides brave chromium
sudo snap install --classic code
sudo snap install --classic codium




### Backup + add symlinks
#########################

_backup

stow bash
stow bin
stow fzf
stow helix
stow i3
stow kakoune
stow kitty
stow sxiv
stow tmux
stow vim
stow x11
stow zathura




### Add more language support
#############################

printf "\n"
if _ask "    Add full language support?" Y; then
    printf "\n"
    sudo apt install -qq -y \
        build-essential \
        valgrind \
        gdb \
        default-jdk \
        default-jdk-doc \
        ant \
        maven \
        gradle \
        python3 \
        python3-pip \
        golang-go \
        golang-golang-x-tools \
        ocaml-batteries-included \
        ocaml-man \
        opam \
        opam-doc \
        nodejs
fi




### Enable FTP
##############

printf "\n"
read -p "    Enabling FTP (enter to continue)"
printf "\n"

sudo systemctl start vsftpd
sudo systemctl enable vsftpd
sudo ufw allow 20/tcp
sudo ufw allow 21/tcp




### Enable CUPS
###############

printf "\n"
read -p "    Enabling CUPS (enter to continue)"
printf "\n"

sudo systemctl start cups
sudo systemctl enable cups




### Logout
##########

read -p "    Installation completed (enter to logout)"
printf "\n"

_kill_apps
kill $(pgrep X)
