# You may want to put all your additions into a separate file like this,
# instead of adding them directly into ~/.bashrc.

# See /usr/share/doc/bash-doc/examples in the bash-doc package.




function _xhide () {
    id=$(xdo id)
    xdo hide
    sh -c "$*" >/dev/null 2>&1
    xdo show "$id"
}


function _xshow () {
    sh -c "$*" & disown >/dev/null 2>&1
}


function _mpv () {
    FILE="$*"
    echo -e "PLAY: ${FILE##*/}\n¯¯¯¯"
    mpv "$FILE"
}


function _vim () {
    [[ -f "/bin/xtermcontrol" ]] && BACKGROUND=$(xtermcontrol --get-bg 2>/dev/null) || BACKGROUND=""
    if [[ "$BACKGROUND" == "rgb:ffff/ffff/ffff" ]]; then
        env vim --cmd "let theme = 'light'" $@
    else
        env vim --cmd "let theme = 'dark'" $@
    fi
}


function _last () {
    if [[ -f "$HOME/.vim/sessions/last.vim" ]]; then
        _vim -S $HOME/.vim/sessions/last.vim
    else
        _vim
    fi
}


function _fff () {
    fff "$@"
    cd "$(cat "${XDG_CACHE_HOME:=${HOME}/.cache}/fff/.fff_d")"
}


function _shfm () {
    ~/bin/shfm/shfm "$@"
    cd "$(cat ~/.shfm.tmp)"
    rm -f ~/.shfm.tmp
}


function _sxiv () {
    if command -v sxiv >/dev/null 2>&1; then
        if [ -d "${@: -1}" ] || [ -h "${@: -1}" ]; then
            sxiv -t "$@"
        else
            sxiv "$@"
        fi
    elif command -v feh >/dev/null 2>&1; then
        feh "$@"
    else
        echo "Install SXIV or FEH!"
    fi
}


function _woutput () {
    RED='\033[1;36m'
    YLW='\033[1;35m'
    NC='\033[0m'

    printf "${RED}%s${NC}\n" "Choose wacom monitor"
    printf "%s${YLW}%s${NC}\n" "  (1) " "master"
    printf "%s${YLW}%s${NC}\n" "  (2) " "slave"
    printf "${RED}%s${NC} " "Enter an index (1-2):"

    while read response; do
        if [[ $(xinput | grep "$WACOMID" | wc -l) -eq 0 ]]; then
            printf "${YLW}%s${NC}\n" "Wacom not conected"
            exit 1
        fi

        case $response in
            1)
                MONITOR=$(xrandr --query | grep " connected" | awk 'NR==1 {print $1}')
                printf "${RED}%s${YLW}%s${NC}\n" "Wacom to " "master"
                break
                ;;
            2)
                if [[ $(xrandr --query | grep " connected" | cut -d" " -f1 | wc -l) -gt 1 ]]; then
                    MONITOR=$(xrandr --query | grep " connected" | awk 'NR==2 {print $1}')
                    printf "${RED}%s${YLW}%s${NC}\n" "Wacom to " "slave"
                else
                    printf "${RED}%s${YLW}%s${RED}%s${NC}\n" "No " "slave" " detected"
                fi
                break
                ;;
            *)
                printf "${RED}%s${NC} " "Enter an index (1-2):"
                ;;
        esac
    done

    xinput map-to-output $(xinput | grep "$WACOMID" | awk -v k=id '{for(i=2;i<=NF;i++) {split($i,a,"="); m[a[1]]=a[2]} print m[k]}') $MONITOR
}


function _wrotate () {
    RED='\033[1;36m'
    YLW='\033[1;35m'
    NC='\033[0m'

    XWACOMID=$(xinput | grep "$WACOMID" | awk -v k=id '{for(i=2;i<=NF;i++) {split($i,a,"="); m[a[1]]=a[2]} print m[k]}')

    printf "${RED}%s${NC}\n" "Rotata wacom"
    printf "%s${YLW}%s${NC}\n" "  (1) " "0°"
    printf "%s${YLW}%s${NC}\n" "  (2) " "90°"
    printf "%s${YLW}%s${NC}\n" "  (3) " "180°"
    printf "%s${YLW}%s${NC}\n" "  (4) " "270°"
    printf "${RED}%s${NC} " "Enter an index (1-4):"

    while read response; do
        if [[ $(xinput | grep "$WACOMID" | wc -l) -eq 0 ]]; then
            printf "${YLW}%s${NC}\n" "Wacom not conected"
            exit 1
        fi

        case $response in
            1)
                ROTATION="none"
                printf "${RED}%s${YLW}%s${NC}\n" "Rotation by " "0°"
                break
                ;;
            2)
                ROTATION="ccw"
                printf "${RED}%s${YLW}%s${NC}\n" "Rotation by " "90°"
                break
                ;;
            3)
                ROTATION="half"
                printf "${RED}%s${YLW}%s${NC}\n" "Rotation by " "180°"
                break
                ;;
            4)
                ROTATION="cw"
                printf "${RED}%s${YLW}%s${NC}\n" "Rotation by " "270°"
                break
                ;;
            *)
                printf "${RED}%s${NC} " "Enter an index (1-4):"
                ;;
        esac
    done

    xsetwacom --set $XWACOMID Rotate $ROTATION
}


function _xlayout () {
    RED='\033[1;36m'
    YLW='\033[1;35m'
    NC='\033[0m'

    printf "${RED}%s${NC}\n" "Layout"
    printf "%s${YLW}%s${NC}\n" "  (1) " "IT"
    printf "%s${YLW}%s${NC}\n" "  (2) " "US"
    printf "%s${YLW}%s${NC}\n" "  (3) " "GB"
    printf "${RED}%s${NC} " "Enter an index (1-3):"

    while read response; do
        case $response in
            1)
                setxkbmap -layout it
                printf "${RED}%s${YLW}%s${NC}\n" "Layout " "IT"
                break
                ;;
            2)
                setxkbmap -layout us
                printf "${RED}%s${YLW}%s${NC}\n" "Layout " "US"
                break
                ;;
            3)
                setxkbmap -layout gb
                printf "${RED}%s${YLW}%s${NC}\n" "Layout " "GB"
                break
                ;;
            *)
                printf "${RED}%s${NC} " "Enter an index (1-3):"
                ;;
        esac
    done

    xmodmap ~/.Xmodmap
}


function _xtouchp () {
    RED='\033[1;36m'
    YLW='\033[1;35m'
    NC='\033[0m'

    TOUCH=$(xinput | grep "$TOUCHPADID" | awk -v k=id '{for(i=2;i<=NF;i++) {split($i,a,"="); m[a[1]]=a[2]} print m[k]}')

    printf "${RED}%s${NC}\n" "Touchpad"
    printf "%s${YLW}%s${NC}\n" "  (1) " "enable"
    printf "%s${YLW}%s${NC}\n" "  (2) " "disable"
    printf "${RED}%s${NC} " "Enter an index (1-2):"

    while read response; do
        case $response in
            1)
                xinput set-prop $TOUCH "Device Enabled" 1
                printf "${RED}%s${YLW}%s${NC}\n" "Touchpad " "enabled"
                break
                ;;
            2)
                xinput set-prop $TOUCH "Device Enabled" 0
                printf "${RED}%s${YLW}%s${NC}\n" "Touchpad " "disabled"
                break
                ;;
            *)
                printf "${RED}%s${NC} " "Enter an index (1-2):"
                ;;
        esac
    done
}
