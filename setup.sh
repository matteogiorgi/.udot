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

banner () {
    printf "\n${YLW}%s${NC}"          "     _   _ ____   ___ _____"
    printf "\n${YLW}%s ${RED}%s${NC}" "    | | | |  _ \ / _ \_   _|" "  Matteo Giorgi (Geoteo)"
    printf "\n${YLW}%s ${RED}%s${NC}" "    | | | | | | | | | || |  " "  https://www.geoteo.net"
    printf "\n${YLW}%s ${RED}%s${NC}" "    | |_| | |_| | |_| || |  " "  https://github.com/matteogiorgi/.udot"
    printf "\n${YLW}%s${NC}\n\n"      "     \___/|____/ \___/ |_|"
}

warning () {
    if [ "$(id -u)" = 0 ]; then
        printf "\n${RED}%s${NC}"     "    This script MUST NOT be run as root user since it makes changes"
        printf "\n${RED}%s${NC}"     "    to the \$HOME directory of the \$USER executing this script."
        printf "\n${RED}%s${NC}"     "    The \$HOME directory of the root user is, of course, '/root'."
        printf "\n${RED}%s${NC}"     "    We don't want to mess around in there. So run this script as a"
        printf "\n${RED}%s${NC}\n\n" "    normal user. You will be asked for a sudo password when necessary."
        exit 1
    fi
}

kill_apps () {
    while read -r app; do
        wmctrl -i -c "$app"
    done < <(wmctrl -l | awk '{print $1}')
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

    # ctags
    [[ -d $HOME/ctags ]] && clean $HOME/ctags

    # fzf
    [[ -d $HOME/.config/fzf ]] && clean $HOME/.config/fzf

    # i3
    [[ -d $HOME/.config/i3 ]] && clean $HOME/.config/i3
    [[ -d $HOME/.config/i3status ]] && clean $HOME/.config/i3status

    # kakoune
    [[ -d $HOME/.config/kak ]] && clean $HOME/.config/kak

    # kitty
    [[ -d $HOME/.config/kitty ]] && clean $HOME/.config/kitty

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

install_chrome () {
    [[ ! -d ~/Downloads ]] && mkdir -p ~/Downloads
    cd ~/Downloads
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo apt install -qq -y ./google-chrome-stable_current_amd64.deb
    rm ./google-chrome-stable_current_amd64.deb
    cd -
}




### Start installing
####################

clear
banner
warning

if ! uname -a | grep Ubuntu &> /dev/null; then
    if ! ask "    This is not a Ubuntu distro, continue anyway?" N; then
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

if ! ask "    Confirm to start the '.udot' install script" Y; then
    printf "\n"
    exit 0
fi




### Syncing
###########

read -p "    Syncing and updating repos (enter to continue)"
printf "\n"

sudo apt update && sudo apt upgrade -qq -y || error "syncing repos"




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
    ncal \
    tree \
    make \
    gcc \
    pkg-config \
    lxpolkit \
    libx11-dev \
    libxinerama-dev \
    libxft-dev \
    libncurses-dev \
    libxrandr-dev \
    libxtst-dev \
    libxi-dev \
    xclip \
    fzf \
    ripgrep \
    wamerican \
    witalian \
    source-highlight \
    mesa-utils \
    xdo \
    feh \
    ffmpeg \
    poppler-utils \
    mediainfo \
    brightnessctl \
    texlive-full \
    pandoc \
    fonts-ubuntu \
    fonts-jetbrains-mono \
    jq \
    poppler-utils \
    xdotool \
    exuberant-ctags \
    dconf-editor




### Main packages
#################

printf "\n"
read -p "    Installing main packages (enter to continue)"
printf "\n"

sudo apt install -qq -y \
    i3-wm \
    xautolock \
    arandr \
    xterm \
    rxvt-unicode \
    tmux \
    kakoune \
    kitty \
    vim-gtk3 \
    neovim \
    nano \
    tig \
    zathura \
    zathura-djvu \
    zathura-pdf-poppler \
    zathura-ps \
    mpv \
    sxiv \
    blueman \
    network-manager \
    humanity-icon-theme \
    adwaita-icon-theme-full \
    gnome-themes-extra \
    adwaita-qt \
    lxappearance \
    qt5ct \
    xournalpp \
    sct \
    flameshot \
    diodon \
    pavucontrol \
    gparted \
    pcmanfm \
    xarchiver \
    vlc \
    simplescreenrecorder \
    gimp \
    libreoffice




### Add snap/extra packages
###########################

printf "\n"
if ask "    Add snap/extra packages?" Y; then
    if [[ ! -x "$(command -v snap)" ]]; then
        sudo apt install -qq -y snapd
        printf "\n"
    fi

    printf "    Which fancy text-editor would you like to install?"
    printf "\n        (0) NONE"
    printf "\n        (1) Code"
    printf "\n        (2) Codium"
    printf "\n        (3) BOTH"
    printf "\n    Enter an index (0-3): "

    while read response; do
        case $response in
            0)
                break
                ;;
            1)
                printf "\n"
                sudo snap install --classic code
                break
                ;;
            2)
                printf "\n"
                sudo snap install --classic codium
                break
                ;;
            3)
                printf "\n"
                sudo snap install --classic code
                sudo snap install --classic codium
                break
                ;;
            *)
                printf "    WTF 're doing mate, just enter an index from 0 to 3: "
                ;;
        esac
    done

    printf "\n    Which web-browser would you like to install?"
    printf "\n        (0) NONE"
    printf "\n        (1) Brave"
    printf "\n        (2) Chrome"
    printf "\n        (3) Chromium"
    printf "\n        (4) ALL"
    printf "\n    Enter an index (0-4): "

    while read response; do
        case $response in
            0)
                break
                ;;
            1)
                printf "\n"
                sudo snap install brave
                break
                ;;
            2)
                printf "\n"
                install_chrome
                break
                ;;
            3)
                printf "\n"
                sudo snap install chromium
                break
                ;;
            4)
                printf "\n"
                sudo snap install brave
                sudo snap install chromium
                install_chrome
                break
                ;;
            *)
                printf "    WTF 're doing mate, just enter an index from 0 to 4: "
                ;;
        esac
    done
fi




### Dmenu, St, and Slock
########################

printf "\n"
read -p "    Compiling dmenu, st and slock (enter to continue)"
printf "\n"

cd dmenu && sudo make clean install
cd ../st && sudo make clean install
cd ../slock && sudo make clean install
cd ..




### Backup + add symlinks
#########################

backup
mkdir -p $HOME/Pictures/backgrounds

stow bash
stow bin
stow ctags
stow fzf
stow i3
stow kakoune
stow kitty
stow nano
stow neovim
stow sxiv
stow tig
stow tmux
stow vim
stow x11
stow zathura




### Add NodeJS for Coc.nvim
###########################

printf "\n"
read -p "    Installing NodeJS for Coc.nvim (enter to continue)"
printf "\n"

curl -sL install-node.vercel.app/lts | sudo bash




### Add language support
########################

printf "\n"
if ask "    Add language support?" Y; then
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
        opam-doc
    printf "\n    Need Haskell? -> curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh"
    printf "\n    Need Rust?    -> curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh\n\n"
fi




### Logout
##########

read -p "    Installation completed (enter to logout)"
printf "\n"

kill_apps
kill $(pgrep X)
