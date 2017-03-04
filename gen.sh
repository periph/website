#!/bin/sh
# Copyright 2017 The Periph Authors. All rights reserved.
# Use of this source code is governed under the Apache License, Version 2.0
# that can be found in the LICENSE file.

set -eu

cd "$(dirname $0)"

# Start clean, so files do not accumulate.
rm -rf root
# Copy all the documentation from <repo>/doc into src/content/doc
rsync -r --delete periph/doc src/content
# Rename all README.md files (default served by github) to index.md (default
# served by hugo).
find src/content/doc -type f -name README.md -exec bash -c 'mv "$0" "${0/README/index}"' {} \;
# Do the generation of the static web site.
hugo -s src -d ../root
# Precompress all the files, so caddy can serve pre-compressed files without
# having to compress on the fly, leading to zero-CPU static file serving.
find root -type f \( -name '*.html' -o -name '*.js' -o -name '*.css' -o -name '*.xml' -o -name '*.svg' \) -exec gzip -v -k -f --best {} \;
