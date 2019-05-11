+++
title = "IR remote"
description = "InfraRed remote support"
picture = "/img/ir.jpg"
+++

# Overview

[lirc](https://periph.io/x/periph/devices/lirc) provides support to interact
with the [lircd service](http://www.lirc.org/). This is a linux only driver.


# Configuration

lircd MUST be configured via TWO files: `/etc/lirc/hardware.conf` and
`/etc/lirc/lircd.conf`.

See http://www.lirc.org/ for more details about daemon configuration.


## /etc/lirc/hardware.conf

This file contains the interaction between the lircd process and the kernel
driver, if any. This is the link between the physical signal and decoding
pulses.

## /etc/lirc/lircd.conf

This file contains all the known IR codes for the remotes you plan to use
and convert into key codes. This means you need to "train" lircd with the
remotes you plan to use.

Keys are listed at http://www.lirc.org/api-docs/html/input__map_8inc_source.html

# Debugging

Here's a quick recipe to train a remote:

    # Detect your remote
    irrecord -a -d /var/run/lirc/lircd ~/lircd.conf
    # Grep for key names you found to find the remote in the remotes library
    grep -R '<hex value>' /usr/share/lirc/remotes/
    # Listen and send command to the server
    nc -U /var/run/lirc/lircd
    # List all valid key names
    irrecord -l
    grep -hoER '(BTN|KEY)_\w+' /usr/share/lirc/remotes | sort | uniq | less


# Raspbian

Please see [Raspberry Pi IR specific](/platform/raspberrypi/#ir) documentation
for details on how to set it up.


# Hardware

A good device is the VS1838. Then you need device driver for hardware
accelerated signal decoding, that lircd will then leverage to decode the
keypresses. Some boards come with one IR device directly on it.


# Example

_Purpose:_ display IR remote keys.

This example uses lirc (http://www.lirc.org/). This assumes you installed lirc
and configured it. See [devices/lirc](https://periph.io/x/periph/devices/lirc)
for more information.

```go
package main

import (
    "fmt"
    "log"

    "periph.io/x/periph/devices/lirc"
    "periph.io/x/periph/host"
)

func main() {
    // Load all the drivers:
    if _, err := host.Init(); err != nil {
        log.Fatal(err)
    }

    // Open a handle to lircd:
    conn, err := lirc.New()
    if err != nil {
        log.Fatal(err)
    }

    // Open a channel to receive IR messages and print them out as they are
    // received, skipping repeated messages:
    for msg := range conn.Channel() {
        if !msg.Repeat {
            fmt.Printf("%12s from %12s\n", msg.Key, msg.RemoteType)
        }
    }
}
```


# Buying

- Adafruit: [adafruit.com/?q=ir](https://www.adafruit.com/?q=ir)
- Aliexpress:
  [aliexpress.com/wholesale?SearchText=vs1838](https://aliexpress.com/wholesale?SearchText=vs1838)
- Amazon:
  [amazon.com/s?field-keywords=vs1838](https://amazon.com/s?field-keywords=vs1838)
- Pimoroni: [shop.pimoroni.com/?q=ir](https://shop.pimoroni.com/?q=ir)

_The periph authors do not endorse any specific seller. These are only provided
for your convenience._
