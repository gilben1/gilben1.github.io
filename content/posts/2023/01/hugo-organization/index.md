---
title: "Hugo Organization: The Beginning"
description: "Rambling about how to organize this blog"
date: 2023-01-23T18:28:42-08:00
publishDate: 2023-01-23T18:28:42-08:00
draft: false
tags: ["Hugo", "Tutorial", "Process"]
ShowToc: false
TocOpen: false
---

### Getting started with this whole "Blog" thing
Starting to play around with blog-writing, getting a format down for organizing the posts is quickly becoming key. Hugo lets you throw all sorts of pages under content in an easy to publish way, meaning I can control the structure of the project simply through the file structure.

#### First Iteration
The first attempt just threw everything (sure, I guess you could call a single post "everything") under one "posts" folder, where the name of the post was the filename.
```
content
|--posts
   |--1-21-23.md
|--<other non-post pages like the Archive and Projects>
```

Creating an additional post today, I realized that this was not going to be sustainable. I needed to reorganize.

#### Second Iteration
Having each post be a single markdown file would be pretty limiting. Let's allow other files by making the post be a folder instead.
```
content
|--posts
   |--1-21-23
      |--index.md
|--<other non-post pages like the Archive and Projects>
```
A little better, now I could throw in embedded images or other files within the folder and still have it be cohesive to the post.

But what about as I add more posts? Surely I'd want to group the posts in some way. How about by year and month?

#### Current Iteration
```
content
|--posts
   |--2023
      |--01
         |--1-21-23
            |--index.md
         |--hugo-organization
            |--index.md
|--<other non-post pages like the Archive and Projects>
```

This is the organization I've settled on for now. This allows me to group posts by general date without being too specific, which allows me to separate old posts from new at a glance when developing and publishing new posts. I can even specify the full output content path using the hugo content tool.
```
hugo new --kind post posts/2023/01/hugo-organization/index.md
```
            
Related to organization, I also modified the default generated archetype `archetypes/default.md` to be a bit more flexible without being too overbearing:
```
---
title: "{{ replace .Name "-" " " | title }}"
description: ""
date: {{ .Date }}
publishDate: {{ .Date }}
draft: true
tags: []
ShowToc: false
TocOpen: false
---
```

I might change this to a `posts.md` down the line, but for now I'm only really creating one kind of post so it's fine as a default for now.