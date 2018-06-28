+++
title = "Devices"
description = "Overview of supported devices"
+++

# Overview

`periph` primary focus is on [enablers](/project/#enablers), that is, host
drivers to provide bus APIs (I²C, 1-wire, SPI, etc) independent of the OS and
the board. Yet this is not useful if there is not at least a few device drivers
included!

You are encouraged to look at tools in
[cmd/](https://github.com/google/periph/tree/master/cmd/). These can be used as
the basis of your projects.

To try the example for each device, put the code into a file named `example.go`
then execute `go run example.go`.

# Devices
