## BASH CONF
############

## ~/.bashrc: executed by bash(1) for non-login shells.
## see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
## for examples


# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac


# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth


# append to the history file, don't overwrite it
shopt -s histappend


# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000


# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize


# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar


# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"


# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi


# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac


# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt


# If this is an xterm set the title to user@host:dir
case "$TERM" in
    xterm*|rxvt*)
        PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
        ;;
    *)
        ;;
esac


# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi


# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'


# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'


# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'


# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi


# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi




## MORE CONF
############

# export my terminal, editor and file-manager variables
export TERM="xterm-256color"
export EDITOR="vim"
export FFF_OPENER="swallow"
export FFF_TRASH_CMD="trash"

# fzf exports (remember to install ripgrep)
export FZF_ALT_C_COMMAND='/bin/ls -ap . | grep -E "/$" | tr -d "/"'
export FZF_CTRL_T_COMMAND='rg --files --hidden -g "!.git" 2>/dev/null'

# special Haskell exports (curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh)
export GHCUP_BIN="$HOME/.ghcup/bin"
export CABAL_BIN="$HOME/.cabal/bin"

# other special exports
export EMACS_BIN="$HOME/.emacs.d/bin"
export CARGO_BIN="$HOME/.cargo/bin"
export GOPATH_BIN="$HOME/go/bin"

# set PATH to includes user's bin, go's bin, cargo's bin and emacs's bin recursively (simpler one: PATH="${HOME}/bin:${HOME}/.local/bin:${PATH}")
export PATH="$PATH:$( find $HOME/bin/ -maxdepth 2 -type d -not -path "/.git/*" -printf ":%p" ):$HOME/.local/bin:$GHCUP_BIN:$CABAL_BIN:$EMACS_BIN:$CARGO_BIN:$GOPATH_BIN"

# check the name of your touchpad and tablet with `xinput`
export TOUCHPADID="GXTP7863:00 27C6:01E0 Touchpad"
export WACOMID="Wacom One by Wacom M Pen stylus"




### Source some shit
#####################

# pfetch
[[ -f $HOME/bin/ufetch ]] && $HOME/bin/ufetch

# fzf
[[ -f $HOME/.fzf.bash ]] && source $HOME/.fzf.bash
[[ -f $HOME/.config/fzf/completion.bash ]] && source $HOME/.config/fzf/completion.bash
[[ -f $HOME/.config/fzf/key-bindings.bash ]] && source $HOME/.config/fzf/key-bindings.bash




## FUNCTIONS
############

# select a wallpaper
function chwall () {
    local WALLP="$HOME/Pictures/wallpapers"
    xhide sxiv -t $WALLP/*
}

# enable/disable touchpad
function xtouchpad () {
    if (( $# == 0 )); then
        echo "specify if you want to enable (1) or disable (0) your touchpad"
        return
    fi
    local TOUCH=$(xinput | grep "$TOUCHPADID" | awk -v k=id '{for(i=2;i<=NF;i++) {split($i,a,"="); m[a[1]]=a[2]} print m[k]}')
    xinput set-prop $TOUCH "Device Enabled" $1
}

# set input to a single monitor (check output monitor with xrandr)
function xwacom-output () {
    local MONITOR=$(xrandr --query | grep " connected" | awk 'NR==1 {print $1}')
    if [[ $(xrandr --query | grep " connected" | cut -d" " -f1 | wc -l) -eq 2 ]]; then
        [[ $1 -eq 2 ]] && MONITOR=$(xrandr --query | grep " connected" | awk 'NR==2 {print $1}')
    fi
    xinput map-to-output $(xinput | grep "$WACOMID" | awk -v k=id '{for(i=2;i<=NF;i++) {split($i,a,"="); m[a[1]]=a[2]} print m[k]}') $MONITOR
}

# Rotate Wacom input (xsetwacom needed)
function xwacom-rotate () {
    local XWACOMID=$(xinput | grep "$WACOMID" | awk -v k=id '{for(i=2;i<=NF;i++) {split($i,a,"="); m[a[1]]=a[2]} print m[k]}')
    if (( $# == 0 )); then
        xsetwacom --set $XWACOMID Rotate half
        return
    fi
    case $1 in
        "0")
            xsetwacom --set $XWACOMID Rotate none
            ;;
        "1")
            xsetwacom --set $XWACOMID Rotate ccw
            ;;
        "2")
            xsetwacom --set $XWACOMID Rotate half
            ;;
        "3")
            xsetwacom --set $XWACOMID Rotate cw
            ;;
        *)
            echo "enter a position from 0 to 3"
            ;;
    esac
}

# Cycle through keyboard layout
function key-layout () {
    case $(setxkbmap -print | awk -F"+" '/xkb_symbols/ {print $2}') in
        "gb")
            setxkbmap -layout it
            echo "it layout"
            ;;
        "it")
            setxkbmap -layout us
            echo "us layout"
            ;;
        *)
            setxkbmap -layout gb
            echo "gb layout"
            ;;
    esac
    xmodmap ~/.Xmodmap
}

# Open last vim session
function vs () {
    if [[ -f "$HOME/.vim/sessions/last" ]]; then
        /bin/vim -S $HOME/.vim/sessions/last
    else
        /bin/vim
    fi
}

# Change directory exiting from fff
function _fff () {
    fff "$@"
    cd "$(cat "${XDG_CACHE_HOME:=${HOME}/.cache}/fff/.fff_d")"
}

# Change directory exiting from shfm
function _shfm () {
    ~/bin/shfm/shfm "$@"
    cd "$(cat ~/.shfm.tmp)"
    rm -f ~/.shfm.tmp
}

# Browse through images in directory after opening a single file
function _sxiv () {
    if command -v sxiv >/dev/null 2>&1; then
        if [ -d "${@: -1}" ] || [ -h "${@: -1}" ]; then
            sxiv -t "$@"
        else
            sxiv    "$@"
        fi
    elif command -v feh >/dev/null 2>&1; then
        feh "$@"
    else
        echo "Please install SXIV or FEH!"
    fi
}




## ALIASES
##########

# confirm before overwriting something
alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"
alias rmfolder="rm -rfi"

# xclip copy-pasta
alias copy="xclip -i -selection clipboard"
alias pasta="xclip -o -selection clipboard"
alias xcopy="xclip-copyfile"
alias xpasta="xclip-pastefile"
alias xcut="xclip-cutfile"

# aliases for fff, shfm, sxiv and vim
alias fff="_fff"
alias shfm="_shfm"
alias sxiv="_sxiv" && [[ -f ~/.config/sxiv/supersxiv ]] && alias sxiv="~/.config/sxiv/supersxiv"
alias vi="/bin/vim --noplugin -n -i NONE"

# logout aliases
alias reboot="systemctl reboot"
alias poweroff="systemctl -i poweroff"

# stow aliases
alias stow="stow -S"
alias restow="stow -R"
alias unstow="stow -D"

# xresources and keyboard aliases
alias xload="xrdb ~/.Xresources"
alias key-swap="xmodmap ~/.Xmodmap"

# other aliases
alias background="feh --bg-fill "
alias xpipes="pipes -n 5 -i 0.025"
