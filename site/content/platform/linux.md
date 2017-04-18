+++
title = "Linux"
description = "Overview of linux support"
weight = 1
+++

# Overview

Most boards use a [Debian](http://debian.org/) derivative as their official
linux based platform so the library is best tested on debian.

Because Go executables are statically linked by default, there should be no
problem to run a `periph` based executable on a
[buildroot](https://buildroot.org/) system but this hasn't been tried yet.


## ACL

You may have to run the executable as root to be able to access the LEDs, GPIOs
and other functionality.

It is possible to change the ACL on the _sysfs files_ via _udev_ rules to enable
running without root level. The actual rules are distro specific. That said,
using memory mapped GPIO registers usually require root anyway.
