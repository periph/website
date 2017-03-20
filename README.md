# periph.io website

Contains all the code necessary to generate https://periph.io via
[Hugo](https://gohugo.io) and serve via [Caddy](https://caddyserver.com/).

The web pages content is located at [site/content/](site/content/). Please send
PR as per [contributing
guidelines](https://periph.io/project/contributing/).


## Setup

- [caddy](https://caddyserver.com) to serve over https
- [docker](https://docker.com) to be functional and callable from caddy.

The [github webhook
handler](https://github.com/periph/website/blob/master/resources/periph.io.conf)
leverages
[hub.docker.com/r/marcaruel/hugo-tidy/](https://hub.docker.com/r/marcaruel/hugo-tidy/)
to do the processing whenever a new commit happens.

hugo-tidy leverages:
- [pygment](http://pygments.org) to generate the syntax highlighting: `pip
  install --user Pygments`
- [hugo](https://gohugo.io) to generate the html
- [minify](https://github.com/tdewolff/minify/tree/master/cmd/minify) to reduce
  the size: `go get -u -v github.com/tdewolff/minify/cmd/minify`

The syntax styles was generated with `pygmentize -f html -S colorful -a .syntax >> site/static/css/style.css`
and small modifications.


## Latency

The time between a PR being merged and the web site being live is generally <5
seconds. One second due to github's latency itself, 2 seconds to regenerate the
web site. The author doesn't like waiting.
