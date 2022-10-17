# You may want to put all your additions into a separate file like this,
# instead of adding them directly into ~/.bashrc.

# See /usr/share/doc/bash-doc/examples in the bash-doc package.




alias l='ls -CF'
alias la='ls -A'
alias ll='ls -alFtr'
alias lt="tree -aC --dirsfirst | less -R -~"


alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"
alias rmfolder="rm -rfi"


alias copy="xclip -i -selection clipboard"
alias pasta="xclip -o -selection clipboard"
alias xcopy="xclip-copyfile"
alias xpasta="xclip-pastefile"
alias xcut="xclip-cutfile"


alias vim="_vim"
alias vimlastsession="_vimlastsession"
alias vimnoplugin="_vimnoplugin"


alias tmux="_tmux"
alias xhide="_xhide"
alias xshow="_xshow"
alias shfm="_shfm"
alias fjump="_fjump"
alias fgit="_fgit"
alias tig="_tig"
alias sxiv="_sxiv"
alias chbg="_chbg"
alias ipreview="_ipreview"
alias xopp2pdf="_xopp2pdf"


alias atooladd="atool --add"
alias atoolext="atool --extract"


alias woutput="_woutput"
alias wrotate="_wrotate"
alias xtouchp="_xtouchp"
alias xlayout="_xlayout"


alias kswap="xmodmap ~/.Xmodmap"
alias xload="xrdb ~/.Xresources"


alias autodual="autorandr --load dual"
alias automaster="autorandr --load master"
alias autoslave="autorandr --load slave"


alias reboot="systemctl reboot"
alias poweroff="systemctl -i poweroff"


alias stow="stow -S"
alias restow="stow -R"
alias unstow="stow -D"


alias xbgrnd="$HOME/.fehbg"
alias xpipes="pipes -n 5 -i 0.025"
alias xcal="ncal -y"
