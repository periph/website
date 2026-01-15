+++
title = "macOS"
description = "hack on your laptop"
weight = 2
picture = "/img/apple.jpg"
+++

# Overview

`periph` is continuously tested on macOS.

A good starter device is the [FTDI](/device/ftdi/) ones.


# cgo

Some drivers in [periph.io/x/host/v3](https://periph.io/x/host/v3) requires
`cgo`:

1. Install [Homebrew](https://brew.sh)
   - See below how to install it without root privilege.
1. Follow instructions, it may ask to run `xcode-select -install`
1. Install pkg-config with: `brew install pkg-config`


## Homebrew installed as user

Optionally install homebrew without root with the following steps:

    mkdir -p ~/homebrew
    curl -sL https://github.com/Homebrew/brew/tarball/3.1.9 | tar xz --strip 1 -C ~/homebrew
    export PATH="$PATH:$HOME/homebrew/bin"
    echo 'export PATH="$PATH:$HOME/homebrew/bin"' >> ~/.bash_profile
    brew upgrade
