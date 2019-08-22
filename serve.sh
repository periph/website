#!/bin/bash
# Copyright 2017 The Periph Authors. All rights reserved.
# Use of this source code is governed under the Apache License, Version 2.0
# that can be found in the LICENSE file.

set -eu
cd "$(dirname $0)"

# Determine the docker image to use.
TAG="$(cat ./tag)"
IMAGE="marcaruel/hugo-tidy:${TAG}"

echo "Note: Use --bind=0.0.0.0 to be accessible on the local network."

if (which docker > /dev/null); then
  # See https://github.com/maruel/hugo-tidy/ for more info.
  # First, pull the image only if missing.
  [ ! -z $(docker images -q "${IMAGE}") ] || docker pull "${IMAGE}"
  # Run it.
  docker run -t --rm -u $(id -u):$(id -g) -v $(pwd):/data --network=host "${IMAGE}" \
    -w -b $(hostname) --port 3131 "$@"
elif (which hugo > /dev/null); then
  hugo server -s site -d ../www -w --buildFuture -b $(hostname) --port 3131 "$@"
else
  echo "Please either setup docker or install hugo from https://gohugo.io"
  exit 1
fi
