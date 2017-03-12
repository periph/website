# Resources to host periph.io

The files here assumes the following setup: a [container-os
instance](https://cloud.google.com/container-optimized-os/) running on [Google
Compute Engine](https://cloud.google.com/compute/).

This can now be [run for
free](https://cloud.google.com/compute/pricing#freeusage) because:
- container-os system memory overhead is ~200Mb and barely any CPU usage
- [Caddy](https://caddyserver.com/) itself is *extremely* efficient and uses
  around 20Mb of RAM
- all the site fits in the remaining memory as OS disk cache, so all the website
  is served from RAM even on the [smallest f1-micro
  instance](https://cloud.google.com/compute/pricing#sharedcore).
- one f1-micro instance with 30Gb and 1Gb of egress is free! Additional egress
  is [between 0.12$USD/Gb and
  0.23$USD/Gb](https://cloud.google.com/compute/pricing#internet_egress) so it
  is worth optimizing outgoing bandwdith.
