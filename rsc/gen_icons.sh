#!/bin/sh
# Copyright 2017 The Periph Authors. All rights reserved.
# Use of this source code is governed under the Apache License, Version 2.0
# that can be found in the LICENSE file.

set -eu

cd $(dirname "$0")

#if [ ! -f cwebp ]; then
#  # https://storage.googleapis.com/downloads.webmproject.org/releases/webp/index.html
#  curl -o libwebp.tar.gz https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-0.6.0-linux-x86-64.tar.gz
#  tar xvf libwebp.tar.gz --wildcards --strip-components=2 '*/bin/cwebp' '*/bin/gif2webp'
#  rm libwebp.tar.gz
#fi

cd ../static

SRC=img/periph-mascot-full.png

echo 'Generating favicons...'
convert $SRC -brightness-contrast 0x50 -resize 192x192 touch-icon-192x192.png
convert $SRC -brightness-contrast 0x50 -resize 180x180 apple-touch-icon-180x180-precomposed.png
convert $SRC -brightness-contrast 0x50 -resize 152x152 apple-touch-icon-152x152-precomposed.png
convert $SRC -brightness-contrast 0x50 -resize 76x76 apple-touch-icon-76x76-precomposed.png
convert $SRC -brightness-contrast 0x50 -resize 64x64 favicon.png
convert $SRC -brightness-contrast 0x50 -resize 57x57 apple-touch-icon-precomposed.png

echo 'Compressing PNGs...'
find . -name '*.png' -printf '  %p\n' -exec pngcrush -q -ow -brute {} {}.crush \;
cp apple-touch-icon-precomposed.png apple-touch-icon.png
mv favicon.png favicon.ico

#echo 'Compressing all images to Webp...'
## gif2web and cwebp are silly, they may generate *significantly* larger files.
## TODO(maruel): Run multiple times with different flags and figure out the best
## output. Sometimes it's with -lossless, sometimes without.
#find . -name '*.gif' -printf '  %p\n' -exec ../rsc/gif2webp -quiet -mixed {} -o {}.webp \;
#find . -name '*.png' -printf '  %p\n' -exec ../rsc/cwebp -quiet -lossless {} -o {}.webp \;
#find . -name '*.jpg' -printf '  %p\n' -exec ../rsc/cwebp -quiet {} -o {}.webp \;
