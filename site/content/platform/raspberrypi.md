+++
title = "Raspberry Pi"
description = "running Raspbian Jessie Lite"
+++

# Overview

[Raspberry Pis](https://raspberrypi.org/) are the poster child of micro
computers and are extremely popular and available from multiple resellers. They
are very well supported. The following functionality is supported:

- 2x I²C buses
- 2x SPI bus
- 46x high performance edge detection enabled memory-mapped GPIO pins

![boardimage](https://raw.githubusercontent.com/periph/website/master/site/static/img/raspberrypi3.jpg)


# Buying

Raspberry Pis can be bought pretty much anywhere. At worst a Raspberry Pi 3 can
be bought at around 38$USD on Aliexpress with free shipping in various
countries.


# Support

- Tested on recent [Raspbian Jessie
  Lite](https://www.raspberrypi.org/downloads/raspbian/) 4.4.21-v7+.
- Raspberry Pi 1, 2 and 3 are fully supported.
- Other versions like Compute module doesn't have yet pin out defined because
  lack of hardware in test lab. [Please contribute](/project/contributing/).
- [Windows IoT](https://developer.microsoft.com/windows/iot) is not supported
  yet but support [is planned](https://github.com/google/periph/issues/114).


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

The speed defaults as 100kHz. The spec calls for 400kHz. For a bandwidth heavy
device like an SSD1306, this may be a requirement.

#### Permanent

The I²C bus speed can be increased permanently to 400kHz by either:

- (prefered) appending to `/boot/config.txt`:
```
dtparam=i2c_baudrate=400000
```
- adding a file in ` /etc/modprobe.d/` containing:
```
options i2c_bcm2708 baudrate=400000
```

#### Temporary

The I²C bus speed can be changed temporarily by one of these:

- write a number to `/sys/module/i2c_bcm2708/parameters/baudrate`
- running `modprobe -r i2c_bcm2708 && modprobe i2c_bcm2708 baudrate=400000`

In this case, the default value is used upon next reboot.

Either of the 4 methods above affect both buses `I2C0` and `I2C1`
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
