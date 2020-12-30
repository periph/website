+++
date = "2020-12-30T00:00:00"
title = "A new start"
description = "A new layout for Go modules"
author = "Marc-Antoine Ruel"
authorlink = "https://maruel.ca"
tags = []
+++

The project is having a make over!

Not only are we leaving 2020 behind, we are also leaving periph.io/x/periph behind.

<!--more-->

The monolithical git repository
[github.com/google/periph](https://github.com/google/periph) is now split up in
multiple smaller git repositories.

*   [github.com/periph/conn](https://github.com/periph/conn)
*   [github.com/periph/cmd](https://github.com/periph/cmd)
*   [github.com/periph/devices](https://github.com/periph/devices)
*   [github.com/periph/host](https://github.com/periph/host)

## TL;DR

The translation is:

*   periph.io/x/**periph**/conn/... 🠲 periph.io/x/conn/**v3**/...
*   periph.io/x/**periph**/devices/... 🠲 periph.io/x/devices/**v3**/...
*   periph.io/x/**periph**/host/... 🠲 periph.io/x/host/**v3**/...
*   periph.io/x/**periph**/cmd/... 🠲 periph.io/x/cmd/...
*   periph.io/x/**periph** 🠲 periph.io/x/conn/**v3/driver/driverreg**

To simplify the transition, no API was changed.

periph.io/x/periph will continue working but will not be updated anymore.

The new packages require go1.13 or later.

## Migration guide

Run the following in bash in your repository:

```
git ls-files -z -- . | xargs -0 -L 1 sed -i 's#periph\.io/x/periph/conn#periph.io/x/conn/v3#g'
git ls-files -z -- . | xargs -0 -L 1 sed -i 's#periph\.io/x/periph/experimental/conn#periph.io/x/conn/v3#g'
git ls-files -z -- . | xargs -0 -L 1 sed -i 's#periph\.io/x/periph/host#periph.io/x/host/v3#g'
git ls-files -z -- . | xargs -0 -L 1 sed -i 's#periph\.io/x/periph/devices#periph.io/x/devices/v3#g'
git ls-files -z -- . | xargs -0 -L 1 sed -i 's#periph\.io/x/periph/experimental/devices#periph.io/x/devices/v3#g'
git ls-files -z -- "*.go" | xargs -0 -L 1 sed -i 's#([^a-zA-Z])periph\.([A-Z])#\1driverreg.\2#g'
git checkout HEAD -- go.mod go.sum
go mod tidy
go test ./...
```

Having issues? Please reach out on the slack channel and we'll update the
instructions. Thanks!

## Why

If you've read this far, you're likely interested in the rationale. Here's the
goals:

* Support Go modules without using "multi-modules". I experimented with
  multi-modules and the ergonomics are not good.
* Use the same version in the new repositories than in the current one to not
  have version mismatch. It would have been weird if conn/v1 were equivalent to
  the old periph at v3.
* Go modules refuses /v0 and /v1 in the go module path, and starting with
	v3 makes all the imports use a version number right away. It has two
	purposes:
  * It helps disambiguate quickly when looking at imports to see if the
    old periph.io/x/periph path is used or the new ones.
  * Since it's versioned already, it'll make bumping to v4 and later
    easier to search-and-replace.
* Unlike the other repositories, cmd is not versioned to have "go get
  periph.io/x/cmd/..." working as expected. This could change in the future but
  this is not planned for now.
* Get rid of the experimental/ directories. It is possible now that conn, host,
  devices and cmd are versioned independently. This should make the life easier
  for everyone. The "experimental/ to official" flow was not working in
  practice.
* I used the occasion to use 'main' instead of 'master' as the primary branch.

## Follow ups

The website will have all its documentation updated. Help is immensely
appreciated! Click on "Edit this page" link on the top of any page to create a
PR.

extra will be migrated later. Periph prided itself from not having external
dependencies but this will change (regress?). This should be easier to manage
now that periph is a proper go modules compatible project. Merging extra will
likely result in a host/v4 release.

GitHub issues will be manually migrated to the relevant repository.
