+++
title = "Button"
description = "React to button presses without polling"
picture = "/img/button.jpg"
+++

# Overview

[GPIO pins](/device/gpio/) can be leveraged to read button presses, similar to
[detecting motion](/device/pir/).

The [gpio.PinIn.WaitForEdge()](https://periph.io/x/conn/v3/gpio#PinIn)
function permits a edge detection without a busy loop.


# Example

```go
package main

import (
    "fmt"
    "log"

    "periph.io/x/conn/v3/gpio"
    "periph.io/x/conn/v3/gpio/gpioreg"
    "periph.io/x/host/v3"
)

func main() {
    // Load all the drivers:
    if _, err := host.Init(); err != nil {
        log.Fatal(err)
    }

    // Lookup a pin by its number:
    p := gpioreg.ByName("GPIO2")
    if p == nil {
        log.Fatal("Failed to find GPIO2")
    }

    fmt.Printf("%s: %s\n", p, p.Function())

    // Set it as input, with an internal pull down resistor:
    if err := p.In(gpio.PullDown, gpio.BothEdges); err != nil {
        log.Fatal(err)
    }

    // Wait for edges as detected by the hardware, and print the value read:
    for {
        p.WaitForEdge(-1)
        fmt.Printf("-> %s\n", p.Read())
    }
}
```

This example uses basically no CPU: the
[WaitForEdge()](https://periph.io/x/conn/v3/gpio#PinIn) leverages the edge
detection provided by the kernel, unlike other Go hardware libraries.


# Buying

Buttons come in various forms and prices, here's a selection:

- Adafruit:
  [adafruit.com/?q=tactile%20button](https://www.adafruit.com/?q=tactile%20button)
  or
  [adafruit.com/?q=arcade%20button](https://www.adafruit.com/?q=arcade%20button)
- Aliexpress:
  [aliexpress.com/wholesale?SearchText=tactile%20button](https://aliexpress.com/wholesale?SearchText=tactile%20button)
  or
  [aliexpress.com/wholesale?SearchText=arcade%20button](https://aliexpress.com/wholesale?SearchText=arcade%20button)
- Amazon:
  [amazon.com/s?field-keywords=tactile%20button](https://amazon.com/s?field-keywords=tactile%20button)
  or
  [amazon.com/s?field-keywords=arcade%20button](https://amazon.com/s?field-keywords=arcade%20button)
- Pimoroni:
  [shop.pimoroni.com/?q=tactile%20button](https://shop.pimoroni.com/?q=tactile%20button)
  or
  [shop.pimoroni.com/?q=arcade%20button](https://shop.pimoroni.com/?q=arcade%20button)
- SeeedStudio:
  [seeedstudio.com/s/button.html](https://seeedstudio.com/s/button.html)

_The periph authors do not endorse any specific seller. These are only provided
for your convenience._
