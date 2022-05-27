# A very minimal (but effective) GNU/Linux config

These repo contains a minimal configuration of my dotfiles, I keep them organized using [GNU Stow](https://www.gnu.org/software/stow/) and they are ment to be used alongside a vanilla install of [Ubuntu](https://ubuntu.com/#download). The scripts are in good order and well readable but there wont be no more than the bare essentials.




<img align="left" width="160" src="ubuntu.png">
<img align="right" width="160" src="mona.gif">


## Workflow utilities


### window manager related

- stow           (symlink manager)
- i3-wm          (tiling window-manager)
- i3lock         (i3-wm lockscreen)
- dmenu          (suckless menu)
- arandr         (gui xrandr interface)
- autorandr      (automate randr layouts)


### shell and editor
- st             (suckless terminal)
- xterm          (x11 terminal)
- bash           (bourne again shell)
- tmux           (terminal multiplexer)
- vim            (vi improved - gtk3)


### tui tools

- git            (version control)
- atool          (archive manager)
- trash-cli      (trash utility)
- htop           (process viewer)
- calcurse       (tui organizer)


### media related

- mpv            (media player)
- zathura        (document viewer)
- sxiv           (image viewer)


### usefull applet

- blueman        (bt applet)
- networkmanager (nm applet)


### other tools

- xclip          (x11 selections interface)
- ripgrep        (a better grep)
- wamerican      (/usr/share/dict collection)
- xdo            (perform action on windows)
- feh            (image viewer)


### and some more

- chromium       (web-browser)
- vscode         (another web-browser I guess)
- xournalpp      (note-taking app)
- flameshot      (screenshot app)




## Remember to install the followings packages

`make`, `gcc`, `libx11-dev`, `libxinerama-dev` and `libxft-dev`




## Xterm palette

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
