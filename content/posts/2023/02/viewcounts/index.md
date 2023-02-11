---
title: "Viewcounts"
description: "Is anyone actually reading?"
date: 2023-02-10T16:10:06-08:00
publishDate: 2023-02-10T16:10:06-08:00
draft: false
tags: ["Hugo", "Blog", "Visitors", "Viewcount"]
---

### More bells, more whistles

I don't recall exactly how I stumbled upon this feature idea, but I decided I wanted to see (roughly) how many visitors I've had on the different blog posts I've made. Seemed like a simple enough feature, and probably doable in a static site like this. Turns out it is extremely simple, using a service called [visitor-badge.glitch.me](https://visitor-badge.glitch.me/).

Using a snippet from [this blog post](https://ravichaganti.com/blog/adding-visitor-counter-to-statically-generated-web-pages/) by Ravikanth Chaganti, which detailed the embedding of the visitor-badge service, I had what I needed to get this on my site.
```
<div class="views">
    <span class="views">
        <img src="https://visitor-badge.glitch.me/badge?page_id={{ .Permalink }}" alt="Views"/>
    </span>
</div>
```

There was a problem though, I hadn't treaded into modifying the PaperMod theme directly. I couldn't just use `extend_head.html` or `extend_footer.html`, I wanted these view counts to appear in-line with the metadata of the post, preferably under the date and author data. 

To do this, I'd have to modify the theme directly. A couple of issues that presented themselves:

- When setting up this site, I pulled the [papermod repository](https://github.com/adityatelange/hugo-PaperMod) directly, instead of making a fork and modifying. I naturally couldn't make the changes on the papermod repo itself, I'd have to make a fork and make changes there.

- I would also have to adjust both the local and remote repo for this site to use the forked version of papermod as well.

#### Changing to the fork
I made a [forked repository](https://github.com/gilben1/hugo-PaperMod) of the theme, so now I needed to set it locally. In order to do so, I needed to replace the origin by navigating to the theme directly `theme/papermod` and running the following command:
```
git remote set-url origin git@github.com:gilben1/hugo-PaperMod.git
```

#### Changes required
To get my desired outcome, I had to take the snippet I posted above and get it into the right template html file. In this case, the file was `layouts/_default/single.html`. The location I want is in the `post-header` class, right under the `post-meta` div.
```
<- More content above ->
    <div class="post-meta">
      {{- partial "post_meta.html" . -}}
      {{- partial "translation_list.html" . -}}
      {{- partial "edit_post.html" . -}}
      {{- partial "post_canonical.html" . -}}
    </div>
    <div class="views">
      <span class="views">
        <img src="https://visitor-badge.glitch.me/badge?page_id={{ .Permalink }}" alt="Views"/>
      </span>
    </div>
<- More content below ->
```

As described in Chaganti's post, we can leverage Hugo's .Permalink parameter to pass along to the visitor-badge service, which returns a badge tracking the view count at the url.

#### Additional adjustments

While I'm in here, I wanted to move around where tags are positioned. PaperMod by default lists all of the tags at the bottom of the post, which is fine for short posts but becomes a bit of a hassle for longer posts. So with this I positioned the tags to be right below the view count, in the header of the post. I think it looks a good deal better, though I might tinker with it more and possibly make it configurable per page using additional switches.

{{< figure src="tags_top.png" caption="Tags 'n Viewcounts, oh boy" align=center >}}