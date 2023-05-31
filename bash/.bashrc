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

[[ -x /usr/bin/lesspipe ]] && eval "$(SHELL=/bin/sh lesspipe)"

if [[ -z "${debian_chroot:-}" ]] && [[ -r /etc/debian_chroot ]]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi




### Fancy prompt
################

case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac




### Colored prompt
##################

[[ -f ~/.git-prompt.sh ]] && source ~/.git-prompt.sh
if [[ -x /usr/bin/tput ]] && tput setaf 1 >&/dev/null; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;94m\]\w\[\033[00m\]'
    [[ $(type -t __git_ps1) == function ]] && PS1=$PS1'\[\033[01;33m\]$(__git_ps1 " (%s)")\[\033[00m\]\n ' || PS1=$PS1'\n '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w'
    [[ $(type -t __git_ps1) == function ]] && PS1=$PS1'$(__git_ps1 " (%s)")\n ' || PS1=$PS1'\n '
fi




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

if [[ -x /usr/bin/dircolors ]]; then
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




### Functions definition
########################

if [[ -f ~/.bash_functions ]]; then
    . ~/.bash_functions
fi




### Alert alias for long commands (sleep 10; alert)
###################################################

alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'




### Aliases definition
######################

if [[ -f ~/.bash_aliases ]]; then
    . ~/.bash_aliases
fi




### Programmable completion features
####################################

if ! shopt -oq posix; then
    if [[ -f /usr/share/bash-completion/bash_completion ]]; then
        . /usr/share/bash-completion/bash_completion
    elif [[ -f /etc/bash_completion ]]; then
        . /etc/bash_completion
    fi
fi




## ENV vars
###########

export TERM="xterm-256color"
export SHELL="/bin/bash"
export PAGER="/bin/less -~"




## Fzf vars
###########

export FZF_ALT_C_COMMAND='/bin/ls -ap . | grep -E "/$" | tr -d "/"'
export FZF_CTRL_T_COMMAND='rg --files --hidden -g "!.git" 2>/dev/null'




## Less colors
##############

# black   = 30        blue    = 34        reset      = 0
# red     = 31        magenta = 35        bold       = 1
# green   = 32        cyan    = 36        faint      = 2
# yellow  = 33        white   = 37        underlined = 4

export LESS_TERMCAP_mb=$'\e[01;31m'     # begin blinking
export LESS_TERMCAP_md=$'\e[01;31m'     # begin bold
export LESS_TERMCAP_me=$'\e[0m'         # end mode
export LESS_TERMCAP_so=$'\e[01;44;37m'  # begin standout-mode
export LESS_TERMCAP_se=$'\e[0m'         # end standout-mode
export LESS_TERMCAP_us=$'\e[01;33m'     # begin underline
export LESS_TERMCAP_ue=$'\e[0m'         # end underline




### Source stuff
################

[[ -f $HOME/bin/ufetch ]] && $HOME/bin/ufetch
[[ -f $HOME/.xinput.bash ]] && source $HOME/.xinput.bash
[[ -f $HOME/.fzf.bash ]] && source $HOME/.fzf.bash
[[ -f $HOME/.config/fzf/completion.bash ]] && source $HOME/.config/fzf/completion.bash
[[ -f $HOME/.config/fzf/key-bindings.bash ]] && source $HOME/.config/fzf/key-bindings.bash




## Keybindings and set modes (vi mode)
## I do not use ~/.inputrc in this config
#########################################

set -o vi
PROMPT=${PS1@P}

bind -m vi-command -x '"\C-h": fgit'
bind -m vi-command -x '"\C-j": fjump'
bind -m vi-command -x '"\C-k": ffind'
bind -m vi-command -x '"\C-l": PROMPT=${PS1@P}; clear; echo ${PROMPT@P}'
bind -m vi-command -x '"\C-f": ffm'

bind -m vi-insert -x '"\C-h": fgit'
bind -m vi-insert -x '"\C-j": fjump'
bind -m vi-insert -x '"\C-k": ffind'
bind -m vi-insert -x '"\C-l": PROMPT=${PS1@P}; clear; echo ${PROMPT@P}'
bind -m vi-insert -x '"\C-f": ffm'

bind 'TAB:menu-complete'
bind '"\e[Z":menu-complete-backward'

bind 'set show-all-if-ambiguous on'            # completions listed immediately
bind 'set show-all-if-unmodified on'           # completions with no partial completion
bind 'set completion-ignore-case on'           # auto completion to ignore cases
bind 'set completion-prefix-display-length 3'  # 3 char as common prefix in completions
bind 'set mark-symlinked-directories on'       # symlink dir completion to have a slash
bind 'set visible-stats on'                    # completions appending characters indicating file type
bind 'set colored-stats on'                    # completions using different colors
bind 'set show-mode-in-prompt on'              # show vim-mode inside prompt
bind 'set vi-ins-mode-string ">>"'             # vi-mode insert
bind 'set vi-cmd-mode-string "<<"'             # vi-mode command
