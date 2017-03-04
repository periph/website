#!/bin/sh

set -eu

cd "$(dirname $0)"

rsync -a --delete periph/doc src/content
find src/content/doc -type f -name README.md -exec bash -c 'mv "$0" "${0/README/index}"' {} \;
hugo server -s src -d ../root --bind=0.0.0.0 -w -b $(hostname)
