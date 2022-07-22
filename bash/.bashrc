# ~/.bashrc: executed by bash(1) for non-login shells.
# See /usr/share/doc/bash/examples/startup-files (in the package bash-doc) for examples.




### Only interactive mode
#########################

case $- in
    *i*) ;;
      *) return;;
esac




### History
###########

HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s histappend




### Window size and pathname expansion
######################################

shopt -s checkwinsize
shopt -s globstar




### Friendly less and working chroot
####################################

[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi




### Fancy prompt
################

case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac




### Colored prompt
##################

force_color_prompt=yes
if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
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




### XTerm title
###############

case "$TERM" in
    xterm*|rxvt*)
        PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
        ;;
    *)
        ;;
esac




### Color support
#################

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi




### Colored GCC
###############

export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'




## Functions
############

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

function _rover () {
    if command -v rover >/dev/null 2>&1; then
        rover "$@" -d ~/.rover$$.tmp
        cd "$(cat ~/.rover$$.tmp)"
        rm -f ~/.rover$$.tmp
    else
        echo "rover is not installed"
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
            sxiv    "$@"
        fi
    elif command -v feh >/dev/null 2>&1; then
        feh "$@"
    else
        echo "Please install SXIV or FEH!"
    fi
}




### Alert alias for long commands (sleep 10; alert)
###################################################

alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'




### Alias definitions
#####################

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi




### Programmable completion features
####################################

if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi




## More conf
############

export TERM="xterm-256color"
export SHELL="/bin/bash"
export PAGER="less"
export VISUAL="vim"
export EDITOR="vim"
export ROVER_VISUAL='sim'
export ROVER_EDITOR='sim'
export ROVER_OPEN='swallow'
export FFF_OPENER="swallow"
export FFF_TRASH_CMD="trash"
export FZF_ALT_C_COMMAND='/bin/ls -ap . | grep -E "/$" | tr -d "/"'
export FZF_CTRL_T_COMMAND='rg --files --hidden -g "!.git" 2>/dev/null'




### Source stuff
################

[[ ! -f $HOME/.xinput.bash ]] && printf "export TOUCHPADID=''\nexport WACOMID=''" > $HOME/.xinput.bash
source $HOME/.xinput.bash

[[ -f $HOME/bin/fet ]] && $HOME/bin/fet
[[ -f $HOME/.fzf.bash ]] && source $HOME/.fzf.bash
[[ -f $HOME/.config/fzf/completion.bash ]] && source $HOME/.config/fzf/completion.bash
[[ -f $HOME/.config/fzf/key-bindings.bash ]] && source $HOME/.config/fzf/key-bindings.bash




## Keybindings (add `set -o vi` for vi mode)
############################################

bind '"\C-h"':"\"_last\C-m\""
bind '"\C-j"':"\"_vim\C-m\""
bind '"\C-k"':"\"_rover\C-m\""
