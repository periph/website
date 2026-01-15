+++
title = "Tools"
description = "Overview for users who want ready-to-use tools"
+++


# Batteries included

[periph.io/x/cmd](https://github.com/periph/cmd/tree/main/)
contains executables usable as-is.

You are expected to build them from sources.


## Prerequisite

First, make sure to have [Go installed](https://golang.org/dl/). If you don't
mind using an old Go version, you can use `sudo apt install golang`. `periph`
tries to stay compatible with Go 1.13.15.


## Installation

It is done via:

```bash
go get -u periph.io/x/cmd/...
```

On many platforms (board/OS combination), many tools requires running as root
(via _sudo_) to have access to the necessary CPU GPIO registers or even just
kernel exposed APIs.


## Cross-compiling

To have faster builds, you may wish to build on a desktop and send the
executables to your ARM based micro computer. The companion tool
[periph.io/x/bootstrap/cmd/push](https://periph.io/x/bootstrap/cmd/push) helps
you with this:

```bash
go get -u periph.io/x/bootstrap/cmd/push
push -host raspberrypi periph.io/x/cmd/bmxx80
```


# Configuring the host

See [/platform/](/platform/) for supplemental information to configure the host
to leverage as much functionalities as possible.
