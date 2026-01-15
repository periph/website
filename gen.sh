#!/usr/bin/env bash
# Copyright 2017 The Periph Authors. All rights reserved.
# Use of this source code is governed under the Apache License, Version 2.0
# that can be found in the LICENSE file.

set -eu
cd "$(dirname $0)"

echo "Tips:"
echo " - Use --buildDrafts to render drafts."

if (which hugo > /dev/null); then
  echo "Using hugo"
  hugo -s site -d ../www --buildFuture "$@"
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
	echo "Please run ./rsc/install_hugo.py"
  exit 1
fi
echo ""
echo "  go install github.com/maruel/serve-dir@latest"
echo "  serve-dir -port=3131 -root=www"
echo "  then visit http://localhost:3131/"
