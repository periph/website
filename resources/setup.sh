#!/bin/sh
# Copyright 2017 The Periph Authors. All rights reserved.
# Use of this source code is governed under the Apache License, Version 2.0
# that can be found in the LICENSE file.

# - Copy this file to /var/lib/docker/web/setup.sh
# - Enable EMAIL_FLAG below
# - Enable the startup-script metadata
#   https://cloud.google.com/compute/docs/startupscript
#   Set startup-script:/var/lib/docker/web/setup.sh

# Opening ports steps:
# - Authorize HTTP in Cloud Console for the VM
#   https://console.cloud.google.com/compute
# - Authorize HTTP in the 'default' network
#   https://console.cloud.google.com/networking/networks/details/default

set -eu


# Email address to use for Let's Encrypt.
# "you@gmail.com"
EMAIL_ADDRESS=""


cd "$(dirname $0)"
ROOT="$(pwd)"

# Add the -email flag as necessary.
if [ $EMAIL_ADDRESS != "" ]; then
  EMAIL_FLAG="-email $EMAIL_ADDRESS"
else
  EMAIL_FLAG=""
fi

# TODO(maruel): Most of these do not make sense on container-os, it doesn't have
# an account www-data.
# TODO(maruel): Stop running as root. That kind of defeat the purpose.
#User=chronos
#Groups=chronos
cat > /etc/systemd/system/caddy.service << EOF
[Unit]
Description=Caddy
[Service]
Restart=on-failure
ExecStart=$ROOT/caddy -agree $EMAIL_FLAG -log logs/server.log
WorkingDirectory=$ROOT
ExecReload=/bin/kill -USR1 \$MAINPID
Environment="HOME=$ROOT" "CADDYPATH=$ROOT/ssl"
LimitNOFILE=1048576
LimitNPROC=64
TasksMax=4096
PrivateTmp=true
PrivateDevices=true
ProtectHome=true
ProtectSystem=full
NoNewPrivileges=true
[Install]
WantedBy=default.target
EOF
systemctl enable caddy
systemctl daemon-reload

if [ ! -d logs ]; then
  mkdir logs
  chown chronos:chronos logs
fi
if [ ! -d periph.io ]; then
  # TODO(maruel): This is done as user 'chronos', which is not optimal.
  git clone https://github.com/periph/website periph.io
  chown -R chronos:chronos periph.io
fi
if [ ! -d periph.io/www ]; then
  # Do not update automatically, just add when missing.
  # 1000 is chronos
  docker run --rm -u 1000:1000 -v $ROOT/periph.io:/data marcaruel/hugo-tidy:hugo-0.19-alpine-3.4-pygments-2.2.0
fi
if [ ! -f Caddyfile ]; then
  # Do not update automatically, just add when missing.
  cp periph.io/resources/periph.io.conf Caddyfile
  chown chronos:chronos Caddyfile
fi

if [ ! -f caddy ]; then
  # Generate URL by visiting https://caddyserver.com/download
  # then selecting:
  # - git
  # - ipfilter
  # - ratelimit
  URL='https://caddyserver.com/download/build?os=linux&arch=amd64&features=git%2Cipfilter%2Cratelimit'
  echo "- Downloading caddy"
  curl -o caddy.tar.gz "$URL"
  tar -xvf caddy.tar.gz caddy
  rm caddy.tar.gz
  echo "- Got:"
  ./caddy -version
fi

# Authorize HTTP inside the container-os firewall itself.
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT

systemctl restart caddy
