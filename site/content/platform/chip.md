+++
title = "C.H.I.P."
description = "NextThing Co's board"
picture = "/img/chip.jpg"
+++

# Overview

The NextThing Co's C.H.I.P. uses an Allwinner R8 or G8 processor. The following
functionality is supported:

- 3x I²C buses
- 1x SPI bus with 1x chip-enable
- 2x high performance edge detection enabled memory-mapped GPIO pins
- 41x high performance memory-mapped GPIO pins (the "LCD" and "CSI" pins and a
  few more)
- 8x low performance GPIO pins via pcf8574 I²C I/O extender ("XIO" pins)


# Support

The NextThing Co's C.H.I.P. board is supported using sysfs drivers as well as
using high performance memory-mapped I/O for gpio pins.

- `periph` is tested with [NTC provided 4.4.13+ kernel
  Debian](https://docs.getchip.com/chip.html#flash-chip-firmware) which can be
  done via their [Web UI flashing tool](https://flash.getchip.com/). It should
  work with any flavor, [file a bug](https://github.com/google/periph/issues)
  otherwise.
- C.H.I.P. is fully supported
- C.H.I.P. Pro and PocketCHIP specific pinouts will be supported very soon
  (hardware is already acquired)


## Drivers

- CPU driver lives in
  [periph.io/x/periph/host/allwinner](https://periph.io/x/periph/host/allwinner).
- Headers driver lives in
  [periph.io/x/periph/host/chip](https://periph.io/x/periph/host/chip). It
  defines both `U13` and `U14` with the aliases as printed on the actual
  headers.
- sysfs driver lives in
  [periph.io/x/periph/host/sysfs](https://periph.io/x/periph/host/sysfs).


# Configuration

CHIP is described at NextThing's [product
page](https://www.getchip.com/pages/chip) and in much more detail in the [CHIP
Hardware](http://docs.getchip.com/chip.html#chip-hardware) section of the
documentation.

For in-depth information about the hardware the best reference is in the
[community wiki](http://www.chip-community.org/index.php/Hardware_Information),
which also has a section on [building kernels and device
drivers](http://www.chip-community.org/index.php/Kernel_Hacking).


## GPIO

Most GPIO are supported at extremely high speed via memory mapped GPIO
registers.

Interrupt based GPIO edge detection is only supported on a few of the
processor's pins: AP-EINT1(PG1), AP-EINT3(PB3), CSIPCK(PE0), and CSICK(PE1).

Edge detection is also supported on the XIO pins, but this feature is
rather limited due to the device and the driver (for example, the driver
interrupts on all edges).


## I²C

The recent images released by NTC have the I²C driver loaded by default and
exposes all three I²C buses but only 2 are usable. If running a stale image,
update with `sudo apt update && sudo apt upgrade`

- I²C #0: not available on the headers but has axp209 power control chip
- I²C #2: U13 pins 9 & 11
- I²C #2: U14 pins 25 & 26, has pcf8574 I/O extender


## SPI

The SPI driver is included on recent images but a DTBO (Device Tree Binary
Overlay) is required in order to create the `/dev/spi32766.0` device and connect
it to the pins.

- SPI2.0 or SPI32766.0: U14 pins 27, 28, 29, 30; only a single
  chip-select is supported

To enable, run the following:
```
mkdir -p /sys/kernel/config/device-tree/overlays/spi
cat /lib/firmware/nextthingco/chip/sample-spi.dtbo > /sys/kernel/config/device-tree/overlays/spi/dtbo
```

This needs to be done at each boot. A good location is to add the above into
`/etc/rc.local` before the `exit 0` statement.


# Buying

- The C.H.I.P. is directly distributed by [NextThing Co](https://getchip.com/).

_The periph authors do not endorse any specific seller. These are only provided
for your convenience._
