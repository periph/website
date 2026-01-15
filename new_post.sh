#!/usr/bin/env bash
# Copyright 2020 The Periph Authors. All rights reserved.
# Use of this source code is governed under the Apache License, Version 2.0
# that can be found in the LICENSE file.

# Create a new post.

set -eu
cd "$(dirname $0)"

YEAR="$(date +%Y)"
mkdir -p content/news/$YEAR
mkdir content/news/$YEAR/$1
mkdir content/news/$YEAR/$1/img
cat > content/news/$YEAR/$1/index.md <<EOF
+++
date = "$(date --iso-8601)T00:00:00"
title = "$1"
description = "TODO"
author = "Marc-Antoine Ruel"
authorlink = "https://maruel.ca"
tags = []
draft = true
+++
EOF

echo content/news/$YEAR/$1/index.md
vi content/news/$YEAR/$1/index.md
