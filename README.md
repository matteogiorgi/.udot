# A very minimal (but effective) GNU/Linux config

These repo contains a minimal configuration of my dotfiles, I keep them organized using [GNU Stow](https://www.gnu.org/software/stow/) and they are ment to be used alongside a vanilla install of [Ubuntu](https://ubuntu.com/#download). The scripts are in good order and well readable but there wont be no more than the bare essentials.




## Main color-palette

<img align="right" width="160" src="mona.gif">

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




## Workflow utilities

### window manager related

- i3-wm           (tiling window-manager)
- i3lock          (i3-wm lockscreen)
- dmenu           (suckless menu)
- arandr          (gui xrandr interface)


### shell and editor stuff
- st              (suckless terminal)
- xterm           (x11 terminal)
- bash            (bourne again shell)
- tmux            (terminal multiplexer)
- vim             (vi improved - gtk3)
- kakoune         (a better vi)


### media related

- mpv             (media player)
- zathura         (document viewer)
- sxiv            (image viewer)


### usefull applets

- blueman         (bt applet)
- network-manager (nm applet)


### adwaita, adwaita everywhere

- adwaita-icon-theme (gnome icon theme)
- gnome-themes-extra (adwaita theme engine)
- adwaita-qt         (adwaita qt5 port)


### more (gui) gear

- lxappearance         (gtk theme selector)
- qt5ct                (qt theme selector)
- chromium             (web-browser)
- codium               (text editor)
- pcmanfm              (file manager)
- terminator           (terminal emulator)
- xournalpp            (note taking)
- flameshot            (screenshot)
- xarchiver            (archive-manager)
- simplescreenrecorder (monitor recorder)
- gparted              (partition editor)
- transmission         (torrent client)
- vlc                  (media player)




## Do not forget to install the followings packages

`xtermcontrol`, `curl`, `wget`, `stow`, `autorandr`, `git`, `atool`, `trash`, `htop`, `khal`, `make`, `gcc`, `libx11-dev`, `libxinerama-dev`, `libxft-dev`, `libncurses-dev`, `xclip`, `ripgrep`, `wamerican`, `witalian`, `xdo`, `feh`, `pandoc`, `texlive`




## and to add some language support

- C/C++: `apt install build-essential`
- Go: `apt install golang-go golang-golang-x-tools`
- Rust: `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`
- Haskell: `curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh`
- Ocaml: `apt install ocaml-batteries-included ocaml-man opam opam-doc`
- Java: `apt install openjdk-18-jdk openjdk-18-doc openjdk-18-source ant maven gradle`
- Python: `apt install python3 python3-pip`




<img align="right" width="50" src="ubuntu.png">

#### For any other package check [packages.ubuntu.com](https://packages.ubuntu.com/)
