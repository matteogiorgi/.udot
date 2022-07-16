# A very minimal (but effective) GNU/Linux config

These repo contains a minimal configuration of my dotfiles, I keep them organized using [GNU Stow](https://www.gnu.org/software/stow/) and they are ment to be used alongside a vanilla install of [Ubuntu](https://ubuntu.com/#download). The scripts are in good order and well readable but there wont be no more than the bare essentials.


## Workflow utilities

<img align="right" width="160" src="ubuntu.png">


### window manager related

- stow            (symlink manager)
- i3-wm           (tiling window-manager)
- i3lock          (i3-wm lockscreen)
- dmenu           (suckless menu)
- arandr          (gui xrandr interface)
- autorandr       (automate randr layouts)


### shell and editor
- st              (suckless terminal)
- xterm           (x11 terminal)
- bash            (bourne again shell)
- tmux            (terminal multiplexer)
- vim             (vi improved - gtk3)
- sim             (sam-vi text editor)


### tui tools

- rover           (file manager)
- git             (version control)
- atool           (archive manager)
- trash-cli       (trash utility)
- htop            (process viewer)
- khal            (calendar)


### media related

- mpv             (media player)
- zathura         (document viewer)
- sxiv            (image viewer)


### usefull applets

- blueman         (bt applet)
- network-manager (nm applet)


### other stuff

- xclip           (x11 selections interface)
- ripgrep         (a better grep)
- wamerican       (/usr/share/dict english)
- witalian        (/usr/share/dict italian)
- xdo             (perform action on windows)
- feh             (image viewer)
- pandoc          (markup converter)
- texlive         (tex live metapackage)


### adwaita everywhere

- adwaita-icon-theme (gnome icon theme)
- gnome-themes-extra (adwaita theme engine)
- adwaita-qt         (adwaita qt5 port)


### and some more (optional) gear

- lxappearance    (gtk theme selector)
- qt5ct           (qt theme selector)
- chromium        (web-browser)
- codium          (text editor)
- pcmanfm         (file manager)
- lxterminal      (terminal emulator)
- xournalpp       (note taking)
- flameshot       (screenshot)
- xarchiver       (archive-manager)
- gparted         (partition editor)




## Remember to install the followings packages

`make`, `gcc`, `libx11-dev`, `libxinerama-dev`, `libxft-dev` and `libncurses-dev`, `xtermcontrol`




## and add the following conf

```
cat > /etc/X11/xorg.conf.d/10-synaptics.conf <<-EOF
Section "InputClass"
    Identifier "touchpad"
    Driver "synaptics"
    MatchIsTouchpad "on"
        Option "TapButton1" "1"
        Option "TapButton2" "3"
        Option "TapButton3" "2"
        Option "VertEdgeScroll" "off"
        Option "VertTwoFingerScroll" "on"
        Option "HorizEdgeScroll" "off"
        Option "HorizTwoFingerScroll" "on"
        Option "CircularScrolling" "on"
        Option "CircScrollTrigger" "2"
        Option "EmulateTwoFingerMinZ" "40"
        Option "EmulateTwoFingerMinW" "8"
        Option "CoastingSpeed" "1"
EndSection
EOF
```




## GNOME palette

<img align="right" width="160" src="mona.gif">

I used the following palette throughout the all sysconfig.

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
