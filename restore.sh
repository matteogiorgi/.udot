#!/usr/bin/env bash

# This '.udot' restore script will restore whatever previous
# configuration there was before `setup.sh` was launched.




### Functions definition
########################

banner () {
    printf "\n  _   _ ____   ___ _____"
    printf "\n | | | |  _ \ / _ \_   _|  Matteo Giorgi (Geoteo)"
    printf "\n | | | | | | | | | || |    https://www.geoteo.net"
    printf "\n | |_| | |_| | |_| || |    https://github.com/matteogiorgi/.udot"
    printf "\n  \___/|____/ \___/ |_|\n\n"
}

warning () {
    if [ "$(id -u)" = 0 ]; then
        printf "\n This script MUST NOT be run as root user since it makes changes"
        printf "\n to the \$HOME directory of the \$USER executing this script."
        printf "\n The \$HOME directory of the root user is, of course, '/root'."
        printf "\n We don't want to mess around in there. So run this script as a"
        printf "\n normal user. You will be asked for a sudo password when necessary.\n\n"
        exit 1
    fi
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

restore () {
    # backgrounds
    [[ -d $RESTORE/backgrounds ]] && mv $RESTORE/backgrounds $HOME/Pictures

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

    # kakoune
    [[ -d $RESTORE/kak ]] && mv $RESTORE/kak $HOME/.config

    # nano
    [[ -f $RESTORE/.nanorc ]] && mv $RESTORE/.nanorc $HOME

    # sxiv
    [[ -d $RESTORE/sxiv ]] && mv $RESTORE/sxiv $HOME/.config

    # tig
    [[ -f $RESTORE/.tigrc ]] && mv $RESTORE/.tigrc $HOME

    # tmux
    [[ -f $RESTORE/.tmux.conf ]] && mv $RESTORE/.tmux.conf $HOME

    # vim
    [[ -d $RESTORE/.vim ]] && mv $RESTORE/.vim $HOME
    [[ -f $RESTORE/.vimrc ]] && mv $RESTORE/.vimrc $HOME

    # x11
    [[ -f $RESTORE/.Xdefaults ]] && mv $RESTORE/.Xdefaults $HOME
    [[ -f $RESTORE/.xinitrc ]] && mv $RESTORE/.xinitrc $HOME
    [[ -f $RESTORE/.Xmodmap ]] && mv $RESTORE/.Xmodmap $HOME
    [[ -f $RESTORE/.Xresources ]] && mv $RESTORE/.Xresources $HOME
    [[ -f $RESTORE/.xsettingsd ]] && mv $RESTORE/.xsettingsd $HOME

    # zathura
    [[ -d $RESTORE/zathura ]] && mv $RESTORE/zathura $HOME/.config
}




### Start installer
###################

clear
banner
warning

if [[ -d $HOME/.udot-restore ]]; then
    RESTORE="$HOME/.udot-restore"
else
    printf " Nothing to restore\n\n"
    exit 0
fi

if ! ask " Confirm to start the '.udot' restore script" Y; then
    exit 0
fi

if ! uname -a | grep Ubuntu &> /dev/null; then
    ask " This is not a Ubuntu distro, continue anyway?" N
fi




### Remove symlinks + restore
#############################

stow -D backgrounds
stow -D bash
stow -D bin
stow -D fzf
stow -D i3
stow -D kakoune
stow -D nano
stow -D sxiv
stow -D tig
stow -D tmux
stow -D vim
stow -D x11
stow -D zathura

restore




### Remove conf
###############

printf "\n     * Removing dmenu and st\n\n"
cd dmenu && sudo make clean uninstall
cd ../st && sudo make clean uninstall
cd ..

printf "\n     * Removing dependencies\n\n"
sudo apt remove \
    xtermcontrol curl wget stow autorandr git atool trash-cli htop khal make gcc \
    libx11-dev libxinerama-dev libxft-dev libncurses-dev xclip ripgrep wamerican witalian \
    source-highlight xdo feh pandoc texlive fonts-ubuntu fonts-jetbrains-mono

printf "\n     * Removing main packages\n\n"
sudo apt remove \
    i3-wm i3lock arandr xterm tmux vim-gtk3 kakoune nano zathura zathura-djvu zathura-pdf-poppler zathura-ps \
    mpv sxiv blueman network-manager redshift-gtk adwaita-icon-theme gnome-themes-extra adwaita-qt \
    lxappearance qt5ct codium chromium-browser xournalpp flameshot pavucontrol gparted




### Remove language support
###########################

printf "\n     * Removing language support\n\n"
sudo apt remove \
    build-essential gdb cgdb openjdk-18-jdk openjdk-18-doc openjdk-18-source ant maven gradle \
    python3 python3-pip golang-go golang-golang-x-tools ocaml-batteries-included ocaml-man opam opam-doc




### Goodby
##########

printf "\n Restoring completed\n\n"
