# periph.io website

Contains all the code necessary to generate https://periph.io via
[Hugo](https://gohugo.io) and serve via [Caddy](https://caddyserver.com/).

The web pages content is located at [src/content/](src/content/). Please send
PR as per [contributing
guidelines](https://periph.io/doc/drivers/contributing/).


## Setup

Requirements:
- pygment to generate the syntax highlighting: `pip install --user Pygments`
- hugo to generate the html
- caddy to serve over https

The syntax styles was generated with `pygmentize -f html -S colorful -a .syntax
>> src/static/css/style.css` and small modifications.
