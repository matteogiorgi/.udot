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

function _fun () {
    SHFUN=$(grep -E '^function [a-z0-9_]+ \(\) \{$' ~/.bash_functions | \
            sed -E 's/function ([a-z0-9_]+) \(\) \{/\1/g' | \
            grep -v _fun | grep -v _ask | sort -k1n | \
            fzf --prompt='Choose you function mate! > ' --height 100% --margin 0% --reverse --info=hidden --header-first)
    [[ -n "$SHFUN" && "$(type -t $SHFUN)" == function ]] || return 1
    read -p "$SHFUN: " ARGS
    "$SHFUN" "$ARGS"
}


# no alias
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


# no alias
function _xhide () {
    [[ -f "/bin/xdo" ]] || return 1
    id=$(xdo id); xdo hide
    sh -c "$*" >/dev/null 2>&1
    xdo show "$id"
}


# no alias
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
