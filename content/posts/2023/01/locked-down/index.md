---
title: "Locked Down"
description: "Sometimes you just need to wait and complain for things to resolve themselves"
date: 2023-01-26T16:56:08-08:00
publishDate: 2023-01-26T16:56:08-08:00
draft: false
tags: ["Barely A Post", "GitHub Pages", "Blog"]
---

At the end of the [last post](https://gilbertdev.net/posts/2023/01/observe-the-colors/), I made a little footnote marking a little issue I had with the site serving mixed content. It turns out, a setting I had put in place on the GitHub pages site itself resolved it, but just took some time to do so. I had set the `Enforce HTTPs` setting to checked on the site, saw no change, then began writing the previous post. I guess it just took a few minutes to take effect because as soon as I pushed the new post, viewing the site was now showing as fully locked down as I would have expected. Nothing popping up in the console about mixed media, just plain old secure connections.

{{< figure src="https.png" caption="Nothing like good old-fashioned https" align=center >}}

Great success!
