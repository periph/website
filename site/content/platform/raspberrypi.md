+++
title = "Raspberry Pi"
description = "running Raspbian Jessie Lite"
picture = "/img/raspberrypi3.jpg"
+++

# Overview

[Raspberry Pis](https://raspberrypi.org/) are the poster child of micro
computers and are extremely popular and available from multiple resellers. They
are very well supported. The following functionality is supported:

- 2x I²C buses
- 2x SPI bus
- 46x high performance edge detection enabled memory-mapped GPIO pins


# Buying

Raspberry Pis can be bought pretty much anywhere. At worst a Raspberry Pi 3 can
be bought at around 38$USD on Aliexpress with free shipping in various
countries.


# Support

- Tested on recent [Raspbian Stretch
  Lite](https://www.raspberrypi.org/downloads/raspbian/) 4.14.30-v7+.
- Raspberry Pi 1, 2 and 3 are fully supported.
- Other versions like Compute module doesn't have yet pin out defined because
  lack of hardware in test lab. [Please contribute](/project/contributing/).
- [Windows IoT](https://developer.microsoft.com/windows/iot) is not [supported
  yet](https://github.com/google/periph/issues/114).


## Drivers

- CPU driver lives in
  [periph.io/x/periph/host/bcm283x](https://periph.io/x/periph/host/bcm283x).
- Headers driver lives in
  [periph.io/x/periph/host/rpi](https://periph.io/x/periph/host/rpi). It exports
  the headers based on the detected host.
- sysfs driver lives in
  [periph.io/x/periph/host/sysfs](https://periph.io/x/periph/host/sysfs).
- videocore driver (GPU driver for DMA operations) lives in
  [periph.io/x/periph/host/videocore](https://periph.io/x/periph/host/videocore).


# Configuration

The pins function can be affected by device overlays as defined in
`/boot/config.txt`. The full documentation of overlays is at
[boot/overlays/README](https://github.com/raspberrypi/firmware/blob/master/boot/overlays/README).
Documentation for the file format is [on raspberry pi
site](https://www.raspberrypi.org/documentation/configuration/device-tree.md#part3)


## GPIO

All GPIO are supported at extremely high speed via memory mapped GPIO registers,
with full interrupt based edge detection.


## I²C

The BCM238x has two I²C buses but [it is
recommended](https://github.com/raspberrypi/hats) to only use the second.
Enabling `/dev/i2c-1` permanently:
```
sudo raspi-config nonint do_i2c 0
```

### Speed

The speed default is **62.5kHz, not 100kHz** as advertized by the driver. The
I²C spec calls for 400kHz for many I²C devices so it is worth increasing the
default bus speed. For a bandwidth heavy device like an SSD1306, this may be a
requirement.

*Warning*: A slower speed is selected and used than the one specified. Here's a
few values tested:

|Requested |  Actual |
|----------|---------|
|  100kHz  | 62.5kHz |
|  400kHz  |  250Khz |
|  500kHz  |  312Khz |
|  600kHz  |  375Khz |
|  650kHz  |  410Khz |
| 1000kHz  |  625Khz |

It doesn't make any sense. The author is not sure why asking for 400Khz doesn't
lead to 375kHz, looks like the
[i2c_bcm2708](https://github.com/raspberrypi/linux/blob/rpi-4.9.y/drivers/i2c/busses/i2c-bcm2708.c)
driver speed selection algorithm is poorly implemented. As such, this is
currently (as of 2017-04-12) recommended to ask for 600kHz to get 375kHz.

If the value was overriden, it can be queried with:
```
cat /sys/module/i2c_bcm2708/parameters/baudrate
```

Writing to this file doesn't update the bus speed.


#### Permanent

The I²C #1 bus speed can be increased permanently to 375kHz by either:

- Append to `/boot/config.txt`:
```
dtparam=i2c_baudrate=600000
```
- Create a file in `/etc/modprobe.d/` (e.g. `/etc/modprobe.d/i2c.conf`)
  containing:
```
options i2c_bcm2708 baudrate=600000
```

Refer to the [official
documentation](https://www.raspberrypi.org/documentation/configuration/device-tree.md#part3.3)
for more information.


#### Temporary

The I²C bus speed can be changed temporarily until next reboot by running:
```
sudo modprobe -r i2c_bcm2708 && sudo modprobe i2c_bcm2708 baudrate=600000
```

Either of the 3 methods above affect both buses `I2C0` and `I2C1`
simultaneously.


## PWM

To take back control of the PWM pins to use as general purpose PWM, **comment**
out the following line in `/boot/config.txt`:
```
dtparam=audio=on
```


## SPI

The BCM238x has 3 SPI buses but only 2 are soldered on the RPi.

The first SPI controller (`/dev/spidev0.0` and `/dev/spidev0.1`) can be enabled
permanently with:
```
sudo raspi-config nonint do_spi 0
```


### Second SPI

If you need two SPI buses simultaneously, `/dev/spidev1.0` can be enabled with
adding to `/boot/config.txt`:
```
dtoverlay=spi1-1cs
```

On rPi3, bluetooth must be disabled with:
```
dtoverlay=pi3-disable-bt
```

and bluetooth UART service needs to be disabled with:
```
sudo systemctl disable hciuart
```


### SPI buffer size

SPI transaction size is limited by spidev driver buffer size. Its default is
4096 bytes. The current value can be viewed with the following command:
```
cat /sys/module/spidev/parameters/bufsiz
```

In some case this may not be enough like with the FLIR Lepton. The permanent fix
is to edit `/boot/cmdline.txt` to insert `spidev.bufsiz=65536` at the beginning
of the line.


## I2S

I2S can be enabled by adding the following in `/boot/config`:
```
dtparam=i2s=on
```


## IR

### IR/Hardware

Raspbian has a specific device tree overlay named `lirc-rpi` to enable
hardware based decoding of IR signals. This loads a kernel module that
exposes itself at `/dev/lirc0`. Enable permanently by adding to
`/boot/config.txt`:
```
dtoverlay=lirc-rpi,gpio_out_pin=5,gpio_in_pin=13,gpio_in_pull=high
```

Default pins 17 and 18 clashes with SPI1 so change the pin if you plan to
enable both SPI buses.

See
[boot/overlays/README](https://github.com/raspberrypi/firmware/blob/master/boot/overlays/README)
for more details on configuring the kernel module.


### IR/Software

Once the kernel module is configured, you need to point `lircd` to it. Run the
following as root to edit `/etc/lirc/hardware.conf` to point `lircd` to use
`lirc_rpi` kernel module:

```
sed -i s'/DRIVER="UNCONFIGURED"/DRIVER="default"/' /etc/lirc/hardware.conf
sed -i s'/DEVICE=""/DEVICE="\/dev\/lirc0"/' /etc/lirc/hardware.conf
sed -i s'/MODULES=""/MODULES="lirc_rpi"/' /etc/lirc/hardware.conf
```

### IR/References

Linux [lirc_rpi.c](https://github.com/raspberrypi/linux/blob/rpi-4.8.y/drivers/staging/media/lirc/lirc_rpi.c)

Someone made a version that supports multiple devices:
[github.com/bengtmartensson/lirc_rpi](https://github.com/bengtmartensson/lirc_rpi)


## UART

Kernel boot messages go to the UART (0 or 1, depending on Pi version) at
115200 bauds.

On Rasberry Pi 1 and 2, UART0 is used.

On Raspberry Pi 3, UART0 is connected to bluetooth so the console is
connected to UART1 instead. Disabling bluetooth also reverts to use UART0
and not UART1.

UART0 can be disabled with:
```
dtparam=uart0=off
```

UART1 can be enabled with:
```
dtoverlay=uart1
```
