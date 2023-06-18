# You may want to put all your additions into a separate file like this,
# instead of adding them directly into ~/.bashrc.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.


# colors
RED='\033[1;36m'
YLW='\033[1;35m'
NC='\033[0m'


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


# cd on exit
function _fjump () {
    [[ -f "$HOME/bin/ffinders/fjump" ]] || return 1
    PROMPT=${PS1@P}
    $HOME/bin/ffinders/fjump $$
    cd "$(cat /tmp/fjump$$)"
    if [[ -n "$TMUX" ]]; then
        NEWPROMPT=${PS1@P}
        [[ $NEWPROMPT == $PROMPT ]] || echo ${NEWPROMPT@P}
    fi
    rm -f /tmp/fjump$$
}


# list functions
function _fun () {
    SHFUN=$(grep -E '^function [a-z0-9_]+ \(\) \{$' ~/.bash_functions | \
            sed -E 's/function ([a-z0-9_]+) \(\) \{/\1/g' | \
            grep -v _fun | grep -v _ask | sort -k1n | \
            fzf --prompt='Choose you function mate! > ' --height 100% --margin 0% --reverse --info=hidden)
    [[ -n "$SHFUN" && "$(type -t $SHFUN)" == function ]] || return 1
    read -p "$SHFUN: " ARGS
    "$SHFUN" "$ARGS"
}
