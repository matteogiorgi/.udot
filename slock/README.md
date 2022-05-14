# slock - simple screen locker

slock is a simple screen locker utility for X. This fork has the following patches applied by default, check [tools.suckless.org/slock](https://tools.suckless.org/slock/) for more info.

- [blured or pixelated screenshot](https://tools.suckless.org/slock/patches/blur-pixelated-screen/)


## Requirements

In order to build slock you need the Xlib header files.


## Installation

First clone this repo:

```
git clone https://github.com/matteogiorgi/slock.git
```

Then edit config.mk to match your local setup (slock is installed into
the /usr/local namespace by default). Afterwards enter the following command to build and install slock (if necessary as root):

```
make clean install
```


## Running slock

Simply invoke the `slock` command. To get out of it, enter your password.
