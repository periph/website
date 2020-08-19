+++
date = "2018-05-02"
title = "gohci got an upgrade"
author = "Marc-Antoine Ruel"
authorlink = "https://maruel.ca"
description = "The free CI system for your little computers"
tags = []
notruncate = false
+++

Since [my](https://maruel.ca) day job is working on [continuous integration
systems
(CI)](https://chromium.googlesource.com/infra/luci/luci-py/+/master/appengine/swarming/doc/Design.md),
when I started [periph.io](https://periph.io) I really wanted to have a strong
testing system to make sure regressions wouldn't go undetected.

The challenge is that first, I'm cheap, and second, I needed it to run tests on
my Raspberry Pis, macOS and Windows machines without any maintenance, both
before and after accepting PRs.

On one Sunday afternoon in November 2016, I hacked up what eventually became
[gohci](https://github.com/periph/gohci/).

<!--more-->

The requirements are simple: it needs to be specialized for Go projects, like
native support for [canonical import
path](https://golang.org/doc/go1.4#canonicalimports), run on all the platforms
supported by periph.io, be lightweight so it would run well on a single core
system with 512Mb of RAM like a [BeagleBone](https://beagleboard.org/) or a
[C.H.I.P.](https://getchip.com/), be free, and without servers to maintain.

What hit me on that Sunday is that [GitHub gists](https://gist.github.com/) are
free, can contain multiple 'files' and a GitHub [machine
account](https://help.github.com/articles/github-terms-of-service/#2-account-requirements)
can do [5000 requests per hour](https://developer.github.com/v3/#rate-limiting),
including sending commit status updates. That's all that was needed to start the
initial prototype.

![screen cast](/gohci.gif "screen cast")

The end result is something that can conceptually thought of similar to
[Travis](https://travis-ci.com/), except that instead of specifying a single set
of commands to run that is run on a linux VM that is provided by them, you
specify one set of commands to run _per worker_, and _you_ provide your own
workers.

This enables running completely different smoke tests on different hardware. For
example I have [tester boards](https://github.com/periph/periph-tester)
(created by the amazing [tve](https://github.com/tve)) on many of the micro
computer, which is tested via `periph-smoketest *-testboard` smoketests. We run
GPIO performance benchmarks. The Windows gohci worker has a
[FT232H](https://www.adafruit.com/product/2264) which is tested specifically,
and the MacBookPro has a [FT232R](https://www.adafruit.com/product/70).

This results in files like
[periph/.gohci.yml](https://github.com/google/periph/blob/master/.gohci.yml) and
[extra/.gohci.yml](https://github.com/periph/extra/blob/master/.gohci.yml) which
contain specialized checks, based on the specific needs of the project.

Worker configuration is really simple, upon its initial execution,
`gohci-worker` writes a `gohci.yml` file that contains everything needed except
the machine account OAuth2 access token. You fill it in, front the worker via an
HTTPS proxy like [caddy](https://caddyserver.com/) and you're good to go.

To start getting checks to run, add a webhook to each GitHub repositories you
want to tests, one webhook per worker. You create M x N webhooks, for M
repositories for N workers. And you're up and running!

The test result [looks like
this](https://gist.github.com/gohci-bot/21d9e018641d9c24d37115324979d6ab), in
this case it ran on Windows 10 and tested that a FT232H is working correctly.

Questions? See the [FAQ](https://github.com/periph/gohci/blob/master/FAQ.md).

Want to learn more? See the [configuration
documentation](https://github.com/periph/gohci/blob/master/CONFIG.md).

Comments? Join the [periph.io slack
channel](https://gophers.slack.com/messages/periph/). Need an account? [Get an
invite](http://invite.slack.golangbridge.org/).
