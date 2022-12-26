# You may want to put all your additions into a separate file
# like this, instead of adding them directly into ~/.bashrc.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.


alias l='ls -CF'
alias la='ls -A'
alias ll='ls -alFtr'


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
alias vimcoc="_vimcoc"
alias vimnp="_vimnp"
alias vimls="_vimls"


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
alias mergepdf="_mergepdf"
alias gitinit="_gitinit"


alias atooladd="atool --add"
alias atoolext="atool --extract"


alias xwacom="_xwacom"
alias xtouch="_xtouch"
alias xlayout="_xlayout"


alias autodual="autorandr --load dual"
alias automaster="autorandr --load master"
alias autoslave="autorandr --load slave"


alias logouti3="_logouti3"
alias rebooti3="_rebooti3"
alias poweroffi3="_poweroffi3"


alias stow="stow -S"
alias restow="stow -R"
alias unstow="stow -D"


alias ltree='tree -aC -I ".git" --dirsfirst | less -R -~'
alias xload="xrdb ~/.Xresources"
alias xbgrnd="$HOME/.fehbg"
alias xpipes="pipes -n 5 -i 0.025"
alias xcal="ncal -y"
