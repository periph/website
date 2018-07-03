+++
title = "Motion detector"
description = "Detect motion without polling"
picture = "/img/hc-sr501.jpg"
+++

# Overview

[GPIO pins](/device/gpio/) can be leveraged to detect motion via a PIR
(Passive/Pyroelectric InfraRed sensor), similar to reading
[button presses](/device/button/).

The [gpio.PinIn.WaitForEdge()](https://periph.io/x/periph/conn/gpio#PinIn)
function permits a edge detection without a busy loop.


# Learn more

- [PIR tutorial on
  Adafruit](https://learn.adafruit.com/pir-passive-infrared-proximity-motion-sensor/)
  that explains the physics behind the sensor
- [PIR on Wikipedia](https://en.wikipedia.org/wiki/Passive_infrared_sensor)


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


# Buying

- Adafruit: [adafruit.com/?q=motion%20pir](https://www.adafruit.com/?q=motion%20pir)
- Aliexpress:
  [aliexpress.com/wholesale?SearchText=hc-sr501](https://aliexpress.com/wholesale?SearchText=hc-sr501)
- Amazon:
  [amazon.com/s?field-keywords=hc-sr501](https://amazon.com/s?field-keywords=hc-sr501)
- Pimoroni:
  [shop.pimoroni.com/?q=motion%20pir](https://shop.pimoroni.com/?q=motion%20pir)
- SeeedStudio:
  [seeedstudio.com/s/pir%20motion.html](https://seeedstudio.com/s/pir%20motion.html)

_The periph authors do not endorse any specific seller. These are only provided
for your convenience._
