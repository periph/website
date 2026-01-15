+++
title = "Contributing"
description = "Want to contribute? Great!"
+++


# Before you contribute

Before we can use your code, you must sign the [Google Individual Contributor
License Agreement](https://cla.developers.google.com/about/google-individual)
(CLA), which you can do online. The CLA is necessary mainly because you own the
copyright to your changes, even after your contribution becomes part of our
codebase, so we need your permission to use and distribute your code. We also
need to be sure of various other things—for instance that you'll tell us if you
know that your code infringes on other people's patents.

You don't have to sign the CLA until after you've submitted your code for review
and a member has approved it, but you must do it before we can put your code
into our codebase.  Before you start working on a larger contribution, you
should get in touch with us first through the issue tracker with your idea so
that we can help out and possibly guide you. Coordinating up front makes it much
easier to avoid frustration later on.


# Code reviews

All submissions, including submissions by project members, require review. The
`periph` project uses Github pull requests for this purpose.

`periph` provides an extensible driver registry and common bus interfaces.
`periph` is designed to work well with drivers living in external packages so it
is fine to start device drivers in your own repository.


# Code quality

All submissions, including submissions by project members, require abiding to
high code quality. See [Requirements](../#requirements) for the
expectations. Contributions need to pass the GitHub actions checks and must not
introduce flaky tests.


# Testing

The `periph` project uses both GitHub Actions for generic linux/macOS/Windows
testing and [gohci](https://github.com/periph/gohci) for automated testing on
devices. The devices run unit tests and
[periph-smoketest](https://github.com/periph/cmd/tree/periph-smoketest).

**Every commit is tested on real hardware via
[gohci](https://github.com/periph/gohci) workers.**

The fleet currently is currently hosted by [maruel](https://github.com/maruel):

- [BeagleBone](/platform/beaglebone/) Green Wireless
- [ODROID-C1+](/platform/odroid-c1/)
- [Raspberry Pi 3](/platform/raspberrypi/) running [Raspbian Buster 
  Lite](https://www.raspberrypi.org/downloads/raspbian/)
- [macOS](/platform/macos/) laptop
- [Windows 10](/platform/windows/) laptop

Tests must not be broken by a PR.


# Conduct

While this project is not related to the Go project itself, `periph` abides to
the same code of conduct as the Go project as described at
https://golang.org/conduct. `periph` doesn't yet have a formal committee, please
email directly `conduct@maruel.ca` for issues encountered.


# The small print

Contributions made by corporations are covered by a different agreement than
the one above, the [Software Grant and Corporate Contributor License
Agreement](https://cla.developers.google.com/about/google-corporate).
