+++
title = "Name of the device"
description = "Slightly longer description"
# Be sure to include a relevant picture under /site/static/img/.
# Please use imagemagick to recompress the image with:
#   convert -strip -interlace Plane -gaussian-blur 0.05 -quality 85% -resize 256x256 source.jpg final.jpg
picture = "/img/picture.jpg"
# Remove this line before submitting a PR:
draft = true
+++


# Overview

[foo](https://periph.io/x/periph/devices/foo) provides support to interact with
bar.

Insert description of device bar.


# Configuration

Do not forget to connect wires. Keep the section only if relevant (most do not
need one).


# Learn more

- Link to an Amazing tutorial on Adafruit, if relevant.
- Link to Wikipedia on the subject to learn more about the physics behind, if
  relevant.


# Example

This example uses either a FT232H connected via SPI.

```go
package main

import (
	"fmt"
	"log"

	"periph.io/x/extra/hostextra/d2xx"
	"periph.io/x/periph/conn/physic"
	"periph.io/x/periph/conn/spi"
	"periph.io/x/periph/host"
)

func main() {
	if _, err := host.Init(); err != nil {
		log.Fatal(err)
	}

	all := d2xx.All()
	if len(all) == 0 {
		log.Fatal("found no FTDI device on the USB bus")
	}

	//Just use channel A
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
