+++
title = "BeagleBone"
description = "Series of high quality boards"
+++

# Overview

![boardimage](/img/beaglebone-green-wireless.jpg)

BeagleBone is a [group of open source board
designs](https://beagleboard.org/boards). They use a AM335x 1Ghz ARM Cortex-A8
or AM5728 Cortex-A16 CPUs.


# Buying

The board can be bought directly from
[SeeedStudio](https://www.seeedstudio.com/category/Beaglebone-c-8.html) or
[various resellers](https://beagleboard.org/boards).


# Support

The BeagleBones are supported when running a Debian based distribution. There is
no CPU nor headers drivers yet.


# Setup

Here's a quick HowTo to help quickly setup your beaglebone for the wireless
models with eMMC. This enables your BeagleBone to connect to your wireless
network, disable unnecessary services and reduces 2.4GHz interfere for more
efficient operation.

- Install the latest Debian image from http://beagleboard.org/latest-images to
  a microSD card.
- For devices with eMMC (most):
  - Edit `/boot/uEnv.txt` (may require root access)
  - Uncomment the very last line so the eMMC get flashed upon boot, i.e. remove
    the `#` so the last line looks like:
    ```
    cmdline=init=/opt/scripts/tools/eMMC/init-eMMC-flasher-v3.sh
    ```
  - Put microSD card it and let the eMMC be flashed. It is doing to flash the
    blue LEDs while it's happening and will become silent once done.
  - Unplug power, remove the microSD card and reconnect power.
- Give it two minutes for the first boot.
- Connect over its `BeagleBone-xxx` wifi, password is `BeagleBone`
- Make it connect to your home wifi (password is `temppwd`):

    ```
    ssh debian@192.168.8.2
    sudo connmanctl
    > scan wifi
    > services
    > agent on
    > connect wifi_foo_bar_managed_psk
      (choose your actual network)
      (type passphrase)
    > quit
    ifconfig | grep -A 1 wlan0
      (make sure you are connected via wlan0, note the IP address)
    exit
      (confirm the BBBW/BBGW is correctly on your lan)
    ssh debian@<new ip>
    ```
- Disable the wifi access point on the BeagleBone, as this reduces 2.4GHz band
  performance (password is still `temppwd`):
    ```
    ssh debian@<new ip>
    sudo systemctl stop bb-wl18xx-wlan0
    sudo systemctl disable bb-wl18xx-wlan0
    sudo shutdown -r now
    ```
- Stop the embedded web server, to speed up booting and reduce memory usage
  (again, via ssh):
    ```
    sudo systemctl stop bonescript-autorun
    sudo systemctl disable bonescript-autorun
    sudo systemctl stop apache2
    sudo systemctl disable apache2
    ```
- Stop bluetooth support, to free up 2.4GHz space a bit and help wifi
  performance:
    ```
    sudo systemctl stop bb-wl18xx-bluetooth
    sudo systemctl disable bb-wl18xx-bluetooth
    sudo systemctl stop bluetooth
    sudo systemctl disable bluetooth
    ```

Each of the above can be reenabled by changing `disable` with `enable` and
`stop` with `start`.


## Drivers

- sysfs driver lives in
  [periph.io/x/periph/host/sysfs](https://periph.io/x/periph/host/sysfs).
