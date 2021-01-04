#!/bin/sh
# Copyright 2017 The Periph Authors. All rights reserved.
# Use of this source code is governed under the Apache License, Version 2.0
# that can be found in the LICENSE file.

# - Copy this file to /var/lib/docker/web/setup.sh
# - Enable the startup-script metadata
#   https://cloud.google.com/compute/docs/startupscript
#   Set startup-script:/var/lib/docker/web/setup.sh

# Opening ports steps:
# - Authorize HTTP (and HTTPS?) in Cloud Console for the VM
#   https://console.cloud.google.com/compute
# - Authorize HTTP in the 'default' network
#   https://console.cloud.google.com/networking/networks/details/default

set -eu

cd "$(dirname $0)"
ROOT="$(pwd)"

# TODO(maruel): Stop running as root. That kind of defeat the purpose.
cat > /etc/systemd/system/caddy.service << EOF
[Unit]
Description=Caddy
[Service]
Restart=on-failure
WorkingDirectory=$ROOT
ExecStart=$ROOT/caddy run -environ -config $ROOT/Caddyfile
ExecReload=$ROOT/caddy reload --config $ROOT/Caddyfile
Environment=XDG_DATA_HOME=$ROOT/tls
LimitNOFILE=1048576
[Install]
WantedBy=default.target
EOF
systemctl enable caddy
systemctl daemon-reload

if [ ! -d logs ]; then
  mkdir logs
fi

if [ ! -d periph.io ]; then
  git clone https://github.com/periph/website periph.io
fi

if [ ! -f Caddyfile ]; then
  echo "import alt1.periph.io.conf" > Caddyfile
  echo "import periph.io.conf" >> Caddyfile
fi

if [ ! -f periph.io.conf ]; then
  # Do not update automatically, just add when missing (or when rebooting).
  cp periph.io/resources/alt1.periph.io.conf .
  cp periph.io/resources/periph.io.conf .
fi

if [ ! -f caddy ]; then
  echo "- Downloading caddy"
  curl -o caddy 'https://caddyserver.com/api/download?os=linux&arch=amd64&p=github.com%2Fabiosoft%2Fcaddy-exec&p=github.com%2Fabiosoft%2Fcaddy-hmac&p=github.com%2Fabiosoft%2Fcaddy-json-parse&p=github.com%2Fgreenpau%2Fcaddy-auth-portal'
  chmod +x caddy
  echo "- Got:"
  ./caddy version
fi

if [ ! -d periph.io/www ]; then
  # 1000 is chronos
  # 1002 is google-sudoers.
  # TODO(maruel): This is brittle!
  cd ./periph.io
  git fetch
  git reset --hard
  git checkout origin/master --force
  docker run --rm -u 1000:1002 -v "$(realpath .):/data" "marcaruel/hugo-tidy:$(cat tag)"
  cd -
fi

# Make everything usable by people who access via ssh.
chown -R chronos:google-sudoers .
chmod -R g+rXw .

# Authorize HTTP inside the container-os firewall itself.
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT

systemctl restart caddy
