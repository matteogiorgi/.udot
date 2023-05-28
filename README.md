# A very effective GNU/Linux config

This repo contains a minimal configuration of my *dotfiles*, I keep them organized using [GNU Stow](https://www.gnu.org/software/stow/) and they are meant to be used alongside a vanilla install of [Ubuntu](https://ubuntu.com/#download). The scripts are in good order and well readable but there wont be no more than the bare essentials.




## Main color-palette

<img align="right" width="350" src="media/glenda.png">

| Color   | Normal    | Bright    |
| ------- | --------- | --------- |
| Black   | `#171421` | `#5E5C64` |
| Red     | `#C01C28` | `#F66151` |
| Green   | `#26A269` | `#33D17A` |
| Yellow  | `#A2734C` | `#E9AD0C` |
| Blue    | `#12488B` | `#2A7BDE` |
| Magenta | `#A347BA` | `#C061CB` |
| Cyan    | `#2AA1B3` | `#33C7DE` |
| White   | `#D0CFCC` | `#FFFFFF` |




## Essential utilities

```
coreutils xdg-utils xdotool w3m-img fbset wmctrl xtermcontrol curl wget stow
autorandr git atool trash-cli htop tree make gcc pkg-config lxpolkit xclip
ripgrep wamerican witalian mesa-utils xdo feh ffmpeg poppler-utils mediainfo
texlive-full pandoc fonts-firacode ufw vsftpd bat zenity snap flatpak
libnotify-bin chafa fzf ffmpegthumbnailer
```




## Main packages

```
i3-wm xautolock arandr kitty xterm tmux vim kak helix sxiv bash bash-completion
zathura zathura-djvu zathura-pdf-poppler zathura-ps mpv blueman network-manager
adwaita-icon-theme-full gnome-themes-extra adwaita-qt lxappearance qt5ct xournalpp
flameshot diodon pavucontrol gparted filezilla chrome-gnome-shell input-remapper
cups system-config-printer gnome-shell-extension-prefs code codium google-chrome
brave chromium simplescreenrecorder transmission vlc mypaint slides cherrytree
```




## Additional language support

- C/C++: `build-essential valgrind gdb`
- Java: `default-jdk default-jdk-doc ant maven gradle`
- Ocaml: `ocaml-batteries-included ocaml-man opam opam-doc`
- Golang: `golang-go golang-golang-x-tools`
- Python: `python3 python3-pip`
- Javascript: `nodejs`




## Need more?

- Bookmarks: [`Startpage Notewiki Drive Mega Gmail Proton Outlook Discord Telegram`](https://raw.githubusercontent.com/matteogiorgi/.udot/master/bookmarks.html)
- Chrome extensions: [`uBlock`](https://chrome.google.com/webstore/detail/ublock-origin/cjpalhdlnbpafiamejdnhcphjbkeiagm?hl=en-US), [`Vimium`](https://chrome.google.com/webstore/detail/vimium/dbepggeogbaibhgnhhndojpepiihcmeb?hl=en-US), [`Player`](https://chrome.google.com/webstore/detail/mediaplayer-video-and-aud/mgmhnaapafpejpkhdhijgkljhpcpecpj?hl=en-US), [`DeepL`](https://chrome.google.com/webstore/detail/deepl-translate-reading-w/cofdbpoegempjloogbagkncekinflcnj), [`Onion`](https://chrome.google.com/webstore/detail/onion-browser-button/fockhhgebmfjljjmjhbdgibcmofjbpca?hl=en-US), [`Veepn`](https://chrome.google.com/webstore/detail/free-vpn-for-chrome-vpn-p/majdfhpaihoncoakbjgbdhglocklcgno/related?hl=en-US), [`Gnome`](https://chrome.google.com/webstore/detail/gnome-shell-integration/gphhapmejobijbbhgpjhcjognlahblep/related), [`123Apps`](https://chrome.google.com/webstore/detail/web-apps-by-123apps/dpplndkoilcedkdjicmbeoahnckdcnle)
- Haskell support: `curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh`
- Rust support: `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`




## Documentation

<img align="right" width="50" src="media/ubuntu.png">

- For any other package, check [packages.ubuntu.com](https://packages.ubuntu.com/)
- To read *Ubuntu manpages*, check [manpages.ubuntu.com](https://manpages.ubuntu.com/)
