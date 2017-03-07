#!/bin/sh
# Copyright 2017 The Periph Authors. All rights reserved.
# Use of this source code is governed under the Apache License, Version 2.0
# that can be found in the LICENSE file.

set -eu

cd "$(dirname $0)"

hugo server -s src -d ../root --bind=0.0.0.0 -w -b $(hostname)
