# dmenu - suckless dynamic menu

dmenu is an efficient dynamic menu for X. This fork has the following patches applied by default, check [tools.suckless.org/dmenu](https://tools.suckless.org/dmenu/) for more info.

- [highlight](https://tools.suckless.org/dmenu/patches/highlight/)
- [line height](https://tools.suckless.org/dmenu/patches/line-height/)
- [numbers](https://tools.suckless.org/dmenu/patches/numbers/)


## Requirements

In order to build dmenu you need the Xlib header files plus, install [*Ubuntu Mono Font*](https://design.ubuntu.com/font) with `apt install fonts-ubuntu` since it is set as default.


## Installation

First clone this repo:

```
git clone https://github.com/matteogiorgi/.udot.git
```

Then edit config.mk to match your local setup (dmenu is installed into the `/usr/local` namespace by default). Afterwards enter the following command to build and install dmenu (if necessary as root):

```
cd dmenu
make clean install
```


## Running dmenu

Simply invoke the `dmenu_run` command.
