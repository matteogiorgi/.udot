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
    nohup sh -c "$*" 2>/dev/null & disown
    sleep 0.125s
    [[ -f "nohup.out" ]] && rm -f nohup.out
}


function _mpv () {
    FILE="$*"
    echo -e "PLAY: ${FILE##*/}\n¯¯¯¯"
    mpv "$FILE"
}


function _setbackgroundcolor () {
    if [[ -f "/bin/xtermcontrol" ]]; then
        if [[ "$(xtermcontrol --get-bg 2>/dev/null)" == "rgb:ffff/ffff/ffff" ]]; then
            export BACKGROUNDCOLOR="'light'"
        else
            export BACKGROUNDCOLOR="'dark'"
        fi
    fi
}


function _nvim () {
    [[ -z "$BACKGROUNDCOLOR" ]] && _setbackgroundcolor
    env nvim --cmd "let theme=$BACKGROUNDCOLOR" "$@"
}


function _vim () {
    [[ -z "$BACKGROUNDCOLOR" ]] && _setbackgroundcolor
    env vim --cmd "let theme=$BACKGROUNDCOLOR" "$@"
}


function _vimnoplugin () {
    [[ -z "$BACKGROUNDCOLOR" ]] && _setbackgroundcolor
    env vim --noplugin -n -i NONE --cmd "let noplugin=1 | let theme=$BACKGROUNDCOLOR" "$@"
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
    [[ -z "$BACKGROUNDCOLOR" ]] && _setbackgroundcolor
    /bin/tmux -L $BACKGROUNDCOLOR 2>/dev/null
}


function _shfm () {
    PROMPT=${PS1@P}
    ~/bin/shfm/shfm "$@"
    cd "$(cat /tmp/shfm)"
    NEWPROMPT=${PS1@P}
    [[ $NEWPROMPT != $PROMPT ]] && echo ${NEWPROMPT%????}
    rm -f /tmp/shfm
}


function _fjump () {
    PROMPT=${PS1@P}
    ~/bin/fjump $$
    cd "$(cat /tmp/fjump$$)"
    NEWPROMPT=${PS1@P}
    [[ $NEWPROMPT != $PROMPT ]] && echo ${NEWPROMPT%????}
    rm -f /tmp/fjump$$
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
    if [[ ! -z "$(ls -A $BACKGROUNDS 2>/dev/null)" ]]; then
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
    fi
}


function _xwacom () {
    source $HOME/.xinput.bash

    RED='\033[1;36m'
    YLW='\033[1;35m'
    NC='\033[0m'

    if [[ $(xinput | grep "$WACOMID" | wc -l) -eq 0 ]]; then
        printf "${YLW}%s${NC}\n" "Wacom not conected"
        return
    fi

    XWACOMID=$(xinput | grep "$WACOMID" | awk -v k=id '{for(i=2;i<=NF;i++) {split($i,a,"="); m[a[1]]=a[2]} print m[k]}')

    printf "${RED}%s${NC} " "Wacom ROTATION (0/90/180/270):"
    while read response; do
        case $response in
            0)
                ROTATION="none"
                PRINT1="ROTATION -> 0°"
                break
                ;;
            90)
                ROTATION="ccw"
                PRINT1="ROTATION -> 90°"
                break
                ;;
            180)
                ROTATION="half"
                PRINT1="ROTATION -> 180°"
                break
                ;;
            270)
                ROTATION="cw"
                PRINT1="ROTATION -> 270°"
                break
                ;;
            *)
                printf "${RED}%s${NC} " "Wacom ROTATION (0/90/180/270):"
                ;;
        esac
    done

    printf "${RED}%s${NC} " "Wacom MONITOR (master/slave):"
    while read response; do
        case $response in
            master)
                MONITOR=$(xrandr --query | grep " connected" | awk 'NR==1 {print $1}')
                PRINT2="MONITOR  -> master"
                break
                ;;
            slave)
                if [[ $(xrandr --query | grep " connected" | cut -d" " -f1 | wc -l) -gt 1 ]]; then
                    MONITOR=$(xrandr --query | grep " connected" | awk 'NR==2 {print $1}')
                    PRINT2="MONITOR  -> slave"
                else
                    PRINT2="MONITOR  -> no slave detected"
                fi
                break
                ;;
            *)
                printf "${RED}%s${NC} " "Wacom MONITOR (master/slave):"
                ;;
        esac
    done

    xsetwacom --set $XWACOMID Rotate $ROTATION
    xinput map-to-output $XWACOMID $MONITOR
    printf "${YLW}%s\n%s${NC}\n" "$PRINT1" "$PRINT2"
}


function _xtouch () {
    source $HOME/.xinput.bash

    RED='\033[1;36m'
    YLW='\033[1;35m'
    NC='\033[0m'

    TOUCH=$(xinput | grep "$TOUCHPADID" | awk -v k=id '{for(i=2;i<=NF;i++) {split($i,a,"="); m[a[1]]=a[2]} print m[k]}')

    printf "${RED}%s${NC} " "Choose TOUCHPAD behavior (enable/disable):"
    while read response; do
        case $response in
            enable)
                xinput set-prop $TOUCH "Device Enabled" 1
                printf "${YLW}%s${NC}\n" "TOUCHPAD -> enabled"
                break
                ;;
            disable)
                xinput set-prop $TOUCH "Device Enabled" 0
                printf "${YLW}%s${NC}\n" "TOUCHPAD -> disabled"
                break
                ;;
            *)
                printf "${RED}%s${NC} " "Choose TOUCHPAD behavior (enable/disable):"
                ;;
        esac
    done
}


function _xlayout () {
    RED='\033[1;36m'
    YLW='\033[1;35m'
    NC='\033[0m'

    printf "${RED}%s${NC} " "Select keyboard LAYOUT (us/gb/it):"
    while read response; do
        case $response in
            us | gb | it)
                break
                ;;
            *)
                printf "${RED}%s${NC} " "Select keyboard LAYOUT (us/gb/it):"
                ;;
        esac
    done

    printf "#!/bin/sh\nsetxkbmap -layout $response\n" > ~/.xlayout
    chmod 755 ~/.xlayout
    ~/.xlayout
    [[ -f ~/bin/xmap ]] && ~/bin/xmap
    printf "${YLW}%s${NC}\n" "LAYOUT -> $response"
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


function _xopp2pdf () {
    RED='\033[1;36m'
    YLW='\033[1;35m'
    NC='\033[0m'

    ARGS="$*"
    if [[ "$ARGS" == "" ]]; then
        LIST=$(find *.xopp)
        for FILE in $LIST; do
            printf "${YLW}%s${NC} -> ${RED}%s${NC}\n" "$FILE" "${FILE%.*}.pdf"
            xournalpp "$FILE" -p "${FILE%.*}.pdf" 2>/dev/null
        done
    else
        printf "${YLW}%s${NC} -> ${RED}%s${NC}\n" "$ARGS" "${ARGS%.*}.pdf"
        xournalpp "$ARGS" -p "${ARGS%.*}.pdf" 2>/dev/null
    fi
}


function _mergepdf () {
    ARGS="$*"
    if [[ "$ARGS" == "" ]]; then
        pdfunite *.pdf merge.pdf
    else
        pdfunite $ARGS merge.pdf
    fi
}


function _gitinit () {
    if [[ ! -d "./.git" ]]; then
        git init
cat 2>/dev/null > ./.gitignore <<-EOF
tags*
EOF
    fi
}
