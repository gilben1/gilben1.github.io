---
title: "From Disqus to Giscus"
description: "Commenting on changing comment backends"
date: 2023-02-05T09:55:44-08:00
publishDate: 2023-02-05T09:55:44-08:00
draft: false
tags: ["Comments", "Disqus", "Giscus", "Hugo", "PaperMod"]
---

### Wait, why change?

The initial choice of [Disqus](https://disqus.com/) as a comment backend was a hasty one; it was chosen on a whim simply because I had heard of it. It had some clear drawbacks:
- Not terribly configurable to meet the theme I was going for
- External site for configuration and management
- Free tier supported by Ads (the biggest one)

Not wanting to pony up cash for a premium tier I decided I would stick with this for now to just have some comments before migrating elsewhere. This wasn't a huge priority, and I wasn't going to be actively looking for another provider.

This changed when I discovered something while poking around the settings of my repository.

#### Enter: diffblogbot and diffblog

I noticed that the repository for my site had a star. I did not recall a star being there prior, so I took a look at who this was. Turns out it was [diffblogbot](https://github.com/diffblogbot), a bot associated with [diff.blog](https://diff.blog/) that looks like a decentralized aggregation of blogs sort of like [Medium](https://medium.com/), but without hosting the content itself, just linking.

Seeing a collection of different blogs I poked around at some of the blogs linked on the homepage of diff.blog. I wanted to see what other small tech-blogs were doing as far as style, content, etc. I believe it was [this post](https://tyrrrz.me/blog/reverse-engineering-youtube-revisited) that I saw that was leveraging [giscus](https://giscus.app/) for comments, not something like Disqus. This peaked my interest *immediately*.

### Giscus
#### Features and Draw
[Giscus](https://giscus.app/) sold me pretty quickly on it's elevator pitch on its site (paraphrased by me):
- Open source
    - Awesome, love to see it. Gives greater confidence in the integrity of the application
- No Ads
    - Extremely big plus, I understand why Ads exist on principle but they had no place on my blog long-term
- General customization
    - Disqus was clunky and couldn't really be modified after loading. This looked like it could
- Github Powered
    - This I thought was the neatest part. Having a blog hosted on Github, where the comments are also tracked on github? Sign me up!
    - Apparently previous engines existed before, like [utterances](https://github.com/utterance/utterances) that used Github issues as a discussion board. Giscus takes that and leverages the (fairly new) "Discussions" feature of Github instead.

#### Getting started

The giscus site has a fairly straightforward questionnaire / dependency checker that ensures that the repo is set up correctly. Below is a documentation of the journey getting this blog set up with the comments app.

##### Pre-Requisites

The big requirements were a) the repository being public, which it already is b) enabling Discussions for the repository (they're disabled by default) and c) installing the [giscus github app](https://github.com/apps/giscus) on the repository. B and C were simple to enable and install, since A was already fulfilled for this site's repository.

##### Injection Code

The site generates a script block that gives you most of what you need to have the comments embedded in posts, looking like this:
```
<script src="https://giscus.app/client.js"
        data-repo="[ENTER REPO HERE]"
        data-repo-id="[ENTER REPO ID HERE]"
        data-category="[ENTER CATEGORY NAME HERE]"
        data-category-id="[ENTER CATEGORY ID HERE]"
        data-mapping="pathname"
        data-strict="0"
        data-reactions-enabled="1"
        data-emit-metadata="0"
        data-input-position="bottom"
        data-theme="preferred_color_scheme"
        data-lang="en"
        crossorigin="anonymous"
        async>
</script>
```
Naturally, this is barebones, and doesn't allow for configuration in the way that Hugo expects or allows. So I start digging to find out if someone else had used Giscus and Hugo together before. 

##### Adjustments / Hugo Changes
Lo and behold, I found someone who did, [Chris Wilson](https://cdwilson.dev) who made a nice write-up surrounding this topic:

[https://cdwilson.dev/articles/using-giscus-for-comments-in-hugo/](https://cdwilson.dev/articles/using-giscus-for-comments-in-hugo/)

This post is laid out very nicely in describing the reasons the author switched to giscus, as well as some specific settings for setting up in Hugo.

The first thing I was able to pull from this post was a short-coded version of a [partial template](https://gohugo.io/templates/partials/) that allows for pulling up some configuration into the main `config.yaml` file.

```
{{- if isset .Site.Params "giscus" -}}
  {{- if and (isset .Site.Params.giscus "repo") (not (eq .Site.Params.giscus.repo "" )) (eq (.Params.disable_comments | default false) false) -}}
  <div id="giscus_thread">
    <script src="https://giscus.app/client.js"
        data-repo="{{ .Site.Params.giscus.repo }}"
        data-repo-id="{{ .Site.Params.giscus.repoID }}"
        data-category="{{ .Site.Params.giscus.category }}"
        data-category-id="{{ .Site.Params.giscus.categoryID }}"
        data-mapping="{{ default "pathname" .Site.Params.giscus.mapping }}"
        data-reactions-enabled="{{ default "1" .Site.Params.giscus.reactionsEnabled }}"
        data-emit-metadata="{{ default "0" .Site.Params.giscus.emitMetadata }}"
        data-input-position="{{ default "bottom" .Site.Params.giscus.inputPosition }}"
        data-theme="{{ default "light" .Site.Params.giscus.theme }}"
        data-lang="{{ default "en" .Site.Params.giscus.lang }}"
        data-loading="{{ default "lazy" .Site.Params.giscus.loading }}"
        crossorigin="anonymous"
        async>
    </script>
  </div>
  {{- end -}}
{{- end -}}
```

The config pieces then looked like this:
```
param:
  giscus:
    repo: gilben1/gilben1.github.io
    repoID: MDEwOlJlcG9zaXRvcnkyNDY0MjI1NjU=
    category: Announcements
    categoryID: DIC_kwDODrAcJc4CUA9K
    mapping: url
    inputPosition: top
    theme: transparent_dark
    lang: en
```

Wilson's post described the setting in TOML instead of YAML, but I found the YAML equivalent achieves the same goal.

I took template verbatim, with the parameters converted into YAML on the `config.yaml`, but had to do some finagling to get it to work right with the PaperMod theme.

Wilson's post described saving the partial template under `layouts/posts/giscus.html`, which would then be referenced in a `layouts/posts/single.html` that simply contained
```
<footer>
  {{ partial "posts/giscus.html" . }}
</footer>
```
I couldn't get that exact path to work, but even shifting around the file structure to be under `layouts/partials` gave me weird behavior, most noticeably giving the whole page to just the giscus comments widget.

After debugging I now believe Wilson's method is more suited if you're building out the theme yourself, since I believe setting a `layouts/posts/single.html` overrides an existing `layouts/posts/single.html` without the theme sub-module. With this overwriting, the theming was hilariously lost.

I then tried just putting that partial shortcode in the `extend_footer.html`, but that just spread it across the entire bottom of the screen, on every page, even the the homepage. That wouldn't do.

{{< figure src="big_big_comments.png" caption=":(" align=center >}}

What I ended up needing to do, was replace the Disqus oriented `comments.html` under the `layouts/partials` folder with the contents of the `giscus.html`, and then continue to use the `comments: true` parameter in the root configuration. This then injected the commented inline in the way I expected. This fell in line with the last documentation I saw regarding comments on the [PaperMod documentation](https://github.com/adityatelange/hugo-PaperMod/wiki/Features#comments)

{{< figure src="giscus.png" caption="\\o/" align=center >}}

### Conclusion and Thanks
Giscus ended up being a breeze to set up, with only a couple of stumbling points with conflicting documentation. 

I want to thank [diffblog](https://diff.blog) for pointing me in the direction of other blogs, [Tyrrrz](https://tyrrrz.me/blog/reverse-engineering-youtube-revisited) for being on the front page of diffblog and having giscus as the comment engine, and [Chris Wilson](https://cdwilson.dev/) for having a [nice succinct post](https://cdwilson.dev/articles/using-giscus-for-comments-in-hugo/) that gave further context / help in setting up the Hugo portions of the configuration, even if I did ultimately have to dig further.

### Music

`Rain Dogs` by `Tom Waits`. Gonna be a weird one, though I've heard nothing but praise for it.