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


function _xhide () {
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
    if _ask "Do you really wanna exit i3?" N; then
        _killapps
        killall i3
    fi
}


function _rebooti3 () {
    if _ask "Do you really wanna reboot your system?" N; then
        _killapps
        systemctl reboot
    fi
}


function _poweroffi3 () {
    if _ask "Do you really wanna poweroff your system?" N; then
        _killapps
        systemctl -i poweroff
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

function _kitty_theme () {
    if [[ $(ps -p $(ps -p $$ -o ppid=) -o args=) == "/bin/kitty" ]]; then
        [[ -z "$BACKGROUNDCOLOR" ]] && _setbackgroundcolor
        if [[ "$BACKGROUNDCOLOR" == "'light'" ]]; then
            kitty @ set-colors --all --configured $HOME/.config/kitty/colors/gnome-dark.conf
            export BAT_THEME="gruvbox-dark"
            export BACKGROUNDCOLOR="'dark'"
        else
            kitty @ set-colors --all --configured $HOME/.config/kitty/colors/gnome-light.conf
            export BAT_THEME="gruvbox-light"
            export BACKGROUNDCOLOR="'light'"
        fi
    else
        printf "${YLW}%s${NC}\n" "You're not inside Kitty mate!"
    fi
}


function _vim () {
    [[ -f "/bin/vim" ]] || return 1
    [[ -z "$BACKGROUNDCOLOR" ]] && _setbackgroundcolor
    env \vim --cmd "let theme=$BACKGROUNDCOLOR" "$@"
}


function _vim_cocmode () {
    [[ -f "/bin/vim" ]] || return 1
    [[ -z "$BACKGROUNDCOLOR" ]] && _setbackgroundcolor
    env \vim --cmd "let coc_mode=1 | let theme=$BACKGROUNDCOLOR" "$@"
}


function _vim_noplugin () {
    [[ -f "/bin/vim" ]] || return 1
    [[ -z "$BACKGROUNDCOLOR" ]] && _setbackgroundcolor
    env \vim --noplugin -n -i NONE --cmd "let noplugin=1 | let theme=$BACKGROUNDCOLOR" "$@"
}


function _vim_vanilla () {
    [[ -f "/bin/vim" ]] || return 1
    [[ -z "$BACKGROUNDCOLOR" ]] && _setbackgroundcolor
    \vim -u NONE "$@"
}


function _vim_last () {
    [[ -f "/bin/vim" ]] || return 1
    if [[ -f "$HOME/.vim/sessions/last.vim" ]]; then
        _vim -S $HOME/.vim/sessions/last.vim
    else
        _vim
    fi
}


function _nvim () {
    if [[ -f "/bin/nvim" ]]; then
        [[ -z "$BACKGROUNDCOLOR" ]] && _setbackgroundcolor
        env \nvim --cmd "let theme=$BACKGROUNDCOLOR" "$@"
    else
        _vim "$@"
    fi
}


function _nvim_cocmode () {
    if [[ -f "/bin/nvim" ]]; then
        [[ -z "$BACKGROUNDCOLOR" ]] && _setbackgroundcolor
        env \nvim --cmd "let coc_mode=1 | let theme=$BACKGROUNDCOLOR" "$@"
    else
        _vim_cocmode "$@"
    fi
}


function _nvim_noplugin () {
    if [[ -f "/bin/nvim" ]]; then
        [[ -z "$BACKGROUNDCOLOR" ]] && _setbackgroundcolor
        env \nvim --noplugin -n -i NONE --cmd "let noplugin=1 | let theme=$BACKGROUNDCOLOR" "$@"
    else
        _vim_noplugin "$@"
    fi
}


function _nvim_vanilla () {
    if [[ -f "/bin/nvim" ]]; then
        [[ -z "$BACKGROUNDCOLOR" ]] && _setbackgroundcolor
        \nvim -u NONE "$@"
    else
        _vim_vanilla "$@"
    fi
}


function _nvim_last () {
    if [[ -f "/bin/nvim" ]]; then
        [[ -f "$HOME/.vim/sessions/last.nvim" ]] && _nvim -S $HOME/.vim/sessions/last.nvim || _nvim
    else
        _vim_last
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
    [[ -f "$HOME/bin/shfm/shfm" ]] || return 1
    PROMPT=${PS1@P}
    $HOME/bin/shfm/shfm "$@"
    cd "$(cat /tmp/shfm)"
    NEWPROMPT=${PS1@P}
    [[ $NEWPROMPT != $PROMPT ]] && echo ${NEWPROMPT%????}
    rm -f /tmp/shfm
}


function _nnn () {
    [[ -f "/bin/nnn" ]] || return 1
    if [[ "${NNNLVL:-0}" -ge 1 ]]; then
        echo "nnn is already running"
        return
    fi
    export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
    PROMPT=${PS1@P}
    \nnn -c "$@"
    if [ -f "$NNN_TMPFILE" ]; then
        . "$NNN_TMPFILE"
        NEWPROMPT=${PS1@P}
        [[ $NEWPROMPT != $PROMPT ]] && echo ${NEWPROMPT%????}
        rm -f "$NNN_TMPFILE" > /dev/null
    fi
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
    # [enter=show] [ctrl-d=diff] [`=sort]
    [[ -x "$(command -v fzf)" && -x "$(command -v git)" ]] || return 1
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
    [[ -f "/bin/tig" ]] || return 1
    if [[ $(git rev-parse --is-inside-work-tree 2>/dev/null) == "true" ]]; then
        \tig
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


function _chbg () {
    BACKGROUNDS="$HOME/Pictures/backgrounds"
    if [[ ! -z "$(ls -A $BACKGROUNDS 2>/dev/null)" ]]; then
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
    [[ -f ~/.xinput.bash ]] || printf "TOUCHPADID=''\nTOUCHPADST='on'\n\nWACOMID=''\nWACOMRO='0'\nWACOMMO='master'" > ~/.xinput.bash
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
    [[ -f ~/.xinput.bash ]] || printf "TOUCHPADID=''\nTOUCHPADST='on'\n\nWACOMID=''\nWACOMRO='0'\nWACOMMO='master'" > ~/.xinput.bash
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


function _ipreview () {
    # remember to install PIL/Pillow:
    # pip3 install PIL/Pillow
    FILE=$*
    if [[ $(ps -p $(ps -p $$ -o ppid=) -o args=) == "/bin/kitty" ]]; then
        kitty +kitten icat "$FILE"
    elif [[ -x "$(command -v tcv)" ]]; then
        tcv "$FILE" 2>/dev/null
    else
        printf "${RED}%s${NC}\n" "Can't preview shit, sorry mate!"
    fi
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
