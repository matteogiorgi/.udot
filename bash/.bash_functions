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

function _f () {
    SHFUN=$(grep -E '^function [a-z0-9_]+ \(\) \{$' ~/.bash_functions | \
            sed -E 's/function ([a-z0-9_]+) \(\) \{/\1/g' | \
            grep -v _f | grep -v _ask | grep -v _setbackgroundcolor | sort -k1n | \
            fzf --prompt='Choose you function mate! > ' --height 100% --margin 0% --reverse --info=hidden --header-first)
    [[ -n "$SHFUN" && "$(type -t $SHFUN)" == function ]] || return 1
    read -p "$SHFUN: " ARGS
    "$SHFUN" "$ARGS"
}


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


function _xopen () {
    if [[ $# -eq 0 ]]; then
        printf "${YLW}%s${NC}\n" "Open what!?"
        return 1
    fi
    _xshow "xdg-open $*"
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


function _mpv () {
    [[ -f "/bin/mpv" ]] || return 1
    FILE="$*"
    echo -e "PLAY: ${FILE##*/}\n¯¯¯¯"
    mpv "$FILE"
}


function _killapps () {
    while read -r app; do
        wmctrl -i -c "$app"
    done < <(wmctrl -l | awk '{print $1}')
}


function _logouti3 () {
    if _ask "Exit I3?" N; then
        _killapps
        i3-msg exit
    fi
}


function _rebooti3 () {
    if _ask "Reboot I3?" N; then
        _killapps
        i3-msg exec reboot
    fi
}


function _poweroffi3 () {
    if _ask "Poweroff I3?" N; then
        _killapps
        i3-msg exec poweroff
    fi
}


function _setbackgroundcolor () {
    [[ -f "/bin/xtermcontrol" ]] || return 1
    if [[ "$(xtermcontrol --get-bg 2>/dev/null)" == "rgb:ffff/ffff/ffff" ]]; then
        export BACKGROUNDCOLOR="'light'"
    else
        export BACKGROUNDCOLOR="'dark'"
    fi
}


function _vim () {
    if [[ -f "/bin/vim" ]]; then
        [[ -z "$BACKGROUNDCOLOR" ]] && _setbackgroundcolor
        env \vim --cmd "let theme=$BACKGROUNDCOLOR" "$@"
    else
        "${EDITOR:=vi}" "$@"
    fi
}


function _vim_vanilla () {
    if [[ -f "/bin/vim" ]]; then
        [[ -z "$BACKGROUNDCOLOR" ]] && _setbackgroundcolor
        \vim -u NONE "$@"
    else
        "${EDITOR:=vi}" "$@"
    fi
}


function _vim_last () {
    [[ -f "/bin/vim" ]] || return 1
    if [[ -f "$HOME/.vim/sessions/last.vim" ]]; then
        _vim -S $HOME/.vim/sessions/last.vim
    else
        _vim
    fi
}


function _hx () {
    if [[ -f "/bin/hx" ]]; then
        \hx "$@"
    else
        "${EDITOR:=vi}" "$@"
    fi
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
    [[ -z "$BACKGROUNDCOLOR" ]] && _setbackgroundcolor
    /bin/tmux -L $BACKGROUNDCOLOR 2>/dev/null
}


function _shfm () {
    [[ -f "$HOME/bin/shfm" ]] || return 1
    PROMPT=${PS1@P}
    $HOME/bin/shfm "$@"
    cd "$(cat /tmp/shfm)"
    NEWPROMPT=${PS1@P}
    [[ $NEWPROMPT != $PROMPT ]] && echo ${NEWPROMPT%????}
    rm -f /tmp/shfm
}


function _fkak () {
    [[ -f "$HOME/bin/fkak" ]] || return 1
    PROMPT=${PS1@P}
    $HOME/bin/fkak $$
    cd "$(cat /tmp/fkak$$)"
    NEWPROMPT=${PS1@P}
    [[ $NEWPROMPT != $PROMPT ]] && echo ${NEWPROMPT%????}
    rm -f /tmp/fkak$$
}


function _fjump () {
    [[ -f "$HOME/bin/fjump" ]] || return 1
    PROMPT=${PS1@P}
    $HOME/bin/fjump $$
    cd "$(cat /tmp/fjump$$)"
    NEWPROMPT=${PS1@P}
    [[ $NEWPROMPT != $PROMPT ]] && echo ${NEWPROMPT%????}
    rm -f /tmp/fjump$$
}


function _fgit () {
    # FZF git commit browser:
    # [enter=show] [ctrl-d=diff] [ctrl-l=sort]
    [[ -x "$(command -v fzf)" && -x "$(command -v git)" ]] || return 1
    if [[ $(git rev-parse --is-inside-work-tree 2>/dev/null) == "true" ]]; then
        local out shas sha q k
        while out=$(
                git log --graph --color=always \
                    --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
                fzf --prompt="$PWD > " --ansi --multi --no-sort --reverse --query="$q" --tiebreak=index \
                    --bind 'esc:,change:first,ctrl-h:cancel' \
                    --print-query --expect=ctrl-d --toggle-sort=ctrl-l); do
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


function _sxiv () {
    [[ -f "/bin/sxiv" ]] || return 1
    if command -v \sxiv >/dev/null 2>&1; then
        [[ -d "${@: -1}" || -h "${@: -1}" ]] && \sxiv -t "$@" || \sxiv "$@"
    elif command -v feh >/dev/null 2>&1; then
        feh "$@"
    else
        echo "Install SXIV or FEH!"
    fi
}


function _wallpaper_picker () {
    BACKGROUNDS="$HOME/Pictures/backgrounds"
    [[ -z "$(\ls -A $BACKGROUNDS 2>/dev/null)" || ! -x "$(command -v feh)" ]] && return 1
    if [[ -x "$(command -v fzf)" ]]; then
        \cd "$BACKGROUNDS"
        FILE="$(\ls | fzf --ansi --preview 'mess {}' --preview-window 'down,80%,border-sharp' --prompt="fwall > " --height 100% --margin 0% --reverse --info=hidden --header-first)"
        \cd - &>/dev/null
        [[ -z "$FILE" ]] && return 1
    else
        count=1
        LIST=$(\ls $BACKGROUNDS)
        MAX=$(($(\ls $BACKGROUNDS | wc -w)+1))
        printf "${RED}%s${NC}\n" "Choose your background mate:"
        for file in $LIST
        do
            echo "$count $file"
            ((count++))
        done
        printf "${RED}%s${NC} " "Enter a number from 1 to $(($MAX-1)):"
        while read response; do
            re='^[0-9]+$'
            [[ $response =~ $re && "$response" -gt 0 && "$response" -lt "$MAX" ]] && break
            printf "${RED}%s${NC} " "Enter a number from 1 to $(($MAX-1)):"
        done
        FILE=$(\ls $BACKGROUNDS | head -n $response | tail -n 1)
    fi
    feh --bg-fill $BACKGROUNDS/$FILE 2>/dev/null
}


function _temperature_picker () {
    [[ -x "$(command -v fzf)" && -x "$(command -v sct)" ]] || return 1
    RANGE="3500      ## Ghibli\n4500      ## Campfire\n5500      ## Scirocco\n6500      ## Midday\n7500      ## Mistral\n8500      ## Chilly\n9500      ## Icy\n"
    TEMPE=$(printf "$RANGE" | fzf --prompt='fcolor > ' --height 100% --margin 0% --reverse --info=hidden --header-first)
    [[ -n "$TEMPE" ]] && sct "$TEMPE" || return 1
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


function _gitinit () {
    [[ -x "$(command -v git)" ]] || return 1
    if [[ ! -d "./.git" ]]; then
        git init
cat 2>/dev/null > ./.gitignore <<-EOF
tags*
EOF
    fi
}
