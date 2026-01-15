+++
title = "Project"
description = "Design, contribution, driver writing"
+++


# Background

`periph` provides interfaces to assemble components to communicate with hardware
peripherals. It is designed to be composable. As such, it splits boards into
their individual components: CPU, buses, physical headers, etc, instead of
representing each board as a whole object.


## References

- [Goals](goals/) to understand the project rationale.
- [Detailed Design](design/) to understand more about how things are done.


# Source Code

The main periph code is located in repositories at
[github.com/periph](https://github.com/periph):

- [conn](https://github.com/periph/conn) defines the base interfaces.
- [host](https://github.com/periph/host) implements the drivers for the
  peripheral on the host, e.g. the SPI/I²C buses.
- [devices](https://github.com/periph/devices) implements device drivers for
  things connected over the buses.
- [cmd](https://github.com/periph/cmd) contains ready-to-use executables.

Supplemental projects are:

- The [website](https://github.com/periph/website) itself, so you can easily
  submit a PR to improve the documentation.
- [gohci](https://github.com/periph/gohci) for hardware smoke testing.
- [periph-tester](https://github.com/periph/periph-tester) which is a board used
  to confirm the buses (I²C, SPI, 1-wire) are correctly working.
- [bootstrap](https://github.com/periph/bootstrap) tool to automate the
  deployment of Raspberry Pis.


# Classes of hardware

This document distinguishes two classes of drivers.


## Enablers

They are what make the interconnects work, so that you can then use real stuff.
That's both point-to-point connections (GPIO, UART, TCP) and buses (I²C, SPI,
BT) where individual devices can be addressed. They enable you to do something
but are not the essence of what you want to do.


## Devices

They are the end goal, to do something functional. There are multiple subclasses
of devices like sensors, output devices, etc.


# Requirements

All the code must fit the following requirements.

**Fear not!** We know the list _is_ daunting but as you create your pull request
to add something we'll happily guide you in the process to help improve the code
to meet the expected standard. The end goal is to write *high quality
maintainable code* and use this as a learning experience.

- The code must be Go idiomatic.
  - Constructor `NewXXX()` returns an object of concrete type.
  - Functions accept interfaces.
  - Leverage standard interfaces like
    [io.Writer](https://golang.org/pkg/io/#Writer) and
    [image.Image](https://golang.org/pkg/image/#Image) where possible.
  - No `interface{}` unless strictly required.
  - Minimal use of factories except for protocol level registries.
  - No `init()` code that accesses peripherals on process startup. These belong
    to [Driver.Init()](https://periph.io/x/conn/v3/driver#Impl).
- Exact naming
  - Driver for a chipset must have the name of the chipset or the chipset
    family. Don't use `oleddisplay`, use `ssd1306`.
  - Driver must use the real chip name, not a marketing name by a third party.
    Don't use `dotstar` (as marketed by Adafruit), use `apa102` (as created
    by APA Electronic co. LTD.).
  - A link to the datasheet must be included in the package doc unless NDA'ed
    or inaccessible.
- Testability
  - Code must be testable and unit tested without a device. The unit tests are
    meant to run as part of `go test`.
  - When relevant, include a smoke test. The smoke test tests a real device to
    confirm the driver physically works for devices. It must be under the
    package being tested, named as `foosmoketest` for package `foo`. Modify
    [periph-smoketests/](https://github.com/periph/cmd/tree/main/periph-smoketests/)
    to expose this smoke test.
- Usability
  - Provide a standalone executable in
    [cmd/](https://github.com/periph/cmd/tree/main/) to expose the
    functionality.  It is acceptable to only expose a small subset of the
    functionality but _the tool must have purpose_.
  - Provide a `func Example()` along your test to describe basic usage of your
    driver. See the official [testing
    package](https://golang.org/pkg/testing/#hdr-Examples) for more details.
- Performance
  - Drivers controlling an output device must have a fast path that can be used
    to directly write in the device's native format, e.g.
    [io.Writer](https://golang.org/pkg/io/#Writer).
  - Drivers controlling an output device must have a generic path accepting
    a higher level interface when found in the stdlib, e.g.
    [image.Image](https://golang.org/pkg/image/#Image).
  - Floating point arithmetic should only be used when absolutely necessary in
    the driver code. Most of the cases can be replaced by fixed point
    arithmetic, for example
    [physic](https://periph.io/x/conn/v3/physic).
    Floating point arithmetic is acceptable in the unit tests and tools in
    [cmd/](https://github.com/periph/cmd/tree/main/) but should not be
    abused.
  - Drivers must be implemented with performance in mind. For example I²C
    operations should be batched to minimize overhead.
  - Benchmark must be implemented for non trivial processing running on the
    host.
- Code must compile on all OSes, with minimal use of OS-specific thunk as
  strictly needed. Take advantage of constructs like `if isArm { ...}` where the
  conditional is optimized away at compile time via dead code elimination
  and `isArm` is a boolean constant defined in relevant .go files having a build
  constraint.
- Struct implementing an interface must validate at compile time with `var _
  <Interface> = &<Type>{}`.
- License is Apache v2.0.


# Code style

- The code tries to follow Go code style as described at
  [github.com/golang/go/wiki/CodeReviewComments](https://github.com/golang/go/wiki/CodeReviewComments)
- Top level comments are expected to be wrapped at 80 cols. Indented comments
  should be wrapped at reasonable width.
- Comments should start with a capitalized letter and end with a period.
- Markdown style is a "try to have similar style to the current doc".
