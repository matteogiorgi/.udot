# You may want to put all your additions into a separate file like this,
# instead of adding them directly into ~/.bashrc.

# See /usr/share/doc/bash-doc/examples in the bash-doc package.




# COLORS
########

RED='\033[1;36m'
YLW='\033[1;35m'
NC='\033[0m'




# FUNCTIONS
###########

# without alias
function _ask () {
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


function _fun () {
    SHFUN=$(grep -E '^function [a-z0-9_]+ \(\) \{$' ~/.bash_functions | \
            sed -E 's/function ([a-z0-9_]+) \(\) \{/\1/g' | \
            grep -v _fun | grep -v _ask | sort -k1n | \
            fzf --prompt='Choose you function mate! > ' --height 100% --margin 0% --reverse --info=hidden --header-first)
    [[ -n "$SHFUN" && "$(type -t $SHFUN)" == function ]] || return 1
    read -p "$SHFUN: " ARGS
    "$SHFUN" "$ARGS"
}


function _xhide () {
    [[ -f "/bin/xdo" ]] || return 1
    id=$(xdo id); xdo hide
    sh -c "$*" >/dev/null 2>&1
    xdo show "$id"
}


function _xshow () {
    nohup sh -c "$*" &>/tmp/xshow.out & disown
}


function _tmux () {
    [[ -f "/bin/tmux" ]] || return 1
    if [[ -n "$TMUX" ]]; then
        printf "${YLW}%s${NC}\n" "WTF mate, you're already in a tmux session!"
        return
    fi
    if [[ $(ps -p $(ps -p $$ -o ppid=) -o args=) == "/bin/kitty" ]]; then
        printf "${YLW}%s${NC}\n" "Kitty is already a multiplexer mate!"
        return
    fi
    /bin/tmux 2>/dev/null
}


function _ffm () {
    [[ -f "$HOME/bin/ffm" ]] || return 1
    PROMPT=${PS1@P}
    $HOME/bin/ffm "$@"
    cd "$(cat /tmp/ffm)"
    NEWPROMPT=${PS1@P}
    [[ $NEWPROMPT == $PROMPT ]] || echo ${NEWPROMPT@P}
    rm -f /tmp/ffm
}


function _fjump () {
    [[ -f "$HOME/bin/fjump" ]] || return 1
    PROMPT=${PS1@P}
    $HOME/bin/fjump $$
    cd "$(cat /tmp/fjump$$)"
    NEWPROMPT=${PS1@P}
    [[ $NEWPROMPT == $PROMPT ]] || echo ${NEWPROMPT@P}
    rm -f /tmp/fjump$$
}


function _autorandr_mode () {
    [[ -f ~/.xinput.bash ]] || printf "TOUCHPADID=''\nTOUCHPADST='on'\n\nWACOMID=''\nWACOMRO='0'\nWACOMMO='master'\n\nAUTORANDR='master'" > ~/.xinput.bash
    source $HOME/.xinput.bash
    AUTORANDRMODE="$*"
    [[ -x "$(command -v autorandr)" ]] || return 1
    if [[ "$AUTORANDRMODE" == "" ]]; then
        printf "${YLW}%s${NC}\n" "You need to specify your monitor mode mate!"
        return
    fi
    autorandr --load $AUTORANDRMODE 2>/dev/null
    [[ -f ~/.fehbg ]] && PIC=$(awk 'FNR==2 {print $4}' ~/.fehbg)
    [[ -n $PIC && -f ${PIC:1:-1} && -x "$(command -v feh)" ]] && ~/.fehbg
    sed -i "s/AUTORANDR=.*/AUTORANDR='$AUTORANDRMODE'/g" $HOME/.xinput.bash
}


function _xwacom () {
    [[ -f ~/.xinput.bash ]] || printf "TOUCHPADID=''\nTOUCHPADST='on'\n\nWACOMID=''\nWACOMRO='0'\nWACOMMO='master'\n\nAUTORANDR='master'" > ~/.xinput.bash
    source $HOME/.xinput.bash
    if [[ "$WACOMID" == "" ]]; then
        printf "${YLW}%s${NC}\n" "Wacom not specified (check ~/.xinput.bash)"
        return
    fi
    if [[ $(xinput | grep "$WACOMID" | wc -l) -eq 0 ]]; then
        printf "${YLW}%s${NC}\n" "Wacom not conected"
        return
    fi
    XWACOMID=$(xinput | grep "$WACOMID" | awk -v k=id '{for(i=2;i<=NF;i++) {split($i,a,"="); m[a[1]]=a[2]} print m[k]}')
    printf "${RED}%s\n%s${NC}\n" "ROTATION == $WACOMRO" "MONITOR  == $WACOMMO"
    if _ask "Do you wanna change specs?" N; then
        printf "${RED}%s${NC} " "Wacom ROTATION (0/90/180/270):"
        while read ROTATION; do
            [[ "$ROTATION" == "0" || "$ROTATION" == "90" || "$ROTATION" == "180" || "$ROTATION" == "270" ]] && break
            printf "${RED}%s${NC} " "Wacom ROTATION (0/90/180/270):"
        done
        printf "${RED}%s${NC} " "Wacom MONITOR (master/slave):"
        while read MONITOR; do
            [[ "$MONITOR" == "master" || "$MONITOR" == "slave" ]] && break
            printf "${RED}%s${NC} " "Wacom MONITOR (master/slave):"
        done
    else
        ROTATION=$WACOMRO
        MONITOR=$WACOMMO
    fi
    case $ROTATION in
        0)
            xsetwacom --set $XWACOMID Rotate "none"
            sed -i 's/WACOMRO=.*/WACOMRO='\''0'\''/g' $HOME/.xinput.bash
            ;;
        90)
            xsetwacom --set $XWACOMID Rotate "ccw"
            sed -i 's/WACOMRO=.*/WACOMRO='\''90'\''/g' $HOME/.xinput.bash
            ;;
        180)
            xsetwacom --set $XWACOMID Rotate "half"
            sed -i 's/WACOMRO=.*/WACOMRO='\''180'\''/g' $HOME/.xinput.bash
            ;;
        270)
            xsetwacom --set $XWACOMID Rotate "cw"
            sed -i 's/WACOMRO=.*/WACOMRO='\''270'\''/g' $HOME/.xinput.bash
            ;;
    esac
    case $MONITOR in
        master)
            xinput map-to-output $XWACOMID $(xrandr --query | grep " connected" | awk 'NR==1 {print $1}')
            sed -i 's/WACOMMO=.*/WACOMMO='\''master'\''/g' $HOME/.xinput.bash
            ;;
        slave)
            if [[ $(xrandr --query | grep " connected" | cut -d" " -f1 | wc -l) -gt 1 ]]; then
                xinput map-to-output $XWACOMID $(xrandr --query | grep " connected" | awk 'NR==2 {print $1}')
                sed -i 's/WACOMMO=.*/WACOMMO='\''slave'\''/g' $HOME/.xinput.bash
            fi
            ;;
    esac
    source $HOME/.xinput.bash
    printf "${YLW}%s\n%s${NC}\n" "ROTATION -> $WACOMRO" "MONITOR  -> $WACOMMO"
}


