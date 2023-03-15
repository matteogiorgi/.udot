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
wmctrl xtermcontrol curl wget stow autorandr git atool trash-cli htop tree make gcc
pkg-config lxpolkit xclip fzf ripgrep wamerican witalian mesa-utils xdo feh ffmpeg
poppler-utils mediainfo texlive-full pandoc fonts-ubuntu fonts-jetbrains-mono xdotool
exuberant-ctags nodejs ufw vsftpd bat dunst ncal sct snap flatpak libnotify-bin
```




## Main packages

```
i3-wm xautolock arandr kitty xterm tmux nvim vim-gtk3 kakoune nano sxiv nnn tig
zathura zathura-djvu zathura-pdf-poppler zathura-ps mpv blueman network-manager
adwaita-icon-theme-full gnome-themes-extra adwaita-qt lxappearance qt5ct xournalpp
flameshot diodon pavucontrol gparted chrome-gnome-shell zim input-remapper cups
system-config-printer gnome-shell-extension-prefs
```




## Extra packages

- Snap: `brave chromium code codium slides`
- Deb: `google-chrome`
- Source: `helix` 
- Cargo: `alacritty gitui`
- Pip: `Pillow`




## Chrome extensions - [Webstore](https://chrome.google.com/webstore/category/extensions)

- [uBlock Origins](https://chrome.google.com/webstore/detail/ublock-origin/cjpalhdlnbpafiamejdnhcphjbkeiagm?hl=en-US): ad blocker
- [Vimium](https://chrome.google.com/webstore/detail/vimium/dbepggeogbaibhgnhhndojpepiihcmeb?hl=en-US): Vim emulation
- [MediaPlayer](https://chrome.google.com/webstore/detail/mediaplayer-video-and-aud/mgmhnaapafpejpkhdhijgkljhpcpecpj?hl=en-US): video and audio player
- [Gnome Shell integration](https://chrome.google.com/webstore/detail/gnome-shell-integration/gphhapmejobijbbhgpjhcjognlahblep/related): Gnome extensions installer
- [123Apps](https://chrome.google.com/webstore/detail/web-apps-by-123apps/dpplndkoilcedkdjicmbeoahnckdcnle?hl=en-US): productivity apps
- [DeepL](https://chrome.google.com/webstore/detail/deepl-translate-reading-w/cofdbpoegempjloogbagkncekinflcnj): natural machine translation
- [ChatGPT for Google](https://chrome.google.com/webstore/detail/chatgpt-for-google/jgjaeacdkonaoafenlfkkkmbaopkbilf/related): AI assistant for Google searches
- [Keepa](https://chrome.google.com/webstore/detail/keepa-amazon-price-tracke/neebplgakaahbhdphmkckjjcegoiijjo?hl=en-US): Amazon price tracker
- [Onion](https://chrome.google.com/webstore/detail/onion-browser-button/fockhhgebmfjljjmjhbdgibcmofjbpca?hl=en-US): TOR proxy




## Gnome extensions - [Webstore](https://extensions.gnome.org/)

- [Unite](https://extensions.gnome.org/extension/1287/unite/): layout tweaks
- [User themes](https://extensions.gnome.org/extension/19/user-themes/): theme support
- [Caffeine](https://extensions.gnome.org/extension/517/caffeine/): disable auto-lock




## Language support

- Javascript (required for `coc.nvim`): `nodejs`
- Rust (required for `helix alacritty gitui`): `rustup`
- C/C++: `build-essential valgrind gdb`
- Java: `default-jdk default-jdk-doc ant maven gradle`
- Ocaml: `ocaml-batteries-included ocaml-man opam opam-doc`
- Golang: `golang-go golang-golang-x-tools`
- Python: `python3 python3-pip`




## Need more? (mostly Gnome gear)

- Base bookmarks: [`Startpage Notewiki Drive Mega Gmail Proton Outlook Discord Telegram`](https://raw.githubusercontent.com/matteogiorgi/.udot/master/bookmarks.html)
- Haskell support: `curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh`
- Apt packages: `sudo apt install gnome-software gnome-software-plugin-flatpak gnome-software-plugin-snap gnome-calendar geary gnome-contacts gnome-terminal gedit nautilus ghostwriter mypaint gromit-mpx evince file-roller transmission-gtk vlc libreoffice gnome-calculator simplescreenrecorder variety dconf-editor gitg filezilla`
- Flatpak packages: `flatpak install flathub net.sapples.LiveCaptions`




## Documentation

<img align="right" width="50" src="media/ubuntu.png">

- For any other package, check [packages.ubuntu.com](https://packages.ubuntu.com/)
- To read Ubuntu manpages, check [manpages.ubuntu.com](https://manpages.ubuntu.com/)
