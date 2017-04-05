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

Setup for [BME280 smoke
test](https://periph.io/x/periph/devices/bme280/bme280smoketest): two
[BME280](https://periph.io/x/periph/devices/bme280) connected are to a Raspberry
Pi 3; the top one is connected via [I²C](https://periph.io/x/periph/conn/i2c),
the bottom one is connected via [SPI](https://periph.io/x/periph/conn/spi):

![bme280](https://raw.githubusercontent.com/periph/website/master/site/static/img/bme280-two.jpg)

[periph.io/x/periph/devices/bme280](https://periph.io/x/periph/devices/bme280)
provides support for BME280 via either I²C or SPI, a popular humidity and
pressure sensor. It also support low precision temperature measurement.


## DS18b20

[periph.io/x/periph/devices/ds18b20](https://periph.io/x/periph/devices/ds18b20)
provides support for inexpensive Dallas Semi / Maxim DS18B20 and MAX31820 1-wire
temperature sensors.


## DS248X

[periph.io/x/periph/devices/ds248x](https://periph.io/x/periph/devices/ds248x)
provides support for a Maxim DS2483 or DS2482-100 1-wire interface chip over
I²C.


## SSD1306

<div class="youtube"><iframe src=//www.youtube.com/embed/1yEPFeP7Ky4 allowfullscreen frameborder=0></iframe></div>

[periph.io/x/periph/devices/ssd1306](https://periph.io/x/periph/devices/ssd1306)
provides support for the SSD1306 monochrome OLED display controller via I²C or
SPI in 4-wire mode. It can control displays up to 128x64 in size.


## TM1637

[periph.io/x/periph/devices/tm1637](https://periph.io/x/periph/devices/tm1637)
provides support for the TM1637 hex digits controller. It is controlled directly
over GPIO pins.
