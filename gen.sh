#!/bin/sh
# Copyright 2017 The Periph Authors. All rights reserved.
# Use of this source code is governed under the Apache License, Version 2.0
# that can be found in the LICENSE file.

set -eu

cd "$(dirname $0)"

## Preparation

# Remove any stale junk if any.
rm -rf root.old root.new

## Generation

# Do the generation of the static web site.
hugo -s src -d ../root.new
# Minify all the output in-place.
minify -r -o root.new root.new
# Precompress all the minified files, so caddy can serve pre-compressed files
# without having to compress on the fly, leading to zero-CPU static file
# serving.
find root.new -type f \( -name '*.html' -o -name '*.js' -o -name '*.css' -o -name '*.xml' -o -name '*.svg' \) -exec gzip -v -k -f --best {} \;

## Making it live

# Now that the new site is ready, switch the old site for the new one.
if [ -d root ]; then
  mv root root.old
fi
mv root.new root
rm -rf root.old
