#!/bin/bash
# Copyright 2020 The Periph Authors. All rights reserved.
# Use of this source code is governed under the Apache License, Version 2.0
# that can be found in the LICENSE file.

# Create a new post.

set -eu
cd "$(dirname $0)"

YEAR="$(date +%Y)"
mkdir -p site/content/news/$YEAR
mkdir site/content/news/$YEAR/$1
mkdir site/content/news/$YEAR/$1/img
cat > site/content/news/$YEAR/$1/index.md <<EOF
+++
date = "$(date --iso-8601)T00:00:00"
title = "$1"
summary = "TODO"
tags = []
draft = true
+++
EOF

echo site/content/news/$YEAR/$1/index.md
vi site/content/news/$YEAR/$1/index.md
