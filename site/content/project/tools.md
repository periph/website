+++
title = "Tools"
description = "Overview for users who want ready-to-use tools"
+++


# Batteries included

[periph.io/x/periph/cmd](https://github.com/google/periph/tree/master/cmd/)
contains executables usable as-is.

The `periph` project doesn't release binaries at the moment, you are expected to
build from sources.


## Prerequisite

First, make sure to have [Go installed](https://golang.org/dl/). If you don't
mind using an old Go version, you can use `sudo apt install golang`. `periph`
tries to stay compatible with Go 1.5.3.


## Installation

It is done via:

```bash
go get -u periph.io/x/periph/cmd/...
```

To use [periph.io/x/extra](https://periph.io/x/extra) provided packages, use:
```
go get -tags periphextra -u periph.io/x/periph/cmd/...
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
push -host raspberrypi periph.io/x/periph/cmd/bmxx80
```


# Configuring the host

See [/platform/](/platform/) for supplemental information to configure the host
to leverage as much functionalities as possible.
