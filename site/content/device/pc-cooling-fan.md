+++
title = "PC Cooling Fan"
description = "Move air across to cool a embedded components."
picture = "/img/pc-cooling-fan.jpg"
+++

# Overview
Fans power can be controlled via a PWM is due to the fact that the duty cycle of the signal can be adjusted.

## Current

Fans can vary a lot, and have different volts and amps and somtimes can be too much for a GPIO.

# Example

This can be done via [GPIO pins](/device/gpio/).

**Note:** The PWM support is still iffy at best on the Raspberry Pi, and this
must be run as root.

~~~go
import (
	"log"
	"time"

	"periph.io/x/periph/conn/gpio"
	"periph.io/x/periph/conn/gpio/gpioreg"
	"periph.io/x/periph/conn/physic"
	"periph.io/x/periph/host"
)

// Start starts the Fan.
func Start(pin gpio.PinIO) {
	// Generate a 33% duty cycle 10KHz signal.
	if err := pin.PWM(gpio.DutyMax/3, 440*physic.Hertz); err != nil {
		log.Fatal(err)
	}
}

// Stop stops the Fan.
func Stop(pin gpio.PinIO) {
	if err := pin.Halt(); err != nil {
		log.Fatal(err)
	}
}

func main() {

	// Make sure periph is initialized.
	if _, err := host.Init(); err != nil {
		log.Fatal(err)
	}

	// Use gpioreg GPIO pin registry to find a GPIO pin by name.
	pin := gpioreg.ByName("GPIO6")

	// start the fan
	Start()

	// stop the fan after 10 seconds
	stopFan := time.AfterFunc(time.Second*10, Stop())
	defer stopFan.Stop()
}
~~~


# Buying

- Adafruit: [adafruit.com/?q=cooling%20fan](https://www.adafruit.com/?q=cooling%20fan)
- Aliexpress:
  [aliexpress.com/premium/pc-fan](https://www.aliexpress.com/premium/pc-fan.html?SearchText=pc+fan&d=y&tc=ppc&initiative_id=SB_20181119090317&origin=y&catId=0&isViewCP=y)
- Amazon:
  [amazon.co.uk/s/ref=pc-fan](https://www.amazon.co.uk/s/ref=nb_sb_noss_2?url=search-alias%3Daps&field-keywords=case+fan+with+pwm&rh=i%3Aaps%2Ck%3Acase+fan+with+pwm)

_The periph authors do not endorse any specific seller. These are only provided
for your convenience._
