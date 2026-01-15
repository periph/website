+++
title = "periph"
description = "Peripherals I/O in Go"
+++

![boardimage](/img/periph-mascot-280.png)

# Overview

Periph is a standalone hardware library with limited external dependencies.


# Features

- No external dependencies.
- No C dependency, doesn't use `cgo`.
- Explicit initialization: know what [hardware is detected and what is
  not](https://github.com/periph/cmd/tree/main/periph-info).
- [Interfaces](https://periph.io/x/conn/v3):
  [GPIO](https://periph.io/x/conn/v3/gpio) (with edge detection),
  [I²C](https://periph.io/x/conn/v3/i2c),
  [SPI](https://periph.io/x/conn/v3/spi),
  [1-wire](https://periph.io/x/conn/v3/onewire).
- [Continuously tested](/project/contributing/#testing) via
  [gohci](https://github.com/periph/gohci).
- [SemVer](https://semver.org) compatibility guarantee.


## [Platforms](/platform/)

{{< cutetable platform >}}


## [Devices](/device/)

{{< cutetable device >}}


# Tools

`periph` includes many [ready-to-use tools](/project/tools/):

```bash
go get periph.io/x/cmd/...
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

Here's the minimal "toggle a LED" example:

~~~go
package main

import (
    "time"
    "periph.io/x/conn/v3/gpio"
    "periph.io/x/conn/v3/gpio/gpioreg"
    "periph.io/x/host/v3"
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
Ruel](https://github.com/maruel).  The full list of contributors is in AUTHORS
and CONTRIBUTORS in each repository.


## Disclaimer

This is not an official Google product (experimental or otherwise), it
is just code that happens to be owned by Google.

This project is not affiliated with the Go project.


