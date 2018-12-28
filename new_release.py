#!/usr/bin/env python
# Copyright 2018 The Periph Authors. All rights reserved.
# Use of this source code is governed under the Apache License, Version 2.0
# that can be found in the LICENSE file.

import datetime
import os
import subprocess
import sys


TXT = """+++
date = "%(date)s"
title = "Announcing %(version)s"
author = "Marc-Antoine Ruel"
authorlink = "https://maruel.ca"
description = "TODO"
tags = []
notruncate = false
+++

[Version %(version_num)s](https://github.com/google/periph/releases/tag/%(version)s) is
released!

This is a feature and bug fix update.

<!--more-->

The new release contains [%(num_changes)d
changes](https://github.com/google/periph/compare/%(prev_version)s...%(version)s)
from %(num_authors)d contributors for a diff stat of `%(diff_stat)s`.


%(changes)s


## New packages

- [ABC](https://periph.io/x/periph/devices/ABC): was promoted from
  experimental.


## Improvements

- [ABC](https://periph.io/x/periph/devices/ABC): now works.


## Special thanks

Thanks to:

%(thanks)s

I ([@maruel](https://github.com/maruel)) did the rest, including the release
process and the [gohci test lab](https://github.com/periph/gohci).


## Found bugs? Have questions?

- File a report at
  [github.com/google/periph/issues](https://github.com/google/periph/issues).
- Join the [periph.io slack channel](https://gophers.slack.com/messages/periph/)
  to chat with us!
  - Need an account? [Get an invite
    here](https://invite.slack.golangbridge.org/).

Follow [twitter.com/periphio](https://twitter.com/periphio) for news and
updates!
"""


def gitlines(cmd, *args, **kwargs):
  return subprocess.check_output(['git'] + cmd, *args, **kwargs).splitlines()


def main():
  # TODO(maruel): Natural sorting.
  repo = os.path.join(os.environ['GOPATH'], 'src', 'periph.io', 'x', 'periph')
  versions = gitlines(['tag'], cwd=repo)
  version = versions[-1]
  print('Found version %s' % version)
  prev_version = versions[-2]
  print('Comparing against version %s' % prev_version)
  diff_stat = gitlines(['diff', '--stat', prev_version], cwd=repo)[-1]
  changes = gitlines(
      ['log', '--format=%an: %s', '%s..%s' % (prev_version, version)], cwd=repo)
  changes.sort()
  num_changes = len(changes)

  # Explicitly try to handle if there's ever a ':' in one of the names.
  authors = set(gitlines(
      ['log', '--format=%an', '%s..%s' % (prev_version, version)], cwd=repo))
  authors = {n:0 for n in authors}
  # O(n^2)
  for c in changes:
    for n in authors:
      if c.startswith(n+': '):
        authors[n] += 1
        break

  now = datetime.datetime.now()
  content = TXT % {
    'changes': '\n'.join(changes),
    'date': str(now.date()),
    'diff_stat': diff_stat,
    'num_authors': len(authors),
    'num_changes': num_changes,
    'prev_version': prev_version,
    'thanks': '\n'.join(
        '- %s contributed %d change%s.' % (n, c, 's' if len(c) > 1 else '')
        for n, c in sorted(authors.iteritems())),
    'version': version,
    'version_num': version[1:],
  }
  p = os.path.join('site', 'content', 'news', str(now.year), '%s.md' % version)
  with open(p, 'wb') as f:
    f.write(content)
  return 0


if __name__ == '__main__':
  sys.exit(main())
