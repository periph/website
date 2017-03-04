#!/bin/sh

set -eu

cd "$(dirname $0)"

rsync -r --delete periph/doc src/content
find src/content/doc -type f -name README.md -exec bash -c 'mv "$0" "${0/README/index}"' {} \;
hugo -s src -d ../root
