#!/bin/bash
# Copyright 2017 The Periph Authors. All rights reserved.
# Use of this source code is governed under the Apache License, Version 2.0
# that can be found in the LICENSE file.

set -eu
cd "$(dirname $0)"

# Determine the docker image to use.
TAG="$(cat ./tag)"
IMAGE="marcaruel/hugo-tidy:${TAG}"

if (which docker > /dev/null); then
  # See https://github.com/maruel/hugo-tidy/ for more info.
  # First, pull the image only if missing.
  [ ! -z $(docker images -q "${IMAGE}") ] || docker pull "${IMAGE}"
  # Run it.
  docker run --rm -u $(id -u):$(id -g) -v $(pwd):/data "${IMAGE}"
elif (which hugo > /dev/null); then
  hugo -s site -d ../www --buildFuture
  rm -rf www.new
  # The docker image also does the following:
  #   minify -r -o www.new www.new
  #   find www.new -type f \( -name '*.html' -o -name '*.js' -o -name '*.css' -o
  #     -name '*.xml' -o -name '*.svg' \) \
  #     -exec /bin/sh -c 'gzip -v -f -9 -c "$1" > "$1.gz"' /bin/sh {} \;
  #   find www.new -type f \( -name '*.html' -o -name '*.js' -o -name '*.css' -o
  #     -name '*.xml' -o -name '*.svg' \) \
  #     -exec /bin/sh -c '/usr/local/bin/brotli -q 11 -o "$1.br" "$1"' /bin/sh {} \;
else
  echo "Please either setup docker or install hugo from https://gohugo.io"
  exit 1
fi
echo ""
echo "  go get github.com/maruel/serve-dir"
echo "  serve-dir -port=3131 -root=www"
echo "  then visit http://localhost:3131/"
