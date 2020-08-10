#!/bin/bash
# Copyright 2017 The Periph Authors. All rights reserved.
# Use of this source code is governed under the Apache License, Version 2.0
# that can be found in the LICENSE file.

set -eu
cd "$(dirname $0)"

# Determine the docker image to use.
TAG="$(cat ./tag)"
IMAGE="marcaruel/hugo-tidy:${TAG}"

echo "Tips:"
echo " - Use --bind=0.0.0.0 to be accessible on the local network."
echo " - Use --buildDrafts to render drafts."

if (which docker > /dev/null); then
  echo "Using hugo-tidy"
  # See https://github.com/maruel/hugo-tidy/ for more info.
  # First, pull the image only if missing.
  [ ! -z $(docker images -q "${IMAGE}") ] || docker pull "${IMAGE}"
  # Run it.
  docker run -t -i --rm -u $(id -u):$(id -g) -v $(pwd):/data --network=host "${IMAGE}" \
    server -b $(hostname) "$@"
elif (which hugo > /dev/null); then
  echo "Using hugo"
  hugo server -s site -d ../www --buildFuture -b $(hostname) --port 3131 "$@"
else
  echo "Please either:"
  echo " - setup docker"
  echo " - install hugo from https://gohugo.io"
  echo " - go get github.com/gohugoio/hugo"
  exit 1
fi
