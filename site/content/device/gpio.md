+++
title = "GPIO"
description = "Generic digital input/output support"
+++

# Overview

GPIO pins can be leveraged to use as a on/off signal for both input and output.


# Examples

## Toggle a LED

_Purpose:_ Short example including full error checking.

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


## GPIO Edge detection

_Purpose:_ Signals when a button was pressed or a motion detector detected a
movement.

The [gpio.PinIn.Edge()](https://periph.io/x/periph/conn/gpio#PinIn) function
permits a edge detection without a busy loop. This is useful for **motion
detectors**, **buttons** and other kinds of inputs where a busy loop would burn
CPU for no reason.

~~~go
package main

import (
    "fmt"
    "log"

    "periph.io/x/periph/host"
    "periph.io/x/periph/conn/gpio"
    "periph.io/x/periph/conn/gpio/gpioreg"
)

func main() {
    // Load all the drivers:
    if _, err := host.Init(); err != nil {
        log.Fatal(err)
    }

    // Lookup a pin by its number:
    p, err := gpioreg.ByNumber(16)
    if err != nil {
        log.Fatal(err)
    }
    fmt.Printf("%s: %s\n", p, p.Function())

    // Set it as input, with an internal pull down resistor:
    if err = p.In(gpio.Down, gpio.BothEdges); err != nil {
        log.Fatal(err)
    }

    // Wait for edges as detected by the hardware, and print the value read:
    for {
        p.WaitForEdge()
        fmt.Printf("-> %s\n", p.Read())
    }
}
~~~
