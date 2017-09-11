+++
title = "BMxx80"
description = "Family of atmospheric sensors"
+++

# Overview

[periph.io/x/periph/devices/bmxx80](https://periph.io/x/periph/devices/bmxx80)
provides support for a [popular sensor family from
Bosch](https://www.bosch-sensortec.com/bst/products/environmental/overview_environmental):

* BMP180 and BMP280, temperature and pressure
* BME280, temperature, pressure and relative humidity

BMP180 can be used over I²C. BME280 and BMP280 can use either I²C or SPI.

They all provide low precision temperature measurement.

![bme280](/img/bme280.jpg)


# Driver

The driver as the following functionality:

- Integer only calculation
- Support for both I²C and SPI (BMx280 only) connectivity


# Tool

Use
[cmd/bmxx80](https://github.com/google/periph/blob/master/cmd/bmxx80/main.go) to
retrieve measurement from the device.


# Example

_Purpose:_ gather temperature, pressure and relative humidity (BME280 only).

This example uses either a [BME280 or
BMP280](https://periph.io/x/periph/devices/bmxx80) connected via
[I²C](https://periph.io/x/periph/conn/i2c).


~~~go
package main

import (
    "fmt"
    "log"

    "periph.io/x/periph/conn/i2c/i2creg"
    "periph.io/x/periph/devices"
    "periph.io/x/periph/devices/bmxx80"
    "periph.io/x/periph/host"
)

func main() {
    // Load all the drivers:
    if _, err := host.Init(); err != nil {
        log.Fatal(err)
    }

    // Open a handle to the first available I²C bus:
    bus, err := i2creg.Open("")
    if err != nil {
        log.Fatal(err)
    }
    defer bus.Close()

    // Open a handle to a bme280/bmp280 connected on the I²C bus using default
    // settings:
    dev, err := bmxx80.NewI2C(bus, 0x76, nil)
    if err != nil {
        log.Fatal(err)
    }
    defer dev.Halt()

    // Read temperature from the sensor:
    var env devices.Environment
    if err = dev.Sense(&env); err != nil {
        log.Fatal(err)
    }
    fmt.Printf("%8s %10s %9s\n", env.Temperature, env.Pressure, env.Humidity)
}
~~~


# Smoke test

Setup for [BME280/BMP280 smoke
test](https://periph.io/x/periph/devices/bmxx80/bmx280smoketest):

- Two [BME280 or BMP280](https://periph.io/x/periph/devices/bmxx80) connected to
  a Raspberry Pi 3:
  - the top one is connected via [I²C](https://periph.io/x/periph/conn/i2c)
  - the bottom one is connected via [SPI](https://periph.io/x/periph/conn/spi):

![bme280](/img/bme280-two.jpg)

It confirms that two BME280/BMP280 sensors can be driven simultaneously, one
connected via I²C, one via SPI. They shall measure mostly the same atmospheric
properties.
