# periph.io website

This repository contains all the code necessary to generate https://periph.io.

The web site content is located at [site/content/](site/content/). Please send
PR as per [contributing guidelines](https://periph.io/project/contributing/).


## Running locally

The scripts to serve the web site locally requires either **one** of the
following to be installed:

- [Docker](https://docker.com)
- [Hugo](https://gohugo.io)

Use one of:

- `./gen.sh`: generates the web site in `./www`.
- `./serve.sh`: serves the website over port 3131.


## Production setup

- [Caddy](https://caddyserver.com) to serve over https
- [Docker](https://docker.com) to be functional and callable from caddy.
- [hub.docker.com/r/marcaruel/hugo-tidy/](https://hub.docker.com/r/marcaruel/hugo-tidy/)
  generates the production website.

The [github webhook
handler](https://github.com/periph/website/blob/main/resources/periph.io.conf)
regenerates the web site automatically whenever a new commit happens.


## Latency

The time between a PR being merged and the web site being live is generally <5
seconds. One second due to github's latency itself, 2 seconds to regenerate the
web site. The author doesn't like waiting.
