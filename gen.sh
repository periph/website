#!/bin/sh
# Copyright 2017 The Periph Authors. All rights reserved.
# Use of this source code is governed under the Apache License, Version 2.0
# that can be found in the LICENSE file.

set -eu

cd "$(dirname $0)"

# This is the equivalent of:
#  hugo -s site -d ../www
#  minify -r -o www.new www.new
#  find www.new -type f \( -name '*.html' -o -name '*.js' -o -name '*.css' -o
#    -name '*.xml' -o -name '*.svg' \) \
#    -exec /bin/sh -c 'gzip -v -f -9 -c "$1" > "$1.gz"' /bin/sh {} \;
#  find www.new -type f \( -name '*.html' -o -name '*.js' -o -name '*.css' -o
#    -name '*.xml' -o -name '*.svg' \) \
#    -exec /bin/sh -c '/usr/local/bin/brotli -q 11 -o "$1.br" "$1"' /bin/sh {} \;
#
# See https://github.com/maruel/hugo-tidy/ for more infos.
#
# Don't forget to update resources/alt?.periph.io.conf and serve.sh.
TAG=marcaruel/hugo-tidy:hugo-0.42.2-alpine-3.7-brotli-1.0.5-minify-2.3.5
docker pull $TAG
docker run --rm -u $(id -u):$(id -g) -v $(pwd):/data $TAG
