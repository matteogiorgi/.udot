#!/usr/bin/env bash

# NAME: .udot
# DESCRIPTION: installer for a work environment
# WARNING: there's nothing to worry, try it!
# DEPENDENCIES: none, bash is enough




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




### Start installer
###################

clear
banner
warning
ask "Confirm to start the '.udot' installer:" Y

if ! uname -a | grep Ubuntu &> /dev/null; then
    ask "This is not a Ubuntu distro, continue anyway?" N
fi

printf "\n    -> Syncing and updating repos\n"
printf "    -> Installing 'curl' and 'git'\n\n"

sudo apt update && sudo apt upgrade -y || error "syncing repos"
[[ ! -f /bin/curl ]] sudo apt install curl -y
[[ ! -f /bin/git ]] sudo apt install git -y




# udot_install () {
#     sudo apt update && sudo apt upgrade -y
#     sudo apt install openssh-client git wget curl unrar unzip tree xclip make cmake htop ranger gnome-tweak-tool zsh -y
#     sudo apt install trash-cli -y
#     sudo apt install zathura -y
# }




# dir=`pwd`
# if [ ! -e "${dir}/$(basename $0)" ]; then
#     echo "Script not called from within repository directory. Aborting."
#     exit 2
# fi
# dir="${dir}/.."

# distro=`lsb_release -si`
# if [ ! -f "dependencies-${distro}" ]; then
#     echo "Could not find file with dependencies for distro ${distro}. Aborting."
#     exit 2
# fi

# ask "Install packages?" Y && bash ./dependencies-${distro}

# ask "Install python2 modules?" Y && {
#     sudo pip2 install pyyaml
# }

# ask "Install symlink for .gitconfig?" Y && ln -sfn ${dir}/.gitconfig ${HOME}/.gitconfig
# ask "Install symlink for .bashrc?" Y && ln -sfn ${dir}/.bashrc ${HOME}/.bashrc
# ask "Install symlink for .bash_profile?" Y && ln -sfn ${dir}/.bash_profile ${HOME}/.bash_profile
# ask "Install symlink for .vimrc?" Y && ln -sfn ${dir}/.vimrc ${HOME}/.vimrc
# ask "Install symlink for .Xresources?" Y && ln -sfn ${dir}/.Xresources ${HOME}/.Xresources
# ask "Install symlink for .xinitrc?" Y && ln -sfn ${dir}/.xinitrc ${HOME}/.xinitrc
# ask "Install symlink for .compton.conf?" Y && ln -sfn ${dir}/.compton.conf ${HOME}/.compton.conf
# ask "Install symlink for .gtkrc-2.0?" Y && ln -sfn ${dir}/.gtkrc-2.0 ${HOME}/.gtkrc-2.0
# ask "Install symlink for .npmrc?" Y && ln -sfn ${dir}/.npmrc ${HOME}/.npmrc

# ask "Install symlink for .i3/?" Y && ln -sfn ${dir}/.i3 ${HOME}/.i3
# ask "Install symlink for .vim/?" Y && ln -sfn ${dir}/.vim ${HOME}/.vim
# ask "Install symlink for .bash.d/?" Y && ln -sfn ${dir}/.bash.d ${HOME}/.bash.d
# ask "Install symlink for .config/?" Y && ln -sfn ${dir}/.config ${HOME}/.config

# ask "Install symlink for scripts/?" Y && ln -sfn ${dir}/scripts ${HOME}/scripts
