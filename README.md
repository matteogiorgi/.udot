# .UDOT IS NO LONGER MANTEINED

This repo is obsolite and no longer in use: I have decided to switch to a full fledged desktop environment like [Gnome](https://www.gnome.org/) that support both Xorg and Wayland and coupled it with a more minimal version of this repo like [.minidot](https://github.com/matteogiorgi/.minidot).




# A very effective GNU/Linux config

This repo contains a minimal configuration of my *dotfiles*, I keep them organized using [GNU Stow](https://www.gnu.org/software/stow/) and they are meant to be used alongside a vanilla install of [Ubuntu](https://ubuntu.com/#download). The scripts are in good order and well readable but there wont be no more than the bare essentials.

![](./wallpaper)




## Essential utilities

```
wmctrl xdotool autorandr lxpolkit poppler-utils git curl wget stow htop xclip
trash-cli fzf ripgrep bat chafa feh xdo fonts-firacode wamerican witalian
gnome-keyring coreutils xdg-utils fbset pandoc
```




## Main packages

```
i3-wm arandr xterm dash bash bash-completion tmux vim-gtk3 blueman network-manager
system-config-printer pavucontrol diodon flameshot lxappearance qt5ct xournalpp
adwaita-icon-theme-full gnome-themes-extra adwaita-qt
```




## Tweaks

- Bookmarks: [`Startpage Notewiki Drive Mega Gmail Proton Outlook Discord Telegram`](bookmarks.html).
- Chrome extensions: [`uBlock`](https://chrome.google.com/webstore/detail/ublock-origin/cjpalhdlnbpafiamejdnhcphjbkeiagm?hl=en-US), [`Vimium`](https://chrome.google.com/webstore/detail/vimium/dbepggeogbaibhgnhhndojpepiihcmeb?hl=en-US), [`Player`](https://chrome.google.com/webstore/detail/mediaplayer-video-and-aud/mgmhnaapafpejpkhdhijgkljhpcpecpj?hl=en-US), [`DeepL`](https://chrome.google.com/webstore/detail/deepl-translate-reading-w/cofdbpoegempjloogbagkncekinflcnj), [`Onion`](https://chrome.google.com/webstore/detail/onion-browser-button/fockhhgebmfjljjmjhbdgibcmofjbpca?hl=en-US), [`Veepn`](https://chrome.google.com/webstore/detail/free-vpn-for-chrome-vpn-p/majdfhpaihoncoakbjgbdhglocklcgno/related?hl=en-US), [`Gnome`](https://chrome.google.com/webstore/detail/gnome-shell-integration/gphhapmejobijbbhgpjhcjognlahblep/related), [`123Apps`](https://chrome.google.com/webstore/detail/web-apps-by-123apps/dpplndkoilcedkdjicmbeoahnckdcnle).
- Gmore: `input-remapper`, `dconf-editor`, `gnome-shell-extension-prefs`, `chrome-gnome-shell`.




## Vim 9 (Ubuntu PPA)

- Add unofficial [Vim PPA repo](https://launchpad.net/~jonathonf/+archive/ubuntu/vim?ref=itsfoss.com).
- Upgrade `vim-gtk3` package.

```bash
sudo add-apt-repository ppa:jonathonf/vim
sudo apt update && sudo apt install vim-gtk3
```




## Need more?

- To seek info on any *Ubuntu* package, check [packages.ubuntu.com](https://packages.ubuntu.com/).
- To read *Ubuntu* manpages, check [manpages.ubuntu.com](https://manpages.ubuntu.com/).
- As a minimal-lifestile alternative, check out [.minidot](https://github.com/matteogiorgi/.minidot).
