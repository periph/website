#!/bin/sh
# Copyright 2017 The Periph Authors. All rights reserved.
# Use of this source code is governed under the Apache License, Version 2.0
# that can be found in the LICENSE file.

set -eu

cd $(dirname "$0")
cd ../site/static

SRC=img/periph-mascot-full.png

echo 'Generating'
convert $SRC -brightness-contrast 0x50 -resize 192x192 touch-icon-192x192.png
convert $SRC -brightness-contrast 0x50 -resize 180x180 apple-touch-icon-180x180-precomposed.png
convert $SRC -brightness-contrast 0x50 -resize 152x152 apple-touch-icon-152x152-precomposed.png
convert $SRC -brightness-contrast 0x50 -resize 76x76 apple-touch-icon-76x76-precomposed.png
convert $SRC -brightness-contrast 0x50 -resize 64x64 favicon.png
convert $SRC -brightness-contrast 0x50 -resize 57x57 apple-touch-icon-precomposed.png
echo 'Compressing'
find . -name '*.png' -printf '%p\n' -exec pngcrush -q -ow -brute {} {}.crush \;
cp apple-touch-icon-precomposed.png apple-touch-icon.png
mv favicon.png favicon.ico
