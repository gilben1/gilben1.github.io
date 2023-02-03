---
title: "What Do You Say?"
description: "Or: How I stopped worrying and learned to love the comments"
date: 2023-02-03T11:34:14-08:00
publishDate: 2023-02-03T11:34:14-08:00
draft: false
tags: ["Disqus", "Hugo", "PaperMod", "Blog", "Github Pages", "Comments"]
---

### Say Anything

While pondering the limits of github pages, I wondered if a comments provider would work. Turns out it does, out of the box, really easily, down to the provider (in this case, Hugo and PaperMod).

Comments I think will become useful as I start to write about non-blog topics like PowerShell specifics, where folks can contribute questions or suggestions to fix the content I've written. It would also allow me to track engagement to some degree (which I'm guessing is next to zero for now.)

I went with [Disqus](https://disqus.com/) as the comments provider because it has a free tier, is widely used, and has a straightforward integration system.

### Installation

Installation ended up being fairly straightforward, after I figured out the right installation guide to follow.

Disqus' and Hugo's documentation clashed a bit with the specific theming documentation. 

#### Disqus Documentation
Following the Disqus universal code was a no go, as it relied on injecting html directly. I'm sure I *could* get it to work, but I figured with Hugo's markdown -> HTML rending there was a more Hugo supported way. I was right.

#### Hugo Documentation
In retrospect, I think the [Hugo comments documentation](https://gohugo.io/content-management/comments/) was a bit geared toward designers of themes, or users building a site from the ground up using Hugo as the ultimate base.

The documentation references a template that may or may not be packaged up by a theme provider, `_internal/disqus.html`. I tried including that at the foot of a page, to no avail. It just didn't render.

This [next documentation](https://gohugo.io/templates/internal/#disqus) pointed me more, with a snippet to block loading disqus when rendering locally via `hugo server`. I created that layout as shown, and it still didn't render using the `partial disqus.html` syntax.

That partial file looked like this:
```
<div id="disqus_thread"></div>
<script type="text/javascript">

(function() {
    // Don't ever inject Disqus on localhost--it creates unwanted
    // discussions from 'localhost:1313' on your Disqus account...
    if (window.location.hostname == "localhost")
        return;

    var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
    var disqus_shortname = '{{ .Site.DisqusShortname }}';
    dsq.src = '//' + disqus_shortname + '.disqus.com/embed.js';
    (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
})();
</script>
<noscript>Please enable JavaScript to view the <a href="https://disqus.com/?ref_noscript">comments powered by Disqus.</a></noscript>
<a href="https://disqus.com/" class="dsq-brlink">comments powered by <span class="logo-disqus">Disqus</span></a>
```

And was supposedly invoked with `{ partial "disqus.html" . }`, but with two `{{` instead of one. All I ended up seeing was the text explicitly.

#### PaperMod Documentation
Finally, I found that [PaperMod itself](https://github.com/adityatelange/hugo-PaperMod/wiki/Features#comments) had documentation for including comments. It ended up being extremely straightforward, allowing me to use the partial `disqus.html` I had tried earlier, just renaming it to `comments.html` and adding `comments: true` to the `config.yaml` for the site. This gave me the intended output, not rendering the comments when running locally, and rendering the Disqus comment engine when hosted on Github. Success!

With the way the front-matter works, I can also exclude comments from certain pages (ie, non-posts) by simply adding `comments: false` to the front matter there. I did so on the [Projects](https://gilbertdev.net/projects/) page and will be doing so on the `About Me` page as well.

### Engagement

I don't expect to get many, if any, comments on these posts. This acts almost like a journal in some respects, and documentation for my journey to setting up a blogfolio in this specific use case. Hopefully it may prove useful for others who stumble upon it, but I don't expect much. However, with Disqus, I can track engagement to some extent which is more than the zero engagement tracking I was doing before.

### Music

Today's album is `Rust in Peace` by `Megadeth`, which I already think highly of. As of writing, I haven't listened to it yet for the day, but will most certainly get to it. I definitely remember loving it, we'll see how it holds up to 2023 me.

Cheers.