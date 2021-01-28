+++
title = "Jetson Nano Developer Kit"
description = "NVIDIA Jetson Nano module and carrier board"
picture = "/img/jetson-nano-dev-kit.jpg"
+++

# Overview

[Nividia's low cost entry level Jetson platform](https://developer.nvidia.com/EMBEDDED/jetson-nano-developer-kit).  The Jetson Nano Dev Kit has a Raspberry Pi compatible 40 pin header.  A nice link to the GPIO can be found [here](https://www.jetsonhacks.com/nvidia-jetson-nano-j41-header-pinout/)




# Setup

Here's some setup notes for the Jetson Nano

- Install the latest Jetson SD card image from https://developer.nvidia.com/embedded/learn/get-started-jetson-nano-devkit#write to a microSD card.  At least a 16GB card is recommended.  The download image is 6GB.

- The Jetson Nano can draw quite a bit of power if you push it hard.  It is recommended to get a decent 4A 
  supply and populate J48 with a shorting jumper.  [See this excellent post here](https://www.jetsonhacks.com/2019/04/10/jetson-nano-use-more-power/)

- The Jetson Nano does not come with wifi and bluetooth.  Check out this link [here](https://www.jetsonhacks.com/2019/04/08/jetson-nano-intel-wifi-and-bluetooth/) to add a wifi and bluetooth module.  Alternatively you can just
plug it into ethernet to get network connectivity.

- The easiest way to get up and running is to plug in a monitor, keyboard, and mouse.  There are directions for
headless setup that can be found [here](https://developer.nvidia.com/embedded/learn/get-started-jetson-nano-devkit#setup-headless) and [here](https://www.jetsonhacks.com/2019/08/21/jetson-nano-headless-setup/)


- To enable SPI check out this link [here](https://www.jetsonhacks.com/2020/05/04/spi-on-jetson-using-jetson-io/)
# Support (tested on the bench manually)
## GPIO
- Write tested and working
- Read tested and working
## I2C
- Read and write tested and working
## SPI 
  - Mode0 read and write tested and working
  - Mode1 write tested and working with the following caveat:  spi.NoCS option does not work and returns an error
  - Another caveat: When attempting to connect to SPI1.0 an error was returned.  If you connect to SPI0.0 it works fine on SPI1.

# Buying

There are multiple places to purchase a Jetson Nano Dev Kit:

- Nvidia site: https://developer.nvidia.com/buy-jetson?product=jetson_nano&location=US

_The periph authors do not endorse any specific seller. These are only provided
for your convenience._