function _xtouch () {
    [[ -f ~/.xinput.bash ]] || printf "TOUCHPADID=''\nTOUCHPADST='on'\n\nWACOMID=''\nWACOMRO='0'\nWACOMMO='master'\n\nAUTORANDR='master'" > ~/.xinput.bash
    source $HOME/.xinput.bash
    if [[ "$TOUCHPADID" == "" ]]; then
        printf "${YLW}%s${NC}\n" "Touchpad not specified (check ~/.xinput.bash)"
        return
    fi
    if [[ $(xinput | grep "$TOUCHPADID" | wc -l) -eq 0 ]]; then
        printf "${YLW}%s${NC}\n" "Touchpad not connected"
        return
    fi
    TOUCHID=$(xinput | grep "$TOUCHPADID" | awk -v k=id '{for(i=2;i<=NF;i++) {split($i,a,"="); m[a[1]]=a[2]} print m[k]}')
    if [[ $TOUCHPADST == "on" ]]; then
        sed -i 's/TOUCHPADST='\''on'\''/TOUCHPADST='\''off'\''/g' $HOME/.xinput.bash
        xinput set-prop $TOUCHID "Device Enabled" 0
        printf "${YLW}%s${NC}\n" "TOUCHPAD -> disabled"
    else
        sed -i 's/TOUCHPADST='\''off'\''/TOUCHPADST='\''on'\''/g' $HOME/.xinput.bash
        xinput set-prop $TOUCHID "Device Enabled" 1
        printf "${YLW}%s${NC}\n" "TOUCHPAD -> enabled"
    fi
}


function _xlayout () {
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


function _xopp2pdf () {
    [[ -x "$(command -v xournalpp)" ]] || return 1
    ARGS="$*"
    if [[ "$ARGS" == "" ]]; then
        [[ ! -d ./pdf ]] && mkdir ./pdf
        LIST=$(find *.xopp)
        for FILE in $LIST; do
            printf "${YLW}%s${NC} -> ${RED}%s${NC}\n" "$FILE" "./pdf/${FILE%.*}.pdf"
            xournalpp "$FILE" -p ./pdf/"${FILE%.*}.pdf" 2>/dev/null
        done
    else
        printf "${YLW}%s${NC} -> ${RED}%s${NC}\n" "$ARGS" "${ARGS%.*}.pdf"
        xournalpp "$ARGS" -p "${ARGS%.*}.pdf" 2>/dev/null
    fi
}


function _mergepdf () {
    [[ -x "$(command -v pdfunite)" ]] || return 1
    ARGS="$*"
    [[ -f "merge.pdf" ]] && rm -f merge.pdf
    if [[ "$ARGS" == "" ]]; then
        pdfunite *.pdf merge.pdf
    else
        pdfunite "$ARGS" merge.pdf
    fi
}
