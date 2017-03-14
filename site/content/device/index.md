+++
title = "Devices"
author = "Marc-Antoine Ruel"
description = "Overview of supported devices"
+++

# Overview

`periph` primary focus is on [enablers](), that is, host drivers to provide bus
APIs (I²C, 1-wire, SPI, etc) independent of the OS and the board. Yet this is
not useful if there is not at least a few device drivers included.

This page only gives a rough overview of the supported devices. Please look at
the device driver documentation for more details.

# Devices

## APA102

[periph.io/x/periph/devices/apa102](https://periph.io/x/periph/devices/apa102)
provides support for APA-102 LEDs. Their main advantage over WS2812b LEDs are:

- works over SPI at higher clock rate
- high contrast supported via dual PWM, one 5 bit and one 8 bit leading to a
  total range of 13 bits.

The main disadvantage is slightly higher cost.


## BME280

[periph.io/x/periph/devices/bme280](https://periph.io/x/periph/devices/bme280)
provides support for BME280, a popular humidity and pressure sensor. It also
support low precision temperature measurement.


## DS18b20

[periph.io/x/periph/devices/ds18b20](https://periph.io/x/periph/devices/ds18b20)
provides support for inexpensive Dallas Semi / Maxim DS18B20 and MAX31820 1-wire
temperature sensors.


## DS248X

[periph.io/x/periph/devices/ds248x](https://periph.io/x/periph/devices/ds248x)
provides support for a Maxim DS2483 or DS2482-100 1-wire interface chip over
I²C.


## SSD1306

[periph.io/x/periph/devices/ssd1306](https://periph.io/x/periph/devices/ssd1306)
provides support for the SSD1306 monochrome OLED display controller. It can
control displays up to 128x64 in size.


## TM1637

[periph.io/x/periph/devices/tm1637](https://periph.io/x/periph/devices/tm1637)
provides support for the TM1637 hex digits controller. It is controlled directly
over GPIO pins.
