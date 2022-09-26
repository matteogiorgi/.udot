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


alias vim="_vim"
alias vil="_vil"
alias vip="vim --noplugin -n -i NONE"


alias xtool="atool -x"
alias xhide="_xhide"
alias xshow="_xshow"
alias shfm="_shfm"
alias fjump="_fjump"
alias fgit="_fgit"
alias sxiv="_sxiv"


alias randrsave="autorandr -s"
alias randrload="autorandr -l"


alias woutput="_woutput"
alias wrotate="_wrotate"
alias xtouchp="_xtouchp"
alias xlayout="_xlayout"


alias kswap="xmodmap ~/.Xmodmap"
alias xload="xrdb ~/.Xresources"


alias xmono="autorandr --load mono"
alias xdual="autorandr --load dual"


alias reboot="systemctl reboot"
alias poweroff="systemctl -i poweroff"


alias stow="stow -S"
alias restow="stow -R"
alias unstow="stow -D"


alias xbgrnd="$HOME/.fehbg"
alias xpipes="pipes -n 5 -i 0.025"
alias xshift="redshift-gtk -Pr -t 8000:5000"
alias ltree="tree -aC --dirsfirst | less -R -~"
