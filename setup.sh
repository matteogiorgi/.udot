#!/usr/bin/env bash

RED='\033[1;36m'
YLW='\033[1;35m'
NC='\033[0m'


_loop () {
    while read response; do
        case $response in
			"y" | "Y" | "yes" | "Yes" | "YES")
                break
                ;;
			"n" | "N" | "no" | "No" | "NO" | "")
                printf "${RED}%s${NC}\n" "Ok, bye."
                exit 0
                ;;
            *)
                printf "${RED}%s${NC} " "Answer Y(yes) or n(no)"
                ;;
        esac
    done
}


# udot_install () {
#     sudo apt update && sudo apt upgrade -y
#     sudo apt install openssh-client git wget curl unrar unzip tree xclip make cmake htop ranger gnome-tweak-tool zsh -y
#     sudo apt install trash-cli -y
#     sudo apt install zathura -y
# }


if ! uname -a | grep Ubuntu &> /dev/null; then
    printf "${RED}%s ${YLW}%s ${RED}%s ${YLW}%s${NC} " "This is not a (official)" "Ubuntu" "distribution, do you want to continue anyway?" "(Y/n)"
    _loop
fi


printf "${RED}%s ${YLW}%s${NC} " "This is the installer for udot confs, do you want to continue?" "(Y/n)"
_loop




# cat > /etc/X11/xorg.conf.d/10-synaptics.conf <<-EOF
# Section "InputClass"
#     Identifier "touchpad"
#     Driver "synaptics"
#     MatchIsTouchpad "on"
#         Option "TapButton1" "1"
#         Option "TapButton2" "3"
#         Option "TapButton3" "2"
#         Option "VertEdgeScroll" "off"
#         Option "VertTwoFingerScroll" "on"
#         Option "HorizEdgeScroll" "off"
#         Option "HorizTwoFingerScroll" "on"
#         Option "CircularScrolling" "on"
#         Option "CircScrollTrigger" "2"
#         Option "EmulateTwoFingerMinZ" "40"
#         Option "EmulateTwoFingerMinW" "8"
#         Option "CoastingSpeed" "1"
# EndSection
# EOF
