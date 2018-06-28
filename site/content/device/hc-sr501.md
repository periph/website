+++
title = "Motion detector"
description = "Detect motion without polling"
picture = "/img/hc-sr501.jpg"
+++

# Overview

[GPIO pins](/device/gpio/) can be leveraged to detect motion, similar to reading
[button presses](/device/button/).

The [gpio.PinIn.WaitForEdge()](https://periph.io/x/periph/conn/gpio#PinIn)
function permits a edge detection without a busy loop.


# Example

~~~go
package main

import (
    "fmt"
    "log"

    "periph.io/x/periph/conn/gpio"
    "periph.io/x/periph/conn/gpio/gpioreg"
    "periph.io/x/periph/host"
)

func main() {
    // Load all the drivers:
    if _, err := host.Init(); err != nil {
        log.Fatal(err)
    }

    // Lookup a pin by its number:
    p, err := gpioreg.ByName("16")
    if err != nil {
        log.Fatal(err)
    }
    fmt.Printf("%s: %s\n", p, p.Function())

    // Set it as input.
    if err = p.In(gpio.PullNoChange, gpio.RisingEdge); err != nil {
        log.Fatal(err)
    }

    // Wait for edges as detected by the hardware.
    for {
        p.WaitForEdge(-1)
        if p.Read() == gpio.High {
          fmt.Printf("You moved!\n")
        }
    }
}
~~~
