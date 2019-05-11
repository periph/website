+++
title = "LED"
description = "Toggle a LED is the first step"
picture = "/img/led.jpg"
+++

# Overview

Toggling a LED is the ultimate experience! 😄

This can be done via [GPIO pins](/device/gpio/).

## General note

It is recommended to use the GPIO as a sink: plug the long lead (positive side)
on the 3.3V rail, the short lead on a 220Ω resistor, which is itself connected
to the GPIO.

The reason is that most boards have an easier time to sink current than source
current.


# Learn more

- [LED on Wikipedia](https://en.wikipedia.org/wiki/Light-emitting_diode)


# Example

`periph` doesn't expose any _toggle_-like functionality on purpose, it is as
stateless as possible.

```go
package main

import (
    "log"
    "time"

    "periph.io/x/periph/conn/gpio"
    "periph.io/x/periph/host"
    "periph.io/x/periph/host/rpi"
)

func main() {
    // Load all the drivers:
    if _, err := host.Init(); err != nil {
        log.Fatal(err)
    }

    t := time.NewTicker(500 * time.Millisecond)
    for l := gpio.Low; ; l = !l {
        // Lookup a pin by its location on the board:
        if err := rpi.P1_33.Out(l); err != nil {
            log.Fatal(err)
        }
        <-t.C
    }
}
```

This example uses basically no CPU: the
[Out()](https://godoc.org/periph.io/x/periph/conn/gpio#PinOut) call above
doesn't call into the kernel, unlike other Go hardware libraries. Instead it
*directly* writes to the GPIO memory mapped register.


# Buying

LEDs are generally best bought in bulk (e.g. 200 LEDs in a bag).
