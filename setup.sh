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

_clean () {
    if [[ -L $1 ]]; then
        unlink $1
    else
        mv $1 $RESTORE
    fi
}

_backup () {
    # alacritty
    [[ -d $HOME/.config/alacritty ]] && _clean $HOME/.config/alacritty

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

    # ctags
    [[ -d $HOME/ctags ]] && _clean $HOME/ctags

    # fzf
    [[ -d $HOME/.config/fzf ]] && _clean $HOME/.config/fzf

    # i3
    [[ -d $HOME/.config/i3 ]] && _clean $HOME/.config/i3
    [[ -d $HOME/.config/i3status ]] && _clean $HOME/.config/i3status

    # kakoune
    [[ -d $HOME/.config/kak ]] && _clean $HOME/.config/kak

    # kitty
    [[ -d $HOME/.config/kitty ]] && _clean $HOME/.config/kitty

    # nano
    [[ -f $HOME/.nanorc ]] && _clean $HOME/.nanorc

    # sxiv
    [[ -d $HOME/.config/sxiv ]] && _clean $HOME/.config/sxiv

    # tig
    [[ -f $HOME/.tigrc ]] && _clean $HOME/.tigrc

    # tmux
    [[ -f $HOME/.tmux.conf ]] && _clean $HOME/.tmux.conf

    # vim/neovim
    [[ -d $HOME/.vim ]] && _clean $HOME/.vim
    [[ -f $HOME/.vimrc ]] && _clean $HOME/.vimrc
    [[ -d $HOME/.config/nvim ]] && _clean $HOME/.config/nvim

    # x11
    [[ -f $HOME/.Xdefaults ]] && _clean $HOME/.Xdefaults
    [[ -f $HOME/.xinitrc ]] && _clean $HOME/.xinitrc
    [[ -f $HOME/.Xmodmap ]] && _clean $HOME/.Xmodmap
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
    ncal \
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
    fonts-ubuntu \
    fonts-jetbrains-mono \
    poppler-utils \
    xdotool \
    exuberant-ctags \
    dconf-editor \
    gnome-shell-extension-prefs \
    chrome-gnome-shell \
    ufw \
    vsftpd \
    cups \
    bat \
    xcape




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
    kakoune \
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
    simplescreenrecorder \
    mypaint \
    system-config-printer \
    ghostwriter \
    input-remapper \
    nnn




### Add snap/extra packages
###########################

printf "\n"
if _ask "    Add snap and extra packages?" Y; then
    if [[ ! -x "$(command -v snap)" ]]; then
        printf "\n"
        sudo apt install -qq -y snapd
        printf "\n"
    fi
    if _ask "    Install Brave?" Y; then
        printf "\n"
        sudo snap install brave
        printf "\n"
    fi
    if _ask "    Install Google-Chrome?" N; then
        printf "\n"
        _install_chrome
        printf "\n"
    fi
    if _ask "    Install Chromium?" N; then
        printf "\n"
        sudo snap install chromium
        printf "\n"
    fi
    if _ask "    Install Code?" Y; then
        printf "\n"
        sudo snap install --classic code
        printf "\n"
    fi
    if _ask "    Install Codium?" N; then
        printf "\n"
        sudo snap install --classic codium
        printf "\n"
    fi
    if _ask "    Install Alacritty?" Y; then
        printf "\n"
        sudo snap install --classic alacritty
        printf "\n"
    fi
    if _ask "    Install Slides?" N; then
        printf "\n"
        sudo snap install slides
        printf "\n"
    fi
fi




### Backup + add symlinks
#########################

_backup

stow alacritty
stow bash
stow bin
stow ctags
stow fzf
stow i3
stow kakoune
stow kitty
stow nano
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
        opam-doc
    printf "\n    Need Haskell? -> curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh"
    printf "\n    Need Rust?    -> curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh\n\n"
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
