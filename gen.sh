#!/usr/bin/env bash
# Copyright 2017 The Periph Authors. All rights reserved.
# Use of this source code is governed under the Apache License, Version 2.0
# that can be found in the LICENSE file.

set -eu
cd "$(dirname $0)"

echo "Tips:"
echo " - Use --buildDrafts to render drafts."

HUGO=hugo
if [ -x ./hugo ]; then
  HUGO=./hugo
elif ! which hugo > /dev/null; then
  echo "Please run ./rsc/install_hugo.py"
  exit 1
fi

echo "Using $HUGO"
$HUGO --buildFuture "$@"

echo ""
echo "  go install github.com/maruel/serve-dir@latest"
echo "  serve-dir -port=3131 -root=public"
echo "  then visit http://localhost:3131/"