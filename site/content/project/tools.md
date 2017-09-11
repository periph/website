+++
title = "Tools"
description = "Overview for users who want ready-to-use tools"
+++


# Batteries included

[github.com/google/periph/cmd](https://github.com/google/periph/tree/master/cmd/)
contains all the tools directly usable as-is. The README.md in this page
contains an overview of all the tools usable per category. Take a look first to
see what you can leverage.


# Overview

The `periph` project doesn't release binaries at the moment, you are expected to
build from sources.


## Prerequisite

First, make sure to have [Go installed](https://golang.org/dl/).


## Installation

It is done via:

```bash
go get -u periph.io/x/periph/cmd/...
```

On many platforms (board/OS combination), many tools requires running as root
(via _sudo_) to have access to the necessary CPU GPIO registers or even just
kernel exposed APIs.


## Cross-compiling

To have faster builds, you may wish to build on a desktop and send the
executables to your ARM based micro computer (e.g. Raspberry Pi) especially for
slower single core boards (Beaglebone, C.H.I.P.), with low amount of flash
usable (C.H.I.P. Pro) or when using a distribution that doesn't allow installing
packages (buildroot).

[push.sh](https://github.com/google/periph/blob/master/cmd/push.sh) is included
to wrap this:

```bash
cd $GOPATH/src/periph.io/x/periph/cmd
./push.sh raspberrypi bmxx80
```

It is basically a wrapper around `GOOS=linux GOARCH=arm go build .; scp <exe>
<host>:.`


# Configuring the host

See [/platform/](/platform/) for supplemental information to configure the host
to leverage as much functionalities as possible.
