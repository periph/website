#!/usr/bin/env bash
# Copyright 2017 The Periph Authors. All rights reserved.
# Use of this source code is governed under the Apache License, Version 2.0
# that can be found in the LICENSE file.

set -eu
cd "$(dirname $0)"

echo "Tips:"
echo " - Use --bind=0.0.0.0 to be accessible on the local network."
echo " - Use --buildDrafts to render drafts."

if (which hugo > /dev/null); then
  echo "Using hugo"
  hugo server -s site -d ../www --buildFuture -b $(hostname) --port 3131 "$@"
else
	echo "Please run ./rsc/install_hugo.py"
  exit 1
fi
