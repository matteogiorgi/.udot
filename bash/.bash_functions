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
    if [[ -n "$TMUX" ]]; then
        /bin/vim
    else
        [[ -f "/bin/xtermcontrol" ]] && BACKGROUND=$(xtermcontrol --get-bg 2>/dev/null) || BACKGROUND=""
        [[ "$BACKGROUND" == "rgb:ffff/ffff/ffff" ]] && BGCOLOR="'light'" || BGCOLOR="'dark'"
        env vim --cmd "let theme=$BGCOLOR" "$@"
    fi
}


function _vimnoplugin () {
    env vim --noplugin -n -i NONE --cmd "let noplugin=1" "$@"
}


function _vimlastsession () {
    if [[ -f "$HOME/.vim/sessions/last.vim" ]]; then
        _vim -S $HOME/.vim/sessions/last.vim
    else
        _vim
    fi
}


function _tmux () {
    YLW='\033[1;35m'; NC='\033[0m'
    if [[ -n "$TMUX" ]]; then
        printf "${YLW}%s${NC}\n" "WTF mate, you're already in tmux session!"
        return
    fi
    if [[ $(ps -o 'cmd=' -p $(ps -o 'ppid=' -p $$)) == "kitty" ]]; then
        printf "${YLW}%s${NC}\n" "Kitty is already a multiplexer mate!"
        return
    fi
    /bin/tmux >/dev/null
}


function _shfm () {
    PROMPT=${PS1@P}
    ~/bin/shfm/shfm "$@"
    cd "$(cat ~/.shfm.tmp)"
    NEWPROMPT=${PS1@P}
    [[ $NEWPROMPT != $PROMPT ]] && echo ${NEWPROMPT%????}
    rm -f ~/.shfm.tmp
}


function _fjump () {
    PROMPT=${PS1@P}
    ~/bin/fjump
    cd "$(cat ~/.fjump.tmp)"
    NEWPROMPT=${PS1@P}
    [[ $NEWPROMPT != $PROMPT ]] && echo ${NEWPROMPT%????}
    rm -f ~/.fjump.tmp
}


