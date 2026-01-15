+++
date = "2022-05-29T00:00:00"
title = "Cleaning up the old cruft to align on the future"
description = "Removing periph.io/x/periph"
author = "Marc-Antoine Ruel"
authorlink = "https://maruel.ca"
tags = []
+++

[Two years ago](https://periph.io/news/2020/a_new_start/), I created the new
repositories at https://github.com/periph, used with `periph.io/x/<pkg>/v3`
where `<pkg>` is one of conn, cmd, devices, or host. I kept the old ones to not
break existing users. The problem is that it creates more confusion than
anything else and people get stuck on the old code base. As such, I am pushing
v3.7.0 that deletes the whole code in the old repository
https://github.com/google/periph.

If you want to keep using the old code base (which doesn't support Raspberry Pi
4), stay on `periph.io/x/periph@v3.6.8`. I recommend against and instead follow
the instructions at the [post from 2 years
ago](https://periph.io/news/2020/a_new_start/).

Thanks,
