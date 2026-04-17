# CLAUDE.md

## Project overview

Personal website for Mossa Merhi Reimert, hosted at cgmossa.github.io. Built with [Zola](https://www.getzola.org/) (v0.22+), a Rust-based static site generator.

## Build & dev commands

```sh
zola serve           # Dev server with live reload at http://127.0.0.1:1111
zola build           # Build to public/ (gitignored)
zola check           # Validate links and config without building
```

## Directory structure

- `config.toml` — Zola config (base URL, markdown settings, taxonomies)
- `content/` — Markdown content, organised into sections:
  - `_index.md` — Homepage (rendered by `templates/index.html`)
  - `blog/` — Blog posts, sorted by date, paginated. Uses `blog-page.html` template.
  - `cv/` — CV page with HTML markup for structured entries
  - `projects/` — Project cards with HTML markup
- `templates/` — Tera templates:
  - `base.html` — Shared layout (nav, footer, head)
  - `index.html` — Homepage
  - `section.html` — Generic section listing
  - `blog-page.html` — Blog post with reading time, tags, prev/next nav
  - `page.html` — Generic page
  - `404.html` — Custom 404
  - `tags/list.html`, `tags/single.html` — Tag taxonomy pages
- `sass/style.scss` — All styling (compiled by Zola)
- `static/` — Static assets (images go in `static/images/`)
- `.github/workflows/deploy.yml` — GitHub Actions: builds with Zola and deploys via GitHub Pages

## Adding a blog post

Create `content/blog/my-slug.md`:

```toml
+++
title = "Post Title"
date = 2026-04-11
description = "Short summary."
[taxonomies]
tags = ["rust", "r"]
+++

Post body in Markdown.
```

See `BLOG_GUIDE.md` for more detail.

## Writing style

- Avoid em-dashes (—) in content and documentation. Use commas, parentheses, or rewrite the sentence instead.

## Key conventions

- Styling uses SCSS variables defined at the top of `sass/style.scss` (colours, fonts, max-width)
- CV and Projects sections use raw HTML in Markdown for structured layout (`.cv-entry`, `.project-card` classes)
- The nav highlights the active section via `current_path`
- Config enables: smart punctuation, emoji rendering, lazy image loading, heading anchor links, tag taxonomy with feeds
- Deployment is automatic on push to `main` via GitHub Actions
- `public/` is generated build output and should never be edited or touched by the LLM

## External links

- ORCID: https://orcid.org/0009-0007-9297-1523
- GitHub: https://github.com/cgmossa
- LinkedIn: https://www.linkedin.com/in/cgmossa
