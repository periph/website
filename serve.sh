#!/bin/sh
# Copyright 2017 The Periph Authors. All rights reserved.
# Use of this source code is governed under the Apache License, Version 2.0
# that can be found in the LICENSE file.

set -eu

cd "$(dirname $0)"

# This is the equivalent of:
#  hugo -s site -d ../www server --bind=0.0.0.0 -w -b $(hostname) --port 3131
#
# See https://github.com/maruel/hugo-tidy/ for more infos.
#
TAG=marcaruel/hugo-tidy:hugo-0.42.2-alpine-3.7-brotli-1.0.5-minify-2.3.5
docker pull $TAG
docker run -t --rm -u $(id -u):$(id -g) -v $(pwd):/data --network=host $TAG --bind=0.0.0.0 -w -b $(hostname) --port 3131
