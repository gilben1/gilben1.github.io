---
title: "Observe the Colors"
description: "Making the blog a little bit more spiffy"
date: 2023-01-26T16:40:39-08:00
publishDate: 2023-01-26T16:40:39-08:00
draft: false
tags: ["hugo", "papermod"]
---

### Colors

Nearing the end of the main customization train as I get settled, but I discovered the recommended way to customize the theme of papermod enough to change element colors.

Thanks to [this post](https://github.com/adityatelange/hugo-PaperMod/discussions/645) on the [PaperMod Repository](https://github.com/adityatelange/hugo-PaperMod), I was able to use the answer from [danielfdickinson](https://github.com/danielfdickinson) to make the customization file. 

It turns out with Hugo that you can override theme variables by generating a file at `assets/css/extended` called `theme-vars-override.css`, looking something like this:
```
:root {
    --theme: #fff;
    --entry: #cfcfff;
    --primary: rgba(0, 0, 106, 0.88);
    --secondary: rgba(0, 0, 80, 0.78);
    --tertiary: rgba(0, 0, 106, 0.16);
    --content: rgba(0, 0, 60, 0.88);
    --hljs-bg: #1c1d21;
    --code-bg: #f5f5f5;
    --border: #eee;
}

.dark {
    --theme: #101c7a;
    --entry: #202062;
    --primary: rgba(235, 235, 255, 0.96);
    --secondary: rgba(235, 235, 255, 0.66);
    --tertiary: rgba(1, 1, 5, 0.32);
    --content: rgba(235, 235, 255, 0.82);
    --hljs-bg: #2e2e33;
    --code-bg: #37383e;
    --border: #446;
}
```
Those are the primary variables controlling various elements throughout the blog. I was originally planning to make some customizations to this directly, but it turns out I was satisfied with the blue-ish change that was going on in this example, so I've decided to keep that for the time being.

The dark-mode in particular for this theme is very PowerShell blue, and since I'll be writing PowerShell content in the future it seemed very fitting.

### Aside: Favicon Issue

One unrelated issue I'm running into is the serving of a couple of favicon related items being stuck in `http` instead of `https`, causing Firefox to load them unencrypted and giving my site the amazing sheen of insecurity. 

{{< figure src="favicon_blarg.png" caption="Mixed content, why?" align=center >}}

Chrome appears to ignore the mixed media, but my Firefox configuration does not. I need to dig into the hugo settings perhaps to determine if it's the way the site is being generated, since thus far all I did was supply the icons to the `static` folder of the site.

{{< figure src="http.png" caption="Sad" align=center >}}