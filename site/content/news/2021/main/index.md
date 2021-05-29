+++
date = "2021-05-29T00:00:00"
title = "main"
summary = "Renamed all repositories master branch to main"
author = "Marc-Antoine Ruel"
authorlink = "https://maruel.ca"
tags = []
+++

Now that GitHub supports transparent redirection, I renamed all the remaining
repositories master branches to main.

If you have a local git clone, run:

```
git branch -m master main
git fetch origin --prune
git branch -u origin/main main
git remote set-head origin -a
```
