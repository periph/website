+++
title = "IR remote"
description = "InfraRed remote support"
picture = "/img/ir.jpg"
+++

# Overview

[lirc](https://periph.io/x/periph/devices/lirc) provides support to interact
with the [lircd service](http://www.lirc.org/).


# Example

_Purpose:_ display IR remote keys.

This example uses lirc (http://www.lirc.org/). This assumes you installed lirc
and configured it. See [devices/lirc](https://periph.io/x/periph/devices/lirc)
for more information.

~~~go
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
~~~
