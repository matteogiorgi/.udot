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
- calcurse        (calendar/organizer)


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
- wamerican       (/usr/share/dict collection)
- xdo             (perform action on windows)
- feh             (image viewer)
- pandoc          (markup converter)
- texlive         (tex live metapackage)
- fonts-ubuntu    (pretty decent font family)


### some more

- gparted         (partition editor)
- chromium        (web-browser)
- vscode          (another web-browser I guess)
- xournalpp       (note-taking app)
- flameshot       (screenshot app)


### and some less useful gear

- lxappearance            (gtk theme selector)
- qt5ct                   (qt5 theme selector)
- adwaita-icon-theme-full (gnome icon theme)
- adwaita-qt              (adwaita qt5 port)
- gnome-themes-extra      (adwaita theme engine)
- gnome-themes-extra-data (adwaita theme common files)




## Remember to install the followings packages

`make`, `gcc`, `libx11-dev`, `libxinerama-dev`, `libxft-dev` and `libncurses-dev`




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




## Xterm palette

<img align="right" width="160" src="mona.gif">

I used the following palette throughout the all sysconfig.

| Color   | Dark      | Light     |
| ------- | --------- | --------- |
| Black   | `#000000` | `#7F7F7F` |
| Red     | `#CD0000` | `#FF0000` |
| Green   | `#00CD00` | `#00FF00` |
| Yellow  | `#CDCD00` | `#FFFF00` |
| Blue    | `#0000EE` | `#5C5CFF` |
| Magenta | `#CD00CD` | `#FF00FF` |
| Cyan    | `#00CDCD` | `#00FFFF` |
| White   | `#E5E5E5` | `#FFFFFF` |
