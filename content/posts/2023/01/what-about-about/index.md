---
title: "What About About?"
description: "Something is missing, and I'm not sure what..."
date: 2023-01-28T10:02:20-08:00
publishDate: 2023-01-28T10:02:20-08:00
draft: false
tags: ["Hugo", "Blog", "PaperMod", "Music"]
---

### Something Missing This Way Comes

The blog is starting to take form, and I'm realizing that blindly creating a blog without referencing other blogs / portfolios is showing that I really don't know what needs to go into a blogfolio. So I started looking at other blogs.

The blog part is largely there, thanks to the Hugo framework and the PaperMod theme. I've got entries that are easy to spin up in Markdown, an archive page to view old stuff by year and month, and a tags system that allows for filtering posts by general content. But what about the portfolio side?

Hmm, stuff that I've worked on previously, check. I've got the [projects](https://gilbertdev.net/projects/) page that outlines various things I've worked on. An easy port from the old Elm site.

And....

Well....

Not much else. A little blurb on the home page, that basically says "Hello, I'm a blog, look at me!"

Then it hit me. Anyone reading this won't know anything about me! That's not ideal, let's change that.

### The About Page
...is not done yet. I've set up the framework *for* an eventual about page, including a commented out section of the configuration for the about menu, but not much else. 
```
content
|--about
   |--index.md
```

It doesn't feel right to have a half-published about page, so I won't publish it until I'm happy with an initial version. So for now, you get a rambling about an about page that has yet to be.

### Other Small Changes

#### Home Page Mini-Refresh

I've refreshed the blurb on the home page to have a little bit of formatting. The missing piece was multi-line YAML strings, which as it turns out, there are like 10 different ways to do.

The home page content is defined in the `config.yaml`, under the `homeInfoParams` key, that controls the whole site, which is needed for formatting and including the nice baked in social media icons.

{{< figure src="icons.png" caption="Yep, those are icons" align=center >}}

You can define a homepage by creating a `_index.md` at the root of `content`, but it makes the social media icons drift way down in a way I haven't been able to fix. So I'm limited to the definition in the `config.yaml` unless I decide to recreate the icons manually.

How it looks using `_index.md`:

{{< figure src="out_config.png" caption="So much space :(" align=center >}}

And defined in `config.yaml`:

{{< figure src="in_config.png" caption="Much better, unfortunately" align=center >}}

#### Colors Adjustment

Remember how I made a change to the color scheme a few days ago? I've adjusted the scheme further out of that base theme I found. If you prefer light mode, you won't see these changes, it only impacts dark mode.

The original scheme used a dark grey for code blocks, which impacted the bottom bar for navigation. I didn't mind the code blocks being the dark grey, but the navigation bar stood out like a sore thumb. Luckily, a better color was already set in the `entry` key, so I just took that and copied it over.

Here's what it looked like before:
{{< figure src="old_colors1.png" caption="Code blocks - Old" align=center >}}
{{< figure src="old_colors2.png" caption="Navigation Bar - Old" align=center >}}

And here's what it looks like now:
{{< figure src="new_colors1.png" caption="Code blocks - New" align=center >}}
{{< figure src="new_colors2.png" caption="Navigation Bar - New" align=center >}}

#### Pagination!

The home page now paginates to five entries instead of one never-ending list. I think five is a good threshold, but may adjust it in the future.

### Music of the Day

I never would have guessed it, but I listened to Lil Yachty. He made a psych-rock rap album that dropped yesterday and it was actually good.

The new "The World is Quiet Here" album (Zon) rules. It's like Between the Buried and Me turned up to eleven.

I guess this is a footer for blogposts now. I'm listening through this grand list of albums with some friends and we're rating them daily. It spans genres from hip-hop, jazz, electronica, metal, and more. It's been a good kick in the ass to get out my comfort zone for music