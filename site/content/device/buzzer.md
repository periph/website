+++
title = "Buzzer"
description = "Annoy your friends with noise"
picture = "/img/buzzer.jpg"
+++

# Overview

A buzzer is simple device that emits noise when activated.

This can be done via [GPIO pins](/device/gpio/).


## Active vs Passive

There is two kinds of buzzer: passive and active:

- A passive buzzer needs to be driven by a PWM signal. By changing the PWM
  frequency, you can change the tone.
- An active buzzer generates the sound at a predefined frequency, so the tone
  cannot be adjusted.


## Current

Buzzers draw can vary a lot, it can be as low as 2mA to as high as 30mA, which
is too much for a GPIO.

If you got a low power one, it is recommended to use the GPIO as a sink: plug
the positive side on the 3.3V rail, the negative one to the GPIO. For high power
buzzer, use a transitor or other type of current amplifier to not burn your
board.


# Example

This example is for an active buzzer.

**Note:** The PWM support is still iffy at best on the Raspberry Pi, and this
must be run as root.

~~~go
package main

import (
  "log"
  "time"

  "periph.io/x/periph/conn/gpio"
  "periph.io/x/periph/conn/gpio/gpioreg"
  "periph.io/x/periph/conn/physic"
  "periph.io/x/periph/host"
)

func main() {
  // Load all the drivers:
  if _, err := host.Init(); err != nil {
    log.Fatal(err)
  }

  p := gpioreg.ByName("PWM1_OUT")
  if p == nil {
    log.Fatal("Failed to find PWM1_OUT")
  }
  if err := p.PWM(gpio.DutyHalf, 440*physic.Hertz); err != nil {
    log.Fatal(err)
  }
  time.Sleep(2 * time.Second)
  if err := p.Halt(); err != nil {
    log.Fatal(err)
  }
}
~~~
