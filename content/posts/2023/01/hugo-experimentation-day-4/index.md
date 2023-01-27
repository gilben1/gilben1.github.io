---
title: "Hugo Experimentation: Day 4"
description: "Customizing things further"
date: 2023-01-25T16:21:35-08:00
publishDate: 2023-01-25T16:21:35-08:00
draft: false
tags: ["Hugo", "Process", "PaperMod"]
---

### More Bells, More Whistles
Started poking around with some of the additional front-matter that PaperMod supports, as well as some additional site-wide parameters I can set.

A few I stumbled upon that I decided to incorporate into the main `config.yaml` are:
```
  ShowPostNavLinks: true
  ShowToc: true
  TocOpen: false
  ShowReadingTime: true
```
`ShowPostNavLinks` shows a navigation bar at the bottom to navigate between consecutive blog posts. Not sure I'm a huge fan of the formatting so I might see if I can tweak it later. That said, it's useful enough in its own right that it can stay for now.
{{< figure src="navbar.png" caption="Fig. 1 - Navbar in action" align=center >}}

`ShowToc` and `TocOpen` control the Table of Contents for every page. I want a Table of Contents to exist no matter what (unless explicitly specified by the page), but I don't want them open all of the time, so I set it to `true` and `false` respectively.

{{< figure src="toc.png" caption="Fig. 2 - Table of Contents Example" align=center >}}

`ShowReadingTime` is a fluff sort of feature, but it estimates the reading time for the blog post using some sort of magic, guessing by the number of words included in the post. Not super deep, but not intrusive either.

{{< figure src="reading.png" caption="Fig. 3 - Reading Time" align=center >}}

### Images and Words

This post (and the work I did on the blog today) signified the first foray into including images in my posts (or on the site in general). You may have noticed them in the section above detailing the bells and whistles. I also added them to the [Projects](/projects) section of this site, specifcally to show some screenshots of the old Elm version of the site. 
I also added some screenshots for the other projects, and will only add to them. If the page becomes too long, I'll probably break the larger projects into their own pages as well instead of a single projects page.

When starting to embed images, I was using the markdown inserter by just linking to the relative content, like this:
```
![picture.png](picture.png#center)
```

...but quickly realized that this limited my ability to add nicely formatted captions.

This drew me to the [Figures](https://gohugo.io/content-management/shortcodes/#figure) feature of Hugo, which is implemented using a shortcode that looks like this:
```
{{ < figure src="picture.png" > }}
```

From [this helpful issue](https://github.com/adityatelange/hugo-PaperMod/issues/816) I was able to figure out the right syntax to add a centered caption for any image I added, which ended up looking like:

```
{{ < figure src="picture.png" caption="Look Ma, I'm a caption!" align=center > }}
```
*Sidenote: the actual syntax has the leading and closing `<` and `>` directly touching the `{{` and `}}`, but showing it would make the interpreter think it's another instance of the shortcode, so they're included with spaces. If you were to actually use them, remove the space between `{{` and `<`, and `>` and `}}`*

### Untouched Features
Some other features that I became aware of but haven't touched are:
- Post covers that show up amongst the post description. May or may not be useful for the sort of content I'm writing.
- Breadcrumb navigation. May become more useful if I create distinction between post types. Right now I just have `posts` and primary content pages.
- Custom headers and footers. I've made the stub html files `extend_head.html` and `extend_footer.html` but haven't fill them with anything yet.

### Touched-but-broken Features
- Search. Attempted to make the changes necessary to allow search to work from [this section](https://adityatelange.github.io/hugo-PaperMod/posts/papermod/papermod-features/#search-page), but including the `search.md` with the `search` layout caused the hugo server to fail to render the page.
  - This may be due to how I'm hosting the site, but the error first appeared when running locally so not entirely sure.
  - May come back to this later.

I may include a little post blurb about the music I'm listening to as I write these. Might make for a fun little time-capsule of my music tastes the longer I write.