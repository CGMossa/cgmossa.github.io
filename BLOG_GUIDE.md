# How to add a blog post

## 1. Create a new file

Add a Markdown file in `content/blog/`. The filename becomes the URL slug.

```
content/blog/my-post-title.md  →  cgmossa.github.io/blog/my-post-title/
```

## 2. Add frontmatter

Every post starts with a `+++` block:

```toml
+++
title = "My Post Title"
date = 2026-04-11
description = "A short summary shown in the post list."
+++
```

- `title` — required
- `date` — required, determines sort order (newest first)
- `description` — optional, shown under the title in the blog listing

### Optional frontmatter fields

```toml
draft = true          # hide from the published site
updated = 2026-04-15  # show an "updated" date
[taxonomies]
tags = ["rust", "r"]
```

Note: tags won't render until you add a taxonomy template, but Zola will index them.

## 3. Write the post body

Everything after the closing `+++` is standard Markdown:

```markdown
+++
title = "Rust and R: A Love Story"
date = 2026-04-11
description = "Why I think Rust is the best companion language for R."
+++

This is the intro paragraph.

## A heading

Some text with **bold** and `inline code`.

​```rust
fn main() {
    println!("Hello from Rust!");
}
​```

A [link](https://example.com) and an image:

![alt text](/images/photo.png)
```

## 4. Adding images

Put images in `static/images/` and reference them with an absolute path:

```markdown
![my diagram](/images/my-diagram.png)
```

## 5. Preview locally

```sh
zola serve
```

Open http://127.0.0.1:1111 — the page live-reloads on save.

## 6. Publish

```sh
git add content/blog/my-new-post.md
git commit -m "blog: my new post"
git push
```

GitHub Actions builds and deploys automatically.

## Re-enable the blog section

If the blog index page is disabled, set `render = true` in `content/blog/_index.md`
to make `/blog/` render again, and set `show_blog_in_nav = true` under
`[extra]` in `config.toml` to show the Blog link in the site navigation again.
Existing posts in `content/blog/` stay on disk either way.
