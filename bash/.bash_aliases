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
alias vim-cocmode="_vim_cocmode"
alias vim-noplugin="_vim_noplugin"
alias vim-vanilla="_vim_vanilla"
alias vim-last="_vim_last"


alias nvim="_nvim"
alias nvim-cocmode="_nvim_cocmode"
alias nvim-noplugin="_nvim_noplugin"
alias nvim-vanilla="_nvim_vanilla"
alias nvim-last="_nvim_last"


alias bashfun="_bashfun"
alias autorandr-mode="_autorandr_mode"
alias kitty-theme="_kitty_theme"
alias tmux="_tmux"
alias xhide="_xhide"
alias xshow="_xshow"
alias shfm="_shfm"
alias nnn="_nnn"
alias fjump="_fjump"
alias fgit="_fgit"
alias tig="_tig"
alias sxiv="_sxiv"
alias chbg="_chbg"
alias ipreview="_ipreview"
alias xopp2pdf="_xopp2pdf"
alias mergepdf="_mergepdf"
alias gitinit="_gitinit"


alias atool-add="atool --add"
alias atool-ext="atool --extract"


alias xwacom="_xwacom"
alias xtouch="_xtouch"
alias xlayout="_xlayout"


alias logout-i3="_logouti3"
alias reboot-i3="_rebooti3"
alias poweroff-i3="_poweroffi3"


alias stow="stow -S"
alias restow="stow -R"
alias unstow="stow -D"


alias ltree='tree -aC -I ".git" --dirsfirst | less -R -~'
alias xload="xrdb ~/.Xresources"
alias xbgrnd="$HOME/.fehbg"
alias xpipes="pipes -n 5 -i 0.025"
alias xcal="ncal -y"
