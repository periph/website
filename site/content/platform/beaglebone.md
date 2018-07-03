+++
title = "BeagleBone"
description = "Series of high quality boards"
picture = "/img/beaglebone-green-wireless.jpg"
+++

# Overview

BeagleBone is a [group of open source board
designs](https://beagleboard.org/boards). They use a AM335x 1Ghz ARM Cortex-A8
or AM5728 Cortex-A16 CPUs.


# Support

- BeagleBone Black/Green both non-wireless and Wireless are fully supported.
- Tested on recent [Debian Stretch IoT](http://beagleboard.org/latest-images).


## Drivers

- CPU driver lives in
  [periph.io/x/periph/host/am335x](https://periph.io/x/periph/host/am335x) but
  is just a stub for now.
- Headers driver lives in subpackages of
  [periph.io/x/periph/host/beagle](https://periph.io/x/periph/host/beagle).
  [bone](https://periph.io/x/periph/host/beagle/bone) and
  [green](https://periph.io/x/periph/host/beagle/green) exports the headers
  based on the detected host.
- sysfs driver lives in
  [periph.io/x/periph/host/sysfs](https://periph.io/x/periph/host/sysfs).


# Setup

Here's a quick HowTo to help quickly setup your beaglebone for the wireless
models with eMMC. This enables your BeagleBone to connect to your wireless
network, disable unnecessary services and reduces 2.4GHz interfere for more
efficient operation.

- Install the latest Debian image from http://beagleboard.org/latest-images to
  a microSD card.
- Copy your ssh public key from `~/.ssh/id_ed25519.pub` to `/boot`. If you don't
  know what it means, skip this step.
- For devices with eMMC (most):
  - Edit `/boot/uEnv.txt` (may require root access)
  - Uncomment the very last line so the eMMC get flashed upon boot, i.e. remove
    the `#` so the last line looks like:

    ```
    cmdline=init=/opt/scripts/tools/eMMC/init-eMMC-flasher-v3.sh
    ```
  - Put microSD card it and let the eMMC be flashed. It is doing to flash the
    blue LEDs while it's happening and will become silent once done, after
    several minutes.
  - Unplug power, remove the microSD card and reconnect power.
- Give it three minutes for the first boot.
- Over serial
  - Use a serial cable and plug into J1 to get to the terminal.
  - Login with user `debian` and password `temppwd`.
- Over Wifi
  - From a laptop, connect over its `BeagleBone-xxx` wifi, password is
    `BeagleBone`.
  - ssh in to make it connect to your home wifi (password is `temppwd`):
    ```
    ssh debian@192.168.8.2
    ```
- Configure the BeagleBone wifi to connect to your home wifi:
    ```
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
    ```
- If you had connected to the `BeagleBone-xxx` network, disconnect your laptop
  from it and connect back to your normal wifi, then confirm the BBBW/BBGW is
  correctly on your lan:
    ```
    ssh debian@<new ip>
    exit
    ```
  - This is possible this fails if you flashed your BeagleBone twice. Cleanup
    `~/.ssh/known_hosts` if needed.
- Disable the wifi access point on the BeagleBone, as this reduces 2.4GHz band
  performance:
    ```
    ssh debian@<new ip>
    sudo systemctl stop bb-wl18xx-wlan0
    sudo systemctl disable bb-wl18xx-wlan0
    sudo shutdown -r now
    ```
- Stop the embedded web server, to speed up booting and reduce memory usage:
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
- Setup via [github.com/periph/bootstrap](https://github.com/periph/bootstrap).
  You need to adjust each argument to your need or just skip them. This installs
  latest Go version, fix the timezone, configure ssh, auto-update every week and
  sends you an email to keep you updated.
    ```
    curl -sSL https://goo.gl/JcTSsH -o setup.sh
    bash setup.sh --help
    bash setup.sh \
        --email you+bb@gmail.com \
        --timezone America/Toronto \
        --ssh-key /boot/id_ed25519.pub
    sudo shutdown -r now
    ```
- If you plan to use your BeagleBone only via periph.io and not use the included
  tooling, you can uninstall default applications to save space, as the base
  image uses 2Gb:
    ```
    curl -sSL https://goo.gl/JcTSsH -o setup.sh
    bash setup.sh -- do_beaglebone_trim
    ```


# Buying

There are multiple BeagleBone versions so it is important to decide the type of
board desired. Most have internal flash, which makes these desirable as an
SDCard is not required.

- Adafruit: [adafruit.com/?q=beaglebone](https://www.adafruit.com/?q=beaglebone)
- Aliexpress:
  [aliexpress.com/wholesale?SearchText=beaglebone](https://aliexpress.com/wholesale?SearchText=beaglebone)
  (quality will vary among resellers)
- Amazon:
  [amazon.com/s?field-keywords=beaglebone](https://amazon.com/s?field-keywords=beaglebone)
  (quality will vary among resellers)
- Newark: [newark.com/beaglebone](http://newark.com/beaglebone)
- SeeedStudio:
  [seeedstudio.com/s/beaglebone.html](https://seeedstudio.com/s/beaglebone.html)
- Various resellers: [beagleboard.org/boards](https://beagleboard.org/boards)

_The periph authors do not endorse any specific seller. These are only provided
for your convenience._