function _fgit () {
    # FZF git commit browser:
    # [enter=show] [ctrl-d=diff] [`=sort]
    YLW='\033[1;35m'; NC='\033[0m'
    if [[ $(git rev-parse --is-inside-work-tree 2>/dev/null) == "true" ]]; then
        local out shas sha q k
        while out=$(
                git log --graph --color=always \
                    --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
                fzf --ansi --multi --no-sort --reverse --query="$q" --tiebreak=index \
                    --print-query --expect=ctrl-d --toggle-sort=\`); do
            q=$(head -1 <<< "$out")
            k=$(head -2 <<< "$out" | tail -1)
            shas=$(sed '1,2d;s/^[^a-z0-9]*//;/^$/d' <<< "$out" | awk '{print $1}')
            [ -z "$shas" ] && continue
            if [ "$k" = 'ctrl-d' ]; then
                git diff --color=always $shas | less -R -~
            else
                for sha in $shas; do
                    git show --color=always $sha | less -R -~
                done
            fi
        done
    else
        printf "${YLW}%s${NC}\n" "WTF mate, you're not in a git repo!"
    fi
}


function _tig () {
    YLW='\033[1;35m'; NC='\033[0m'
    if [[ $(git rev-parse --is-inside-work-tree 2>/dev/null) == "true" ]]; then
        tig
    else
        printf "${YLW}%s${NC}\n" "WTF mate, you're not in a git repo!"
    fi
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


function _chbg () {
    BACKGROUNDS="$HOME/Pictures/backgrounds"
    [[ -z "$(ls -A $BACKGROUNDS 2>/dev/null)" ]] && exit 1

    RED='\033[1;36m'
    YLW='\033[1;35m'
    NC='\033[0m'

    count=1
    list=$(/usr/bin/ls $BACKGROUNDS)
    max=$(($(/usr/bin/ls $BACKGROUNDS | wc -w)+1))

    printf "${RED}%s${NC}\n" "Choose a background:"
    for file in $list
    do
        echo "$count $file"
        ((count++))
    done
    printf "${RED}%s${NC} " "Enter a number from 1 to $(($max-1)):"

    while read response; do
        re='^[0-9]+$'
        [[ $response =~ $re && "$response" -gt 0 && "$response" -lt "$max" ]] && break
        printf "${RED}%s${NC} " "Enter a number from 1 to $(($max-1)):"
    done

    bgrnd=$(/usr/bin/ls $BACKGROUNDS | head -n $response | tail -n 1)
    feh --bg-fill "$BACKGROUNDS/$bgrnd"
    printf "${YLW}%s\n${NC}" "Done."
}


function _woutput () {
    source $HOME/.xinput.bash

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
    source $HOME/.xinput.bash

    RED='\033[1;36m'
    YLW='\033[1;35m'
    NC='\033[0m'

    XWACOMID=$(xinput | grep "$WACOMID" | awk -v k=id '{for(i=2;i<=NF;i++) {split($i,a,"="); m[a[1]]=a[2]} print m[k]}')

    printf "${RED}%s${NC}\n" "Rotata wacom"
    printf "%s${YLW}%s${NC}\n" "  (0) " "0°"
    printf "%s${YLW}%s${NC}\n" "  (1) " "90°"
    printf "%s${YLW}%s${NC}\n" "  (2) " "180°"
    printf "%s${YLW}%s${NC}\n" "  (3) " "270°"
    printf "${RED}%s${NC} " "Enter an index (0-3):"

    while read response; do
        if [[ $(xinput | grep "$WACOMID" | wc -l) -eq 0 ]]; then
            printf "${YLW}%s${NC}\n" "Wacom not conected"
            exit 1
        fi

        case $response in
            0)
                ROTATION="none"
                printf "${RED}%s${YLW}%s${NC}\n" "Rotation by " "0°"
                break
                ;;
            1)
                ROTATION="ccw"
                printf "${RED}%s${YLW}%s${NC}\n" "Rotation by " "90°"
                break
                ;;
            2)
                ROTATION="half"
                printf "${RED}%s${YLW}%s${NC}\n" "Rotation by " "180°"
                break
                ;;
            3)
                ROTATION="cw"
                printf "${RED}%s${YLW}%s${NC}\n" "Rotation by " "270°"
                break
                ;;
            *)
                printf "${RED}%s${NC} " "Enter an index (0-3):"
                ;;
        esac
    done

    xsetwacom --set $XWACOMID Rotate $ROTATION
}


function _xtouchp () {
    source $HOME/.xinput.bash

    RED='\033[1;36m'
    YLW='\033[1;35m'
    NC='\033[0m'

    TOUCH=$(xinput | grep "$TOUCHPADID" | awk -v k=id '{for(i=2;i<=NF;i++) {split($i,a,"="); m[a[1]]=a[2]} print m[k]}')

    printf "${RED}%s${NC}\n" "Touchpad"
    printf "%s${YLW}%s${NC}\n" "  (0) " "disable"
    printf "%s${YLW}%s${NC}\n" "  (1) " "enable"
    printf "${RED}%s${NC} " "Enter an index (0-1):"

    while read response; do
        case $response in
            0)
                xinput set-prop $TOUCH "Device Enabled" 0
                printf "${RED}%s${YLW}%s${NC}\n" "Touchpad " "disabled"
                break
                ;;
            1)
                xinput set-prop $TOUCH "Device Enabled" 1
                printf "${RED}%s${YLW}%s${NC}\n" "Touchpad " "enabled"
                break
                ;;
            *)
                printf "${RED}%s${NC} " "Enter an index (0-1):"
                ;;
        esac
    done
}


function _xlayout () {
    RED='\033[1;36m'
    YLW='\033[1;35m'
    NC='\033[0m'

    printf "${RED}%s${NC}\n" "Layout"
    printf "%s${YLW}%s${NC}\n" "  (0) " "US"
    printf "%s${YLW}%s${NC}\n" "  (1) " "GB"
    printf "%s${YLW}%s${NC}\n" "  (2) " "IT"
    printf "${RED}%s${NC} " "Enter an index (1-3):"

    while read response; do
        case $response in
            0)
                printf "#!/bin/sh\nsetxkbmap -layout us\n" > ~/.xlayout
                printf "${RED}%s${YLW}%s${NC}\n" "Layout " "US"
                break
                ;;
            1)
                printf "#!/bin/sh\nsetxkbmap -layout gb\n" > ~/.xlayout
                printf "${RED}%s${YLW}%s${NC}\n" "Layout " "GB"
                break
                ;;
            2)
                printf "#!/bin/sh\nsetxkbmap -layout it\n" > ~/.xlayout
                printf "${RED}%s${YLW}%s${NC}\n" "Layout " "IT"
                break
                ;;
            *)
                printf "${RED}%s${NC} " "Enter an index (1-3):"
                ;;
        esac
    done

    chmod 755 ~/.xlayout
    ~/.xlayout
    xmodmap ~/.Xmodmap
}


function _ipreview () {
    FILE=$*
    RED='\033[1;36m'
    NC='\033[0m'

    # remember to install PIL/Pillow: pip3 install PIL/Pillow
    if [[ $(ps -o 'cmd=' -p $(ps -o 'ppid=' -p $$)) == "kitty" ]]; then
        kitty +kitten icat "$FILE"
    elif [[ -x "$(command -v tcv)" ]]; then
        tcv "$FILE" 2>/dev/null
    else
        printf "${RED}%s${NC}\n" "Can't preview shit, do something!"
    fi
}
