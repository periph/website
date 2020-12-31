+++
title = "GPIO"
description = "Generic digital input/output support"
picture = "/img/raspberrypi3.jpg"
+++

# Overview

GPIO pins can be leveraged to use as a on/off signal for both input and output,
and PWM. Uses include reading a button, a motion sensor, driving a LED or a
buzzer.

Package [gpio](https://periph.io/x/conn/v3/gpio) defines the interfaces.


# GPIO registry

Package [gpioreg](https://periph.io/x/conn/v3/gpio/gpioreg) permits
enumerating all the available GPIO pins currently available.

On a Raspberry Pi 3, the following are synonyms, use the form you prefer:

- Runtime discovery:
  - [`gpioreg.ByName("11")`](https://periph.io/x/conn/v3/gpio/gpioreg#ByName):
    gpio number
  - [`gpioreg.ByName("GPIO11")`](https://periph.io/x/conn/v3/gpio/gpioreg#ByName):
    gpio name as defined per the
    [bcm238x](https://periph.io/x/host/v3/bcm283x) CPU driver
  - [`gpioreg.ByName("P1_23")`](https://periph.io/x/conn/v3/gpio/gpioreg#ByName):
    board header `P1` position `23` name as defined by the
    [rpi](https://periph.io/x/host/v3/rpi) board driver
  - [`gpioreg.ByName("SPI0_CLK")`](https://periph.io/x/conn/v3/gpio/gpioreg#ByName):
    function clock on SPI bus 0
- Using global variables:
  - [`rpi.P1_23`](https://periph.io/x/host/v3/rpi#P1_33) to
    select the pin via its _position on the board_
  - [`bcm283x.GPIO11`](https://periph.io/x/host/v3/bcm283x#GPIO13) for the
    pin as defined by the CPU


# Pin registry

Package [pinreg](https://periph.io/x/conn/v3/pin/pinreg) permits
enumerating all the available pin headers. This includes non-GPIO pins like
ground, 3.3V and 5V pins, etc.


# Examples

- [Toggle a LED](/device/led/)
- [Read button presses](/device/button/)
- [Detect motion](/device/pir/) via a PIR
- [Make noise](/device/buzzer/) with a buzzer
