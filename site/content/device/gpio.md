+++
title = "GPIO"
description = "Generic digital input/output support"
picture = "/img/raspberrypi3.jpg"
+++

# Overview

GPIO pins can be leveraged to use as a on/off signal for both input and output.
Uses include reading a button, a motion sensor, driving a LED or a buzzer.

Package [gpioreg](https://periph.io/x/periph/conn/gpio/gpioreg) permits
enumerating all the available GPIO pins.

Package [pinreg](https://periph.io/x/periph/conn/pin/pinreg) permits
enumerating all the available pin headers. This includes non-GPIO pins like
ground, 3.3V and 5V pins, etc.


# Examples

- [Toggle a LED](/device/led/)
- [Read button presses](/device/button/)
- [Detect motion](/device/hc-sr501/)
