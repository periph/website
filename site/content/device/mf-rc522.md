+++
title = "MF-RC522"
description = "MIFARE and NTAG frontend"
picture = "/img/mfrc522.JPG"
+++

# Overview
The MFRC522 supports all variants of the MIFARE Mini, MIFARE 1K,
MIFARE 4K, MIFARE Ultralight, MIFARE DESFire EV1 and MIFARE Plus RF
identification protocols.

[Datasheet](https://www.nxp.com/docs/en/data-sheet/MFRC522.pdf)

# Driver
- Support for both I²C and SPI connectivity

# Example

Raspberry 3B+ connected via SPI port.

Hint:
If you are unable to read tags, a bad power supply could be one reason.

- RST is connected to GPIO 25
- IRQ to GPIO 24
- MISO to GPIO 9 (MISO)
- MOSI to GPIO 10 (MOSI)
- SCK to GPIO 11 (SCLK)
- SDA to GPIO 8 (CE0)
- VCC is connected to 3.3 V
- GND to ground


![boardimage](/img/mfrc522)


```go
package main

import (
	"encoding/hex"
	"fmt"
	"log"
	"time"

	"periph.io/x/conn/v3/gpio"
	"periph.io/x/conn/v3/gpio/gpioreg"
	"periph.io/x/conn/v3/spi"
	"periph.io/x/conn/v3/spi/spireg"
	"periph.io/x/devices/v3/mfrc522"
	"periph.io/x/devices/v3/mfrc522/commands"
	"periph.io/x/host/v3"
)

// mfrc522 rfid device
var rfid *mfrc522.Dev

// spi port
var port spi.PortCloser

// pins used for rest and irq
const (
	resetPin = "P1_22" // GPIO 25
	irqPin   = "P1_18" // GPIO 24
)

/*
Setup inits and starts hardware.
*/
func setup() {
	var err error

	// guarantees all drivers are loaded.
	if _, err = host.Init(); err != nil {
		log.Fatal(err)
	}

	// get the first available spi port eith empty string.
	port, err = spireg.Open("")
	if err != nil {
		log.Fatal(err)
	}

	// get GPIO rest pin from its name
	var gpioResetPin gpio.PinOut = gpioreg.ByName(resetPin)
	if gpioResetPin == nil {
		log.Fatalf("Failed to find %v", resetPin)
	}

	// get GPIO irq pin from its name
	var gpioIRQPin gpio.PinIn = gpioreg.ByName(irqPin)
	if gpioIRQPin == nil {
		log.Fatalf("Failed to find %v", irqPin)
	}

	rfid, err = mfrc522.NewSPI(port, gpioResetPin, gpioIRQPin, mfrc522.WithSync())
	if err != nil {
		log.Fatal(err)
	}

	// setting the antenna signal strength, signal strength from 0 to 7
	rfid.SetAntennaGain(5)

	fmt.Println("Started rfid reader.")
}

// close is idling the RFID device and closes spi port.
func close() {

	if err := rfid.Halt(); err != nil {
		log.Fatal(err)
	}

	if err := port.Close(); err != nil {
		log.Fatal(err)
	}

}

// stringIntoByte16 converst the given str into 16 bytes.
// String that are longer than 16 bytes, will be cut.
func stringIntoByte16(str string) [16]byte {
	var data [16]byte
	copy(data[:], str) // copy already checks length of str
	return data
}

// find first null byte
func clen(n []byte) int {
	for i := 0; i < len(n); i++ {
		if n[i] == 0 {
			return i
		}
	}
	return len(n)
}

// main starts setup, reads UID, write data tosector 2 block 0 and read writen data.
func main() {

	// init hardware
	setup()

	// trying to read UID
	data, err := rfid.ReadUID(5 * time.Second)
	if err != nil {
		log.Fatal(err)
	} else {
		fmt.Println(hex.EncodeToString(data))
	}

	// trying to write data
	err = rfid.WriteCard(5*time.Second, byte(commands.PICC_AUTHENT1B), 2, 0, stringIntoByte16("Hallo Welt"), mfrc522.DefaultKey)
	if err != nil {
		log.Fatal(err)
	} else {
		fmt.Println("Write successful")
	}

	// trying to read data
	data, err = rfid.ReadCard(5*time.Second, commands.PICC_AUTHENT1B, 2, 0, mfrc522.DefaultKey)
	if err != nil {
		log.Fatal(err)
	} else {
		str := string(data[:clen(data)])
		fmt.Println(str)
	}

	close()

}

```

# Buying

- AZ Delivery:
  [az-delivery.de/en/products/rfid-set](https://www.az-delivery.de/en/products/rfid-set)
- Aliexpress:
  [aliexpress.com/wholesale?SearchText=mfrc522](https://aliexpress.com/wholesale?SearchText=mfrc522)
- Amazon:
  [amazon.com/s?field-keywords=mfrc522](https://amazon.com/s?field-keywords=mfrc522)

_The periph authors do not endorse any specific seller. These are only provided
for your convenience._
