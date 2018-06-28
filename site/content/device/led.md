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
the the GPIO.

The reason is that most boards have an easier time to sink current than source
current.


# Example

`periph` doesn't expose any _toggle_-like functionality on purpose, it is as
stateless as possible.

~~~go
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

    for l := gpio.Low; ; l = !l {
      // Lookup a pin by its location on the board:
      if err := rpi.P1_33.Out(l); err != nil {
        log.Fatal(err)
      }
      time.Sleep(500 * time.Millisecond)
    }
}
~~~
