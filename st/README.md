# st - suckless terminal

st is a simple terminal emulator for X which sucks less. This fork has the following patches applied by default, check [st.suckless.org](https://st.suckless.org/) for more info.

- [scrollback](https://st.suckless.org/patches/scrollback/)
- [bold is not bright](https://st.suckless.org/patches/bold-is-not-bright/)
- [boxdraw](https://st.suckless.org/patches/boxdraw/)


## Requirements

In order to build dmenu you need the Xlib header files plus, install [*Ubuntu Mono Font*](https://design.ubuntu.com/font) with `apt install fonts-ubuntu` since it is set as default.


## Installation

First clone this repo:

```
git clone https://github.com/matteogiorgi/.udot.git
```

Then edit config.mk to match your local setup (st is installed into the `/usr/local` namespace by default). Afterwards enter the following command to build and install st (if necessary as root):

```
cd st
make clean install
```


## Running st

If you did not install st with make clean install, you must compile the st terminfo entry with the following command:

```
tic -sx st.info
```


### Credits

Based on Aurélien APTEL `aurelien.aptel@gmail.com` bt source code.
