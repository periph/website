#!/bin/sh
# Copyright 2017 The Periph Authors. All rights reserved.
# Use of this source code is governed under the Apache License, Version 2.0
# that can be found in the LICENSE file.

set -eu

cd "$(dirname $0)"

docker run --rm -u $(id -u):$(id -g) -v $(pwd):/data marcaruel/hugo-tidy:hugo-0.19-alpine-3.4-pygments-2.2.0
