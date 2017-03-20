+++
title = "Supported platforms"
description = "Overview of officially supported platforms"
+++

# Overview

`periph` is designed to compile on any OSes and CPU architecture but provides
value only on a few supported OSes.


# OSes

Only Linux distributions are currently supported for hardware access. The
library is compilable on OSX and Windows but doesn't yet provide facilities.


## Linux

More often than not on Debian based distros, you may have to run the executable
as root to be able to access the LEDs, GPIOs and other functionality.

It is possible to change the ACL on the _sysfs files_ via _udev_ rules to enable
running without root level. The actual rules are distro specific. That said,
using memory mapped GPIO registers usually require root anyway.


# Boards

- [BeagleBone](beaglebone/)
- [NextThing's C.H.I.P.](chip/)
- [Hardkernel's ODROID-C1](odroid-c1/)
- Pine 64
- [Raspberry Pi](raspberrypi/)
