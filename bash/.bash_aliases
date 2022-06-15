# You may want to put all your additions into a separate file like this,
# instead of adding them directly into ~/.bashrc.

# See /usr/share/doc/bash-doc/examples in the bash-doc package.


alias ll='ls -alFtr'
alias la='ls -A'
alias l='ls -CF'

alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"
alias rmfolder="rm -rfi"

alias copy="xclip -i -selection clipboard"
alias pasta="xclip -o -selection clipboard"
alias xcopy="xclip-copyfile"
alias xpasta="xclip-pastefile"
alias xcut="xclip-cutfile"

alias fff="_fff"
alias shfm="_shfm"
alias sxiv="_sxiv" && [[ -f ~/.config/sxiv/supersxiv ]] && alias sxiv="~/.config/sxiv/supersxiv"
alias vi="/bin/vim --noplugin -n -i NONE"

alias reboot="systemctl reboot"
alias poweroff="systemctl -i poweroff"

alias stow="stow -S"
alias restow="stow -R"
alias unstow="stow -D"

alias xload="xrdb ~/.Xresources"
alias kswap="xmodmap ~/.Xmodmap"

alias xmono="autorandr --load mono"
alias xdual="autorandr --load dual"

alias xbgrnd="$HOME/.fehbg"
alias xpipes="pipes -n 5 -i 0.025"
