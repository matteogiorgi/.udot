# slock - simple screen locker

slock is a simple screen locker utility for X. This one has no patches applied bu default, but a full list of patches can be found at [tools.suckless.org/slock/patches](https://tools.suckless.org/slock/patches).


## Requirements

In order to build slock you need the Xlib header files.


## Installation

First clone this repo:

```
git clone https://github.com/matteogiorgi/.udot.git
```

Then edit config.mk to match your local setup (dmenu is installed into the `/usr/local` namespace by default). Afterwards enter the following command to build and install dmenu (if necessary as root):

```
cd slock
make clean install
```


## Running slock

Simply invoke the `slock` command. To get out of it, enter your password.
