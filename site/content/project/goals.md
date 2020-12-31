+++
title = "Goals"
description = "Design goals"
+++


# Abstract

Go developped a fairly large hardware hacker community in part because the
language and its tooling have the following properties:

- Native support in the tool chain to cross compile to ARM/Linux via `GOOS=linux
  GOARCH=arm go build .`.
- Significantly faster to execute than python and node.js.
- Significantly lighter in term of memory use than Java or node.js.
- Significantly more productive to code than C/C++.
- Builds reasonably fast on ARM.
- Fairly good OS level support.

Many Go packages, both generic and specialized, were created to fill the space.
This library came out of the desire to have a _designed_ API (contrary to
growing organically) with strict [code requirements](../#requirements) and a
[strong, opinionated philosophy](../../../#philosophy) to enable long term
maintenance.


# Goals

`periph` was created as an anwer to specific goals:

- Not more abstract than absolutely needed. Use concrete types whenever
  possible.
- Orthogonality and composability
  - Each component must own an orthogonal part of the platform and each
    components can be composed together.
- Extensible:
  - Users can provide additional drivers that are seamlessly loaded
    with a structured ordering of priority.
- Performance:
  - Execution as performant as possible.
  - Overhead as minimal as possible, i.e. irrelevant driver are not be
    attempted to be loaded, uses memory mapped GPIO registers instead of sysfs
    whenever possible, etc.
- Coverage:
  - Be as OS agnostic as possible. Abstract OS specific concepts like
    [sysfs](https://periph.io/x/host/v3/sysfs).
  - Each driver implements and exposes as much of the underlying device
    capability as possible and relevant.
  - [cmd](https://github.com/periph/cmd/tree/main/) implements useful
    directly usable tool.
  - [devices](https://periph.io/x/devices/v3) implements common device
    drivers. Device drivers is not the core focus of this project for now.
  - [host](https://periph.io/x/host/v3) must implement a large base of
    common platforms that _just work_. This is in addition to extensibility.
- Simplicity:
  - Static typing is _thoroughly used_, to reduce the risk of runtime failure.
  - Minimal coding is needed to accomplish a task.
  - Use of the library is defacto portable.
  - Include fakes for buses and device interfaces to simplify the life of
    device driver developers.
- Stability
  - API must be stable without precluding core refactoring.
  - Breakage in the API should happen at a yearly parce at most once the library
    got to a stable state.
- Strong distinction about the driver (as a user of a
  [conn.Conn](https://periph.io/x/conn/v3#Conn) instance) and an application
  writer (as a user of a device driver). It's the _application_ that controls
  the objects' lifetime.
- Strong distinction between _enablers_ and _devices_. See
  [Background](../#background).


# Philosophy

The project was designed with a very clear vision:

1. Optimize for simplicity, correctness and usability in that order.
   - e.g. everything, interfaces and structs, uses strict typing, there's no
     `interface{}` in sight.
2. OS agnostic. Clear separation of interfaces in
   [conn](https://periph.io/x/conn/v3),
   enablers in [host](https://periph.io/x/host/v3) and device
   drivers in [devices](https://periph.io/x/devices/v3).
   - e.g. no devfs or sysfs path in sight.
   - e.g. conditional compilation enables only the relevant drivers to be loaded
     on each platform.
3. ... yet doesn't get in the way of platform specific code.
   - e.g. A user can use statically typed global variables
     [rpi.P1_3](https://periph.io/x/host/v3/rpi#P1_3),
     [bcm283x.GPIO2](https://periph.io/x/host/v3/bcm283x#GPIO2)
     to refer to the exact same pin on a Raspberry Pi.
3. The user can chose to optimize for performance instead of usability.
   - e.g.
     [apa102.Dev](https://periph.io/x/devices/v3/apa102#Dev)
     exposes both high level
     [draw.Image](https://golang.org/pkg/image/draw/#Image) to draw an image and
     low level [io.Writer](https://golang.org/pkg/io/#Writer) to write raw RGB
     24 bits pixels. The user chooses.
4. Use a divide and conquer approach. Each component has exactly one
   responsibility.
   - e.g. instead of having a driver per "platform", there's a driver per
     "component": one for the CPU, one for the board headers, one for each
     bus and sensor, etc.
5. Extensible via a [driver
   registry](https://periph.io/x/conn/v3/driver/driverreg#Register).
   - e.g. a user can inject a custom driver to expose more pins, headers, etc.
     A USB device (like an FT232H) can expose headers _in addition_ to the
     headers found on the board.
6. The drivers must use the fastest possible implementation.
   - e.g. both [allwinner](https://periph.io/x/host/v3/allwinner) and
     [bcm283x](https://periph.io/x/host/v3/bcm283x) leverage [sysfs
     gpio](https://periph.io/x/host/v3/sysfs#Pin) to expose interrupt driven
     edge detection, yet use memory mapped GPIO registers to perform
     single-cycle reads and writes.


# Success criteria

- Preferred library used by first time Go users and by experts.
- Becomes the defacto HAL library.
- Becomes the central link for hardware support.


# Risks

The risks below are being addressed via a strong commitment to [driver lifetime
management](../#driver-lifetime-management) and having a high quality bar via an
explicit list of [requirements](../#requirements).

The enablers (boards, CPU, buses) is what will break or make this project.
Nobody want to do them but they are needed. You need a large base of enablers so
people can use anything yet they are hard to get right. You want them all in the
same repo so that when someone builds an app, it supports everything
transparently. It just works.

The device drivers do not need to all be in the same repo, that scales since
people know what is physically connected, but a large enough set of enablers is
needed to be in the base repository to enable seemlessness. People do not care
that a Pine64 has a different processor than a Rasberry Pi; both have the same
40 pins header and that's what they care about. So enablers need to be a great
HAL -> the right hardware abstraction layer (not too deep, not too light) is the
core here.


## Users

- The library is rejected by users as being too cryptic or hard to use.
- The device drivers are unreliable or non functional, as observed by users.
- Poor usability of the core interfaces.
- Missing drivers.


## Contributors

- Lack of API stability; high churn rate.
- Poor fitting of the core interfaces.
- No uptake in external contribution.
- Poor quality of contribution.
- Duplicate ways to accomplish the same thing, without a clear way to define the
  right way.
