---
title: "Scratch That, New Visit Counter"
description: "Or, when you want a dash of analytics with your view counts"
date: 2023-02-23T20:56:06-08:00
publishDate: 2023-02-23T20:56:06-08:00
draft: true
tags: ["Hugo", "Blog", "Visitors", "Viewcount"]
---

### How to Implement A Solution, See a Better Solution, and Chase that Solution

So it turns out I dropped the github markdown-style viewcounts pretty much immediately after adding them to the site. I did this around a day after the last post, but just got caught up in work and other life events and didn't write a post about it.

This came down to that [same blog post](https://ravichaganti.com/blog/adding-visitor-counter-to-statically-generated-web-pages/) as the last post. I noticed that even though the blog talked about the visitor badge from [glitch.me](https://visitor-badge.glitch.me/), that sites own view counters were different. Nicer, more embedded to the site's theme, just better overall.

{{< figure src="viewcount_quandry.png" caption="Hey that's not what you're describing" align=center >}}

I opened the dev-console on that site to see what the implementation might be. Inspecting the element directly showed just the value we see on screen, so the HTML of the document would have to populated through a script.

{{< figure src="inspect_view.png" caption="Numbers" align=center >}}

Looking at the console I saw some warnings about failing to load a script from "https://gc.zgo.at/count.js", following which opened the script indicating it came from [https://www.goatcounter.com/](https://www.goatcounter.com/). This was all the breadcrumbs I needed, now I could add it.

#### Immediate Draws

After seeing what the solution was, I could determine whether or not I wanted to actually use it. Actually, didn't take long, this thing was a) free, b) open source, and c) had analytics. That's all I needed to see.

### Step 1. Counting Views
The first step was extremely simple, the goatcounter setup makes it very straightforward to hook up goatcounter into the site. All it needed was some basic configuration on the goatcounter site (namely the root URL of the site to track), and a simple script to embed on the pages we want to track. I wanted to track the views on every site, so I just embedded the supplied script block on the `extend_footer.html` part of the Hugo partial layout, which injects the script at the `footer` element of every page on the site.

```
<script data-goatcounter="https://gilben1.goatcounter.com/count"
        async src="//gc.zgo.at/count.js"></script>
```

After some fiddling, I was able to get some views to show up in the dashboard. I use uBlock origin for ad-blocking, and since goatcounter is technically a tracker, it was blocking by default, so I had to temporarily disable to get the views to count and show up.

{{< figure src="goat_graphs.png" caption="Views Populating" align=center >}}

### Step 2. Showing the Views
We're collecting the views, now we want to get a nice little counter somewhere on each post's page. I chose right up near the post meta-data as the counter spot (right by the author, date, read time, etc) as the spot for the views. I originally was planning to play nice with Hugo using shortcodes and the deep built-in partial layouts but due to a limitation in how goatcounter tracks pages and the Hugo standard variables I was unable to, so I had to set it just below.

{{< figure src="counter.png" caption="New Counter" align=center >}}

Now, getting it to actually do this, I had to do a few things. 

First, goatcounter provides some fairly flexible code snippets for grabbing the data from goatcounter to display. The initial one appends a pre-generated element to some part of the page, but left little configuration for how it looks. The second pulls an image from a direct URL corresponding to a the current page. Again, little configuration, but also couldn't embed super cleanly.

The snippet I went with returned the data in JSON format, that I could then put wherever I wanted.
```
<div>Number of visitors: <div id="stats"></div></div>

<script>
    var r = new XMLHttpRequest();
    r.addEventListener('load', function() {
        document.querySelector('#stats').innerText = JSON.parse(this.responseText).count
    })
    r.open('GET', 'https://<HOSTNAME>.goatcounter.com/counter/' + encodeURIComponent(location.pathname) + '.json')
    r.send()
</script>
```

I modified this a bit to work with some Hugo-centric configurations, but the gist is the script loads the data, and on load updates the contents of a div named `stats`.
```
 <span>
      Views: 
      <span id="stats">
          0
          <script>
              var r = new XMLHttpRequest();
              r.addEventListener('load', function() {
                  document.querySelector('#stats').innerText = JSON.parse(this.responseText).count
              })
              let countpath = "{{ .RelPermalink }}".slice(0,-1)
              r.open('GET', 'https://gilben1.goatcounter.com/counter/' + countpath + '.json')
              r.send()
          </script>
      </span>
    </span>
```
The modifications I made are around what path gets passed to the request. Goatcounter tracks pages by relative path to the root URL. The detail to notice, however, is it explicitly doesn't include a trailing `/`, like all of the URLs I use have. This becomes a problem, because the `{{ .RelPermaLink }}` parameter shortcode always does. Since the nicely split formatted stuff is built out of [Hugo scratch](https://gohugo.io/functions/scratch/), which has its own way of generating content, I couldn't figure out how to actually post-process the `{{ .RelPermaLink }}`. Scratch does have some functions for stripping from strings, but they didn't seem to work with non-static values.

The only real change I ended up making, from the provided snippet, was using `{{ .RelPermaLink }}` to get the relative URL, and using the JS function `.slice` to remove the trailing `/`. Et voila, the view counts work.

### Bonus: No, I haven't forgotten about About

I just haven't found time to write it out :^)

Thanks for reading.