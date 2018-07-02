+++
title = "Linux"
description = "Generic linux support for any board"
weight = 1
picture = "/img/linux.jpg"
+++

# Overview

Most boards use a [Debian](http://debian.org/) derivative as their official
linux based platform so the library is best tested on debian.

Because Go executables are statically linked by default, there should be no
problem to run a `periph` based executable on a
[buildroot](https://buildroot.org/).


## ACL

You may have to run the executable as root to be able to access the LEDs, GPIOs
and other functionality.

It is possible to change the ACL on the _sysfs files_ via _udev_ rules to enable
running without root level. The actual rules are distro specific. That said,
using memory mapped GPIO registers usually require root anyway.


# cgo

Some drivers in [periph.io/x/extra](https://periph.io/x/extra) requires `cgo`.


On Debian, including Raspbian and Ubuntu, you need to install pkg-config to
enable `cgo`, run:

    sudo apt install pkg-config
