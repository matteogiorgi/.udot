#!/usr/bin/env bash

# This '.udot' setup script will install a minimal environment complete
# with all the bells and whistles needed to start working properly.

# There are no worries of losing a potential old configuration: il will be
# stored in a separate folder in order to be restored on demand apon uninstall.




### Functions definition
########################

banner () {
    printf "\n     _   _ ____   ___ _____"
    printf "\n    | | | |  _ \ / _ \_   _|  Matteo Giorgi (Geoteo)"
    printf "\n    | | | | | | | | | || |    https://www.geoteo.net"
    printf "\n    | |_| | |_| | |_| || |    https://github.com/matteogiorgi/.udot"
    printf "\n     \___/|____/ \___/ |_|\n\n"
}

warning () {
    if [ "$(id -u)" = 0 ]; then
        printf "\n    This script MUST NOT be run as root user since it makes changes"
        printf "\n    to the \$HOME directory of the \$USER executing this script."
        printf "\n    The \$HOME directory of the root user is, of course, '/root'."
        printf "\n    We don't want to mess around in there. So run this script as a"
        printf "\n    normal user. You will be asked for a sudo password when necessary.\n\n"
        exit 1
    fi
}

error () {
    clear
    printf "ERROR: %s\n" "$1" >&2
    exit 1
}

ask () {
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

clean () {
    if [[ -L $1 ]]; then
        unlink $1
    else
        mv $1 $RESTORE
    fi
}

backup () {
    # backgrounds
    [[ -d $HOME/Pictures/backgrounds ]] && clean $HOME/Pictures/backgrounds

    # bash
    [[ -f $HOME/.bash_aliases ]] && clean $HOME/.bash_aliases
    [[ -f $HOME/.bash_functions ]] && clean $HOME/.bash_functions
    [[ -f $HOME/.bash_logout ]] && clean $HOME/.bash_logout
    [[ -f $HOME/.bash_profile ]] && clean $HOME/.bash_profile
    [[ -f $HOME/.bashrc ]] && clean $HOME/.bashrc
    [[ -f $HOME/.git-prompt.sh ]] && clean $HOME/.git-prompt.sh
    [[ -f $HOME/.profile ]] && clean $HOME/.profile

    # bin
    [[ -d $HOME/bin ]] && clean $HOME/bin

    # fzf
    [[ -d $HOME/.config/fzf ]] && clean $HOME/.config/fzf

    # i3
    [[ -d $HOME/.config/i3 ]] && clean $HOME/.config/i3
    [[ -d $HOME/.config/i3status ]] && clean $HOME/.config/i3status

    # kakoune
    [[ -d $HOME/.config/kak ]] && clean $HOME/.config/kak

    # nano
    [[ -f $HOME/.nanorc ]] && clean $HOME/.nanorc

    # sxiv
    [[ -d $HOME/.config/sxiv ]] && clean $HOME/.config/sxiv

    # tig
    [[ -f $HOME/.tigrc ]] && clean $HOME/.tigrc

    # tmux
    [[ -f $HOME/.tmux.conf ]] && clean $HOME/.tmux.conf

    # vim
    [[ -d $HOME/.vim ]] && clean $HOME/.vim
    [[ -f $HOME/.vimrc ]] && clean $HOME/.vimrc

    # x11
    [[ -f $HOME/.Xdefaults ]] && clean $HOME/.Xdefaults
    [[ -f $HOME/.xinitrc ]] && clean $HOME/.xinitrc
    [[ -f $HOME/.Xmodmap ]] && clean $HOME/.Xmodmap
    [[ -f $HOME/.Xresources ]] && clean $HOME/.Xresources
    [[ -f $HOME/.xsettingsd ]] && clean $HOME/.xsettingsd

    # zathura
    [[ -d $HOME/.config/zathura ]] && clean $HOME/.config/zathura
}




### Start installer
###################

clear
banner
warning

if [[ ! -d $HOME/.udot-restore ]]; then
    mkdir $HOME/.udot-restore
    RESTORE="$HOME/.udot-restore"
else
    printf "    udot is already setup\n\n"
    exit 1
fi

if ! ask "    Confirm to start the '.udot' install script" Y; then
    printf "\n"
    exit 0
fi

if ! uname -a | grep Ubuntu &> /dev/null; then
    if ! ask "    This is not a Ubuntu distro, continue anyway?" N; then
        printf "\n"
        exit 0
    fi
fi




### Syncing
###########

printf "\n"
read -p "    Syncing and updating repos (enter to continue)"
printf "\n"

sudo apt update && sudo apt upgrade -qq -y || error "syncing repos"




### Dependencies
################

printf "\n"
read -p "    Installing utilities (press enter to continue)"
printf "\n"

sudo apt install -qq -y \
    xtermcontrol curl wget stow autorandr git atool trash-cli htop khal make gcc \
    libx11-dev libxinerama-dev libxft-dev libncurses-dev xclip fzf ripgrep wamerican \
    witalian source-highlight xdo feh pandoc texlive fonts-ubuntu fonts-jetbrains-mono || error "installing dependencies"




### Main packages
#################

printf "\n"
read -p "    Installing main packages (press enter to continue)"
printf "\n"

sudo apt install -qq -y \
    i3-wm i3lock arandr xterm tmux vim-gtk3 kakoune nano zathura zathura-djvu zathura-pdf-poppler \
    zathura-ps mpv sxiv blueman network-manager redshift-gtk adwaita-icon-theme gnome-themes-extra \
    adwaita-qt lxappearance qt5ct chromium-browser xournalpp flameshot pavucontrol gparted || error "installing main packages"

if [[ -f /bin/snap ]]; then
    sudo snap install --classic \
        codium || error "installing codium snap-package"
fi




### Dmenu and St
################

printf "\n"
read -p "    Compiling dmenu and st (press enter to continue)"
printf "\n"

cd dmenu && sudo make clean install
cd ../st && sudo make clean install
cd ..




### Backup + add symlinks
#########################

backup

stow backgrounds
stow bash
stow bin
stow fzf
stow i3
stow kakoune
stow nano
stow sxiv
stow tig
stow tmux
stow vim
stow x11
stow zathura




### Add language support
########################

printf "\n"
if ask "    Add language support?" Y; then
    printf "\n"
    sudo apt install -qq -y \
        build-essential gdb cgdb openjdk-18-jdk openjdk-18-doc openjdk-18-source \
        ant maven gradle python3 python3-pip golang-go golang-golang-x-tools \
        ocaml-batteries-included ocaml-man opam opam-doc || error "installing language support"
    printf "\n    Need Haskell? -> curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh"
    printf "\n    Need Rust?    -> curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh\n\n"
    read -p "    Language support installed (press enter to continue)"
fi




### Goodby
##########

printf "    Installation completed\n\n"
