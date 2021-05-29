#!/usr/bin/env python3
# Copyright 2018 The Periph Authors. All rights reserved.
# Use of this source code is governed under the Apache License, Version 2.0
# that can be found in the LICENSE file.

"""Generates a new periph.io release blog post."""

import argparse
import collections
import datetime
import json
import logging
import os
import string
import subprocess
import sys
import time
import urllib.request


TXT = """+++
date = "%(date)s"
title = "Announcing %(version)s"
author = "Marc-Antoine Ruel"
authorlink = "https://maruel.ca"
description = "TODO"
tags = []
notruncate = false
+++

[Version %(version_num)s](https://github.com/periph/host/releases/tag/%(version)s) is
released!

This is a feature and bug fix release.

<!--more-->

The new release contains [%(num_changes)d
changes](https://github.com/periph/host/compare/%(prev_version)s...%(version)s)
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
  [github.com/periph/host/issues](https://github.com/periph/host/issues).
- Join the [periph.io slack channel](https://gophers.slack.com/messages/periph/)
  to chat with us!
  - Need an account? [Get an invite
    here](http://invite.slack.golangbridge.org/).

Follow [twitter.com/periphio](https://twitter.com/periphio) for news and
updates!
"""

BACKOFF = 0

def urlopen(*args, **kwargs):
  global BACKOFF
  if not BACKOFF:
    BACKOFF = 1
  else:
    logging.debug('sleeping %gs', BACKOFF)
    time.sleep(BACKOFF)
    BACKOFF += 0.25
  while True:
    try:
      return urllib.request.urlopen(*args, **kwargs)
    except urllib.error.HTTPError:
      logging.warning('Backing off more')
      time.sleep(2*BACKOFF)
      continue


def gitlines(cmd, *args, **kwargs):
  """Run a git commands and returns lines as a list."""
  cmd = ['git'] + cmd
  logging.debug('%s', cmd)
  return subprocess.check_output(
      cmd, *args, **kwargs).decode('utf-8').splitlines()


def select_range(repo):
  main = gitlines(['rev-parse', 'origin/main'], cwd=repo)[0]
  versions = gitlines(['tag'], cwd=repo)
  version = versions[-1]
  version_hash = gitlines(['rev-parse', version], cwd=repo)[0]
  if main != version_hash:
    logging.warning('origin/main doesn\'t match %s; diffing this', version)
    return main, version

  prev_version = versions[-2]
  return version, prev_version


def email_to_user(name, email):
  """Converts an email address to a github user name."""
  if email.endswith('@users.noreply.github.com'):
    parts = email.split('+', 2)
    user = parts[-1].split('@')[0]
    logging.info('email_to_user(%s, %s) -> %s', name, email, user)
    return user

  url = 'https://api.github.com/search/users?q=%s+in:email' % email
  data = json.load(urlopen(url))
  if 'message' in data:
    logging.error('getting rate limited')
  items = data.get('items')
  if items:
    user = items[0].get('login')
    if user:
      logging.info('email_to_user(%s, %s) -> %s', name, email, user)
      return user

  # Try to see if the name is the user account, it is the case occasionally.
  if set(name).issubset(string.ascii_letters + string.digits):
    time.sleep(2)
    resp = urlopen('https://github.com/' + name)
    if resp.getcode() == 200:
      # Hit!
      logging.info('email_to_user(%s, %s) -> %s', name, email, name)
      return name

  logging.warning('email_to_user(%s, %s) Failed to get GitHub user name', name, email)
  return None


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
  for i, l in enumerate(gitlines(cmd, cwd=repo)):
    commit, name, email, title = l.split('\x00', 3)
    logging.debug('%d. %s %s %s', i, name, email, title)
    account = None
    if email in ('maruel@gmail.com', 'maruel@chromium.org'):
      name = 'Marc-Antoine Ruel'
      account = 'maruel'
    elif name in account_mapping:
      account = account_mapping[name]
    else:
      account = email_to_user(name, email)
      account_mapping[name] = account
    changes.append(Commit(commit, name, account, title))
  changes.sort()
  return changes, account_mapping


def author_thanks(author, user, count):
  suffix = 's' if count > 1 else ''
  if user:
    return '- [%s](https://github.com/%s) contributed %d change%s.' % (
        author, user, count, suffix)
  return '- %s contributed %d change%s.' % (author, count, suffix)


def main():
  parser = argparse.ArgumentParser(description=sys.modules[__name__].__doc__)
  parser.add_argument('--verbose', '-v', action='store_true')
  parser.add_argument('--from', dest='from_version', help='Override the base revision, e.g. v3.6.2')
  args = parser.parse_args()
  logging.basicConfig(level=logging.DEBUG if args.verbose else logging.WARNING)

  gopath = os.environ.get('GOPATH') or os.path.expanduser(os.path.join('~', 'go'))
  repo = os.path.join(gopath, 'src', 'periph.io', 'x', 'periph')
  version, prev_version = select_range(repo)
  if args.from_version:
    prev_version = args.from_version
  print('Found version %s' % version)
  print('Comparing against version %s' % prev_version)
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
        author_thanks(author, account_mapping[author], len(titles))
        for author, titles in sorted(authors.items())),
    'version': version,
    'version_num': version[1:],
  }
  p = os.path.join('site', 'content', 'news', str(now.year), '%s.md' % version)
  d = os.path.dirname(p)
  if not os.path.isdir(d):
    os.makedirs(d)
  with open(p, 'w') as f:
    f.write(content)
  print('Created %s' % p)
  return 0


if __name__ == '__main__':
  sys.exit(main())
