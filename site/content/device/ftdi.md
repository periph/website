+++
title = "FTDI FT232x"
description = "Fast USB multi-protocol connectivity"
#   convert -strip -interlace Plane -gaussian-blur 0.05 -quality 85% -resize 256x256 source.jpg final.jpg
picture = "/img/ftdi.jpg"
+++


# Overview

Package [d2xx](https://periph.io/x/extra/hostextra/d2xx) provides support for
FT232H/FT232R devices via the [Future Technology "D2XX" driver](
https://ftdichip.com/drivers/d2xx-drivers/).

The driver implements:

- GPIO
- I²C
- SPI


## Installation


### Debian

This includes Raspbian and Ubuntu.

1. Configure cgo as explained at [/platform/linux/#cgo](/platform/linux/#cgo).


#### Temporary

Run this command **after** connecting your FTDI device:

```
sudo rmmod ftdi_sio usbserial
```


#### Permanent

Run these commands **before** connecting your FTDI device:

```
cd $GOPATH/src/periph.io/x/extra/hostextra/d2xx
sudo cp debian/98-ft232h.rules /etc/udev/rules.d/
sudo udevadm control --reload-rules
sudo udevadm trigger --verbose
```


### macOS

1. Configure cgo as explained at [/platform/macos/#cgo](/platform/macos/#cgo).
1. Unload the
   [AppleUSBFTDI](https://developer.apple.com/library/content/technotes/tn2315/_index.html)
   kernel driver with one of the two following ways:


#### Temporary

This temporarily unload Apple's FTDI driver. This needs to be done after each
OS startup:

```
sudo kextunload -b com.apple.driver.AppleUSBFTDI
```


#### Permanently

This permanently disable Apple's FTDI driver.

1. Download
   [D2xxHelper](https://www.ftdichip.com/Drivers/D2XX/MacOSX/D2xxHelper_v2.0.0.pkg).
   - It is available at
     [ftdichip.com/drivers/d2xx-drivers/](https://ftdichip.com/drivers/d2xx-drivers/).
1. Run `D2xxHelper_xxx.pkg` you just downloaded.
1. Reboot.


### Windows

1. Connect the device.
1. Windows Update should install the FTDI D2XX driver automatically. Wait for it
   to occur.
   - If this fails, install the driver from
     [ftdichip.com/drivers/d2xx-drivers/](https://ftdichip.com/drivers/d2xx-drivers/).


# Example

Use SPI on a FT232H.

```go
package main

import (
    "fmt"
    "log"

    "periph.io/x/extra/hostextra/d2xx"
    "periph.io/x/conn/v3/physic"
    "periph.io/x/conn/v3/spi"
    "periph.io/x/host/v3"
)

func main() {
    if _, err := host.Init(); err != nil {
        log.Fatal(err)
    }

    all := d2xx.All()
    if len(all) == 0 {
        log.Fatal("found no FTDI device on the USB bus")
    }

    // Use channel A.
    ft232h, ok := all[0].(*d2xx.FT232H)
    if !ok {
        log.Fatal("not FTDI device on the USB bus")
    }

    s, err := ft232h.SPI()
    if err != nil {
        log.Fatal(err)
    }

    c, err := s.Connect(physic.KiloHertz*100, spi.Mode3, 8)
    write := []byte{0x10, 0x00}
    read := make([]byte, len(write))
    if err := c.Tx(write, read); err != nil {
        log.Fatal(err)
    }
    // Use read.
    fmt.Printf("%v\n", read[1:])
}
```


# Buying

These links are for the FT232H, which is higher speed than the FT232R for nearly
the same price:

- Adafruit: [adafruit.com/?q=ft232h](https://www.adafruit.com/?q=ft232h)
- Pimoroni: [shop.pimoroni.com/?q=ft232h](https://shop.pimoroni.com/?q=ft232h)

It is **not** recommended to buy chips on AliExpress or Amazon (except for the
adafruit branded boards). Most of these are cheap counterfeit that have
incomplete support. They are often sold under the brand "CJMCU".

_The periph authors do not endorse any specific seller. These are only provided
for your convenience._
