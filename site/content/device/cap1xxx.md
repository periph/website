+++
title = "CAP1xxx"
description = "Family of capacitive touch sensors"
picture = "/img/cap1xxx.jpg"
+++

# Overview

[cap1xxx](https://periph.io/x/periph/devices/cap1xxx) provides support to interact with the cap1xxx family of capacitive touch sensors by [Microchip](https://www.microchip.com/wwwproducts/en/CAP1188). The sensor family is made of the cap1105, cap1106, cap1114, cap1133, cap1126, cap1128, cap1166, cap1188 devices which offer 3, 5, 6, 8, 14 channel capacitive touch sensors and 2, 3, 6, 8, 11 LED drivers.

## cap1188

The cap1188 might be the most popular of the family with 8 individual touch pads and matching LEDs.
You can select one of 5 I2C addresses, for a total of 40 capacitive touch pads on one I2C 2-wire bus. Using this chip is a lot easier than doing the capacitive sensing with analog inputs: it handles all the filtering for you and can be configured for more/less sensitivity.

[![Adafruit cap1188](/img/adafruit_cap1188.jpg)](https://learn.adafruit.com/adafruit-cap1188-breakout/overview)

Above is the breakout board provided by [Adafruit](https://adafruit.com).

[Pimoroni](https://pimoroni.com) has a few hats using the cap1188 too such as their [Drum Hat](https://shop.pimoroni.com/products/drum-hat) and the [Piano Hat](https://shop.pimoroni.com/products/piano-hat).

![Pimoroni Drum Hat](/img/pimoroni_drumhat.jpg)
![Pimoroni Piano Hat](/img/pimoroni_piano_hat.jpg)

## cap1166

The cap1166 is similar to the cap1188 but has 6 touch sensors. Here is an example with the [Pimoroni Phat Touch](https://shop.pimoroni.com/products/touch-phat).

![Pimoroni Phat Touch](/img/pimoroni_touch_phat.jpg)

# Configuration

To get feedback when the sensors are touched, the developer needs to set an
alert pin that will let them know when a touch event occurs. The alert pin is
the pin connected to the IRQ/interrupt pin of the device. Then we need to set this pin to be monitored for interrupts. Optionally, a reset pin can also be used to keep the state of the device clean.

# Example

```go
package main

import (
	"fmt"
	"log"

	"periph.io/x/periph/conn/gpio"
	"periph.io/x/periph/conn/gpio/gpioreg"
	"periph.io/x/periph/conn/i2c/i2creg"
	"periph.io/x/periph/experimental/devices/cap1xxx"
)

func main() {
	// Open the I²C bus to which the cap1188 is connected.
	i2cBus, err := i2creg.Open("")
	if err != nil {
		log.Fatal(err)
	}
	defer i2cBus.Close()

	// We need to set an alert ping that will let us know when a touch event
	// occurs. The alert pin is the pin connected to the IRQ/interrupt pin.
	alertPin := gpioreg.ByName("GPIO25")
	if alertPin == nil {
		log.Fatal("invalid alert GPIO pin number")
	}
	// We set the alert pin to monitor for interrupts.
	if err := alertPin.In(gpio.PullUp, gpio.BothEdges); err != nil {
		log.Fatalf("Can't monitor the alert pin")
	}

	// Optionally but highly recommended, we can also set a reset pin to
	// start/leave things in a clean state.
	resetPin := gpioreg.ByName("GPIO21")
	if resetPin == nil {
		log.Fatal("invalid reset GPIO pin number")
	}

	// We will configure the cap1188 by setting some options, we can start by the
	// defaults.
	opts := cap1xxx.DefaultOpts
	opts.AlertPin = alertPin
	opts.ResetPin = resetPin

	// Open the device so we can detect touch events.
	dev, err := cap1xxx.NewI2C(i2cBus, &opts)
	if err != nil {
		log.Fatalf("couldn't open cap1xxx: %v", err)
	}

	fmt.Println("Monitoring for touch events")
	maxTouches := 42 // Stop the program after 42 touches.
	for maxTouches > 0 {
		if alertPin.WaitForEdge(-1) {
			maxTouches--
			var statuses [8]cap1xxx.TouchStatus
			if err := dev.InputStatus(statuses[:]); err != nil {
				fmt.Printf("Error reading inputs: %v\n", err)
				continue
			}
			// print the status of each sensor
			for i, st := range statuses {
				fmt.Printf("#%d: %s\t", i, st)
			}
			fmt.Println()
			// we need to clear the interrupt so it can be triggered again
			if err := dev.ClearInterrupt(); err != nil {
				fmt.Println(err, "while clearing the interrupt")
			}
		}
	}
	fmt.Print("\n")
}
```
