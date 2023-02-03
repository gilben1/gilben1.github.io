---
title: "Enter Automation"
description: "When remembering how to make a post is too much work"
date: 2023-02-02T15:50:15-08:00
publishDate: 2023-02-02T15:50:15-08:00
draft: false
tags: ["Automation", "Scripts", "Bash", "Hugo"]
---

#### Automation

Until today, I've been generating new posts by looking at the clock and figuring out which month to nest a new post under, then using an explicit call to `hugo new` with the expected path and output file name. This already did most of the work for me, since it draws from the `default.md` archetype file, but even that was prone to dumb human error.

As a result, I decide to crack my knuckle and dig back into the ugly-ish world of bash scripting. I did a ton of this when I was in college interacting with the school's linux systems but have fallen out style since my current work is predominantly Windows and PowerShell. Luckily, the amount I wanted to automate (at least for now) is small enough to not run to bash's syntax nightmare fuel.

All I want this to do is remove the thinking around the whole path structure, include the month and year, and just generate based on a title that I pass into the script. Seemed simple enough, and it totally was.

```
#!/bin/bash
printf -v year '%(%Y)T' -1
printf -v month '%(%m)T' -1

hugo new --kind post posts/$year/$month/$1/index.md
```

All I needed was the `year` and `month` from the current date. [This Stack Overflow post](https://stackoverflow.com/questions/1401482/yyyy-mm-dd-format-date-in-shell-script) gave me exactly what I needed, with the `printf` formatting wizardry. That coupled with a simple reference to `$1` was enough to craft this simple little script.

Instead of having to type out:
```
hugo new --kind post posts/2023/02/enter-automation/index.md
```

I could instead just invoke the script like this:
```
./scripts/make-post.sh enter-automation
```

A lot simpler, and allows me to focus on titling without having to consider the overall structure. I'll probably expand upon this to auto-populate tags and descriptions in the markdown header automatically, but that may be too much for what I really want to do at the end of the day.

#### About Me Still WIP

The about me page is still in progress, just haven't gotten around to it. Will still be a while.

#### Music

You like jazz?

Today was `Brilliant Corners` by `Thelonious Monk`, and what an album that was. Definitely appreciated this one more than the other two jazz albums we've covered so far in our journey, landing at 4 / 5.
