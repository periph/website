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

- A handy dev flow is to install GO directly on the Jetson Nano and compile and debug on target.  Delv has recently been ported to 64 bit ARM and you can debug directly on the target. 

- Some nice instructions for installing GO on a Raspberry Pi are [here](https://www.jeremymorgan.com/tutorials/raspberry-pi/install-go-raspberry-pi/).  These same instructions are applicable to the Jetson Nano.  

- Download the ARMv8 (arm64) version of GO as you are following the instructions above from  https://golang.org/dl/. Extra steps not covered in the linked instructions:
  ```
  Create a go directory with needed subdirectories
  mkdir ~/go
  mkdir ~/go/bin
  mkdir ~/go/src
  mkdir ~/go/pkg
  Add the following to your ~/.profile file (in addition to the edits you made following the instructions above)
  PATH=$PATH:$HOME/go/bin
  This step is needed so all your GO tools will be in your path
  ```
- An easy way to install all the GO tools needed to is to install Vscode on the Jetson Nano and the GO extension.  The extension will offer to install all the needed GO add ons for you.  Click yes to all and it will install all the tools into your $HOME/go/bin directory.  If you don't go the Vscode route, then you can install the Delv debugger manually
  ```
  go get github.com/go-delve/delve/cmd/dlv
  ```
- To enable SPI check out this link [here](https://www.jetsonhacks.com/2020/05/04/spi-on-jetson-using-jetson-io/)
# Support (tested on the bench manually)
## GPIO
- Write tested and working
## I2C
- Read and write tested and working
## SPI 
  - Mode0 read and write tested and working
  - Mode1 write tested and working with the following caveat:  spi.NoCS option does not work and returns an error
  - Another caveat: When attempting to connect to SPI1.0 an error was returned.  If you connect to SPI0.0 it works fine on SPI1.

# Buying

There are multiple places to purchase a Jetson Nano Dev Kit:

- Check out this link: https://developer.nvidia.com/buy-jetson?product=jetson_nano&location=US

_The periph authors do not endorse any specific seller. These are only provided
for your convenience._
