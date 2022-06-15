# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022


# If running bash:
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# Set PATH so it includes just user's '~/bin' if it exists:
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# Set PATH so it includes just user's '~/.local/bin' if it exists:
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# Haskell exports
export GHCUP_BIN="$HOME/.ghcup/bin"
export CABAL_BIN="$HOME/.cabal/bin"

# Other exports
export EMACS_BIN="$HOME/.emacs.d/bin"
export CARGO_BIN="$HOME/.cargo/bin"
export GOPATH_BIN="$HOME/go/bin"

# set PATH to includes user's bin, go's bin, cargo's bin and emacs's bin recursively
export PATH="$PATH:$( find $HOME/bin/ -maxdepth 2 -type d -not -path "/.git/*" -printf ":%p" ):$HOME/.local/bin:$GHCUP_BIN:$CABAL_BIN:$EMACS_BIN:$CARGO_BIN:$GOPATH_BIN"
