#!/usr/bin/env python
# Copyright 2018 The Periph Authors. All rights reserved.
# Use of this source code is governed under the Apache License, Version 2.0
# that can be found in the LICENSE file.

import collections
import datetime
import json
import os
import string
import subprocess
import sys
import urllib


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

This is a feature and bug fix release.

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
  """Run a git commands and returns lines as a list."""
  return subprocess.check_output(['git'] + cmd, *args, **kwargs).splitlines()


def select_range(repo):
  master = gitlines(['rev-parse', 'origin/master'], cwd=repo)[0]
  versions = gitlines(['tag'], cwd=repo)
  version = versions[-1]
  version_hash = gitlines(['rev-parse', version], cwd=repo)[0]
  if master != version_hash:
    print('WARNING: origin/master doesn\'t match %s; diffing this' % version)
    return master, version

  prev_version = versions[-2]
  print('Found version %s' % version)
  print('Comparing against version %s' % prev_version)
  return version, prev_version


def email_to_user(name, email):
  """Converts an email address to a github user name."""
  if email.endswith('@users.noreply.github.com'):
    return email.split('+')[1].split('@')[0]
  url = 'https://api.github.com/search/users?q=%s+in:email' % email
  data = json.load(urllib.urlopen(url))
  if 'message' in data:
    # TODO(maruel): We're getting rate limited.
    pass
  items = data.get('items')
  if items:
    login = items[0].get('login')
    if login:
      return login

  # Try to see if the name is the user account, it is the case occasionally.
  if set(name).issubset(string.ascii_letters + string.digits):
    resp = urllib.urlopen('https://github.com/' + name)
    if resp.getcode() == 200:
      # Hit!
      return name

  print('  Failed to get GitHub user name for %s', email)
  return email


# TODO(maruel): For each change, determine if the change touches a single
# package, if so, categorize it.
Commit = collections.namedtuple(
    'Commit', ['commit', 'author_name', 'account', 'title'])


def get_logs(prev_version, version, repo):
  """Get enriched logs.

  Returns:
    - list of Commit for each commit
    - dict of name to github user account
  """
  cmd = ['log', '--format=%H%x00%an%x00%ae%x00%s', '%s..%s' % (prev_version, version)]
  changes = []
  account_mapping = {'Marc-Antoine Ruel': 'maruel'}
  for l in gitlines(cmd, cwd=repo):
    commit, name, email, title = l.split('\x00', 3)
    account = None
    if email in ('maruel@gmail.com', 'maruel@chromium.org'):
      name = 'Marc-Antoine Ruel'
      account = 'maruel'
    elif email in account_mapping:
      account = account_mapping[email]
    else:
      account = email_to_user(name, email)
      account_mapping[name] = account
    changes.append(Commit(commit, name, account, title))
  changes.sort()
  return changes, account_mapping


def main():
  repo = os.path.join(os.environ['GOPATH'], 'src', 'periph.io', 'x', 'periph')
  version, prev_version = select_range(repo)
  diff_stat = gitlines(['diff', '--stat', prev_version], cwd=repo)[-1]
  changes, account_mapping = get_logs(prev_version, version, repo)

  authors = {}
  for change in changes:
    authors.setdefault(change.author_name, []).append(change.title)

  now = datetime.datetime.now()
  content = TXT % {
    'changes': '\n'.join('%s: %s' % (c.author_name, c.title) for c in changes),
    'date': str(now.date()),
    'diff_stat': diff_stat,
    'num_authors': len(authors),
    'num_changes': len(changes),
    'prev_version': prev_version,
    'thanks': '\n'.join(
        '- [%s](https://github.com/%s) contributed %d change%s.' % (
            author, account_mapping[author], len(titles),
            's' if len(titles) > 1 else '')
        for author, titles in sorted(authors.iteritems())),
    'version': version,
    'version_num': version[1:],
  }
  p = os.path.join('site', 'content', 'news', str(now.year), '%s.md' % version)
  d = os.path.dirname(p)
  if not os.path.isdir(d):
    os.makedirs(d)
  with open(p, 'wb') as f:
    f.write(content)
  print('Created %s' % p)
  return 0


if __name__ == '__main__':
  sys.exit(main())
