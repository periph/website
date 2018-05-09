#!/bin/sh
# Copyright 2017 The Periph Authors. All rights reserved.
# Use of this source code is governed under the Apache License, Version 2.0
# that can be found in the LICENSE file.

set -eu

cd "$(dirname $0)"

TAG=marcaruel/hugo-tidy:hugo-0.40.3-alpine-3.7-brotli-1.0.4
docker pull $TAG
docker run --rm -u $(id -u):$(id -g) -v $(pwd):/data $TAG
