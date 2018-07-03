+++
title = "periph"
description = "Peripherals I/O in Go"
+++

![boardimage](/img/periph-mascot-280.png)

# Overview

[periph.io/x/periph](https://periph.io/x/periph) is a standalone hardware
library with no external dependency. It can be viewed as a lower level layer
than [Gobot](https://gobot.io), and yes we're discussing to collaborate in the
future!


# Features

- No external dependencies.
- No C dependency, doesn't use `cgo`.
- Explicit initialization: know what [hardware is detected and what is
  not](https://github.com/google/periph/tree/master/cmd/periph-info).
- [Interfaces](https://periph.io/x/periph/conn):
  [GPIO](https://periph.io/x/periph/conn/gpio) (with edge detection),
  [I²C](https://periph.io/x/periph/conn/i2c),
  [SPI](https://periph.io/x/periph/conn/spi),
  [1-wire](https://periph.io/x/periph/conn/onewire).
- [Continuously tested](/project/contributing/#testing) via
  [gohci](https://github.com/periph/gohci).
- [SemVer](http://semver.org) compatibility guarantee.


## [Platforms](/platform/)

{{< cutetable platform >}}


## [Devices](/device/)

{{< cutetable device >}}


# Tools

`periph` includes many [ready-to-use tools](/project/tools/):

```bash
go get periph.io/x/periph/cmd/...
# List the host drivers registered and/or initialized:
periph-info
# List the board headers:
headers-list
# List the state of each GPIO:
gpio-list
# Set P1_7/GPIO4 on a Raspberry Pi to high:
gpio-write P1_7 1
```


# Library

`periph` tries hard to get out of the way when [used as a
library](/project/library/).

[![GoDoc](/img/godoc.svg)](https://godoc.org/periph.io/x/periph)

Here's the minimal "toggle a LED" example:

~~~go
package main

import (
    "time"
    "periph.io/x/periph/conn/gpio"
    "periph.io/x/periph/conn/gpio/gpioreg"
    "periph.io/x/periph/host"
)

func main() {
    host.Init()
    p := gpioreg.ByName("11")
    t := time.NewTicker(500 * time.Millisecond)
    for l := gpio.Low; ; l = !l {
        p.Out(l)
        <-t.C
    }
}
~~~

Learn more [about GPIOs](/device/gpio/).


![boardimage](/img/lab-280.jpg)


# More infos

- Read the [source code](/project/#source-code).
- [Contribute](/project/contributing/) to the project.
- Learn about the [project philosophy](/project/goals/#philosophy).


# Contact

- [#periph](https://gophers.slack.com/messages/periph/) on gophers.slack.com.
  Request access at
  [invite.slack.golangbridge.org](https://invite.slack.golangbridge.org/)
- File issues at
  [github.com/google/periph/issues](https://github.com/google/periph/issues)


## Authors

`periph` was initiated with ❤️️ and passion by [Marc-Antoine
Ruel](https://github.com/maruel).  The full list of contributors is in
[AUTHORS](https://github.com/google/periph/blob/master/AUTHORS) and
[CONTRIBUTORS](https://github.com/google/periph/blob/master/CONTRIBUTORS).


## Disclaimer

This is not an official Google product (experimental or otherwise), it
is just code that happens to be owned by Google.

This project is not affiliated with the Go project.
