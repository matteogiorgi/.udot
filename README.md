# A very effective GNU/Linux config

This repo contains a minimal configuration of my dotfiles, I keep them organized using [GNU Stow](https://www.gnu.org/software/stow/) and they are ment to be used alongside a vanilla install of [Ubuntu](https://ubuntu.com/#download). The scripts are in good order and well readable but there wont be no more than the bare essentials.




## Main color-palette

<img align="right" width="350" src="media/glenda.png">

| Color   | Normal                                                                 | Bright                                                                 |
| ------- | ---------------------------------------------------------------------- | ---------------------------------------------------------------------- |
| Black   | <span style="background-color:#171421; color:#FFFFFF">`#171421`</span> | <span style="background-color:#5E5C64; color:#FFFFFF">`#5E5C64`</span> |
| Red     | <span style="background-color:#C01C28; color:#FFFFFF">`#C01C28`</span> | <span style="background-color:#F66151; color:#000000">`#F66151`</span> |
| Green   | <span style="background-color:#26A269; color:#FFFFFF">`#26A269`</span> | <span style="background-color:#33D17A; color:#000000">`#33D17A`</span> |
| Yellow  | <span style="background-color:#A2734C; color:#FFFFFF">`#A2734C`</span> | <span style="background-color:#E9AD0C; color:#000000">`#E9AD0C`</span> |
| Blue    | <span style="background-color:#12488B; color:#FFFFFF">`#12488B`</span> | <span style="background-color:#2A7BDE; color:#000000">`#2A7BDE`</span> |
| Magenta | <span style="background-color:#A347BA; color:#FFFFFF">`#A347BA`</span> | <span style="background-color:#C061CB; color:#000000">`#C061CB`</span> |
| Cyan    | <span style="background-color:#2AA1B3; color:#FFFFFF">`#2AA1B3`</span> | <span style="background-color:#33C7DE; color:#000000">`#33C7DE`</span> |
| White   | <span style="background-color:#D0CFCC; color:#000000">`#D0CFCC`</span> | <span style="background-color:#FFFFFF; color:#000000">`#FFFFFF`</span> |




## Essential utilities

```
wmctrl xtermcontrol curl wget stow autorandr git atool trash-cli htop ncal
tree make jq gcc pkg-config lxpolkit libx11-dev libxinerama-dev libxft-dev
libncurses-dev libxrandr-dev libxtst-dev libxi-dev xclip fzf ripgrep wamerican
witalian source-highlight mesa-utils xdo feh ffmpeg poppler-utils mediainfo
brightnessctl texlive-full pandoc fonts-ubuntu fonts-jetbrains-mono xdotool
poppler-utils exuberant-ctags nodejs
```




## Main packages

```
i3-wm xautolock arandr xterm rxvt-unicode kitty tmux kakoune vim-gtk3 neovim
nano tig zathura zathura-djvu zathura-pdf-poppler zathura-ps mpv sxiv blueman
network-manager humanity-icon-theme adwaita-icon-theme-full gnome-themes-extra
adwaita-qt lxappearance qt5ct xournalpp sct flameshot diodon pavucontrol
gparted pcmanfm xarchiver vlc simplescreenrecorder
```




## Snap/extra packages

```
code codium brave google-chrome chromium ferdium
```


### Chrome extensions

- [uBlock Origins](https://chrome.google.com/webstore/detail/ublock-origin/cjpalhdlnbpafiamejdnhcphjbkeiagm?hl=en-US): ad blocker
- [Vimium](https://chrome.google.com/webstore/detail/vimium/dbepggeogbaibhgnhhndojpepiihcmeb?hl=en-US): Vim emulation
- [123Apps](https://chrome.google.com/webstore/detail/web-apps-by-123apps/dpplndkoilcedkdjicmbeoahnckdcnle?hl=en-US): productivity apps
- [MediaPlayer](https://chrome.google.com/webstore/detail/mediaplayer-video-and-aud/mgmhnaapafpejpkhdhijgkljhpcpecpj?hl=en-US): video and audio player




## Language support

- Javascript: `nodejs` (required for coc.nvim)
- C/C++: `build-essential valgrind gdb`
- Java: `default-jdk default-jdk-doc ant maven gradle`
- Ocaml: `ocaml-batteries-included ocaml-man opam opam-doc`
- Golang: `golang-go golang-golang-x-tools`
- Python: `python3 python3-pip`




<img align="right" width="50" src="media/ubuntu.png">

#### For any other package check [packages.ubuntu.com](https://packages.ubuntu.com/)
