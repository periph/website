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
# TODO(maruel): Get a default from curl -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/... ?
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
#LimitNPROC=64
#TasksMax=4096
#PrivateTmp=true
#PrivateDevices=true
#ProtectHome=true
#ProtectSystem=full
#NoNewPrivileges=true
[Install]
WantedBy=default.target
EOF
systemctl enable caddy
systemctl daemon-reload

if [ ! -d logs ]; then
  mkdir logs
fi

if [ ! -d periph.io ]; then
  # TODO(maruel): This is done as user 'chronos', which is not optimal.
  git clone https://github.com/periph/website periph.io
fi

if [ ! -f Caddyfile ]; then
  echo "import periph.io.conf" > Caddyfile
fi

if [ ! -f periph.io.conf ]; then
  # Do not update automatically, just add when missing.
  cp periph.io/resources/periph.io.conf .
fi

if [ ! -f caddy ]; then
  # Generate URL by visiting https://caddyserver.com/download
  # then selecting:
  # - git
  # - ipfilter
  # - ratelimit
  # TODO(maruel): Sadly the getcaddy.com script is hardcoded to download to
  # /usr/bin so it can't be used so inline the relevant parts below.
  #   curl https://getcaddy.com | bash -s http.git,http.ipfilter,http.ratelimit
  caddy_plugins="http.git,http.ipfilter,http.ratelimit"
  caddy_bin="caddy"
  caddy_os="linux"
  caddy_arch="amd64"
  caddy_arm=""
  caddy_dl_ext=".tar.gz"
  caddy_file="caddy_${caddy_os}_$caddy_arch${caddy_arm}_custom$caddy_dl_ext"
  caddy_url="https://caddyserver.com/download/$caddy_os/$caddy_arch$caddy_arm?plugins=$caddy_plugins"
  echo "- Downloading caddy"
  curl -fsSL "$caddy_url" -o "$caddy_file"
  tar -xzf "$caddy_file" "$caddy_bin"
  chmod +x "$caddy_bin"
  rm "$caddy_file"
  echo "- Got:"
  ./$caddy_bin -version
fi

if [ ! -d periph.io/www ]; then
  # Do not update automatically, just add when missing.
  # 1000 is chronos
  userid=$(id -u chronos)
  # 1002 is google-sudoers.
  # TODO(maruel): This is brittle!
  groupid=1002
  # TODO(maruel): Use the tag from periph.io.conf instead of duplicating it
  # here.
  docker run --rm -u $userid:$groupid -v $ROOT/periph.io:/data marcaruel/hugo-tidy:hugo-0.40.3-alpine-3.7-brotli-1.0.4
fi

# Make everything usable by people who access via ssh.
chown -R chronos:google-sudoers .
chmod -R g+rXw .

# Authorize HTTP inside the container-os firewall itself.
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT

systemctl restart caddy
