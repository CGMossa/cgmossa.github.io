# CLAUDE.md

## Project overview

Personal website for Mossa Merhi Reimert, hosted at cgmossa.github.io. Built with [Zola](https://www.getzola.org/) (v0.22+), a Rust-based static site generator. The CV page also produces a downloadable PDF rendered via pandoc + typst.

## Build & dev commands

```sh
just serve           # Live-reload dev server at http://127.0.0.1:1111 (alias: zola serve)
just build           # Build site to public/ (gitignored)
just check           # Validate links and config without building
just cv-pdf          # Build cv.typ + static/cv.pdf from content/cv/_index.md
just clean-cv-pdf    # Remove cv.typ, .build/, static/cv.pdf
just markdownlint    # Lint content markdown
just new-blog <slug> # Scaffold a new blog post draft
```

## Directory structure

- `config.toml`: Zola config (base URL, markdown settings, taxonomies)
- `content/`: Markdown content, organised into sections:
  - `_index.md`: Homepage (rendered by `templates/index.html`)
  - `blog/`: Blog posts, sorted by date, paginated. Uses `blog-page.html` template.
  - `cv/`: CV page with Zola shortcodes (`cv_entry`, `icon_link`, `skills`) for structured entries
  - `projects/`: Project cards with HTML markup
- `templates/`: Tera templates:
  - `base.html`: Shared layout (nav, footer, head)
  - `index.html`: Homepage
  - `section.html`: Generic section listing; renders the CV download icon next to the H1 on `/cv/`
  - `blog-page.html`: Blog post with reading time, tags, prev/next nav
  - `page.html`: Generic page
  - `404.html`: Custom 404
  - `tags/list.html`, `tags/single.html`: Tag taxonomy pages
  - `pandoc-cv.typ`: Pandoc typst template wrapping `@preview/basic-resume:0.2.9` (used by `just cv-pdf`)
  - `shortcodes/`: Zola shortcodes (`cv_entry`, `icon_link`, `skills`, `hero`, `project_card`)
- `scripts/`:
  - `cv-shortcodes.lua`: Pandoc lua filter that rewrites Zola shortcodes into typst structure when generating the PDF
- `sass/style.scss`: All styling (compiled by Zola)
- `static/`: Static assets (images go in `static/images/`, icons in `static/icons/`). `static/cv.pdf` is generated and gitignored.
- `cv.typ`: Generated typst source for the CV PDF. Tracked in git so the latest build is always inspectable.
- `.build/`: Intermediate build directory for `cv.md` (gitignored)
- `justfile`: Build recipes
- `.github/workflows/deploy.yml`: GitHub Actions, installs zola + pandoc + typst, builds the CV PDF, then `zola build`, then deploys via GitHub Pages

## CV PDF pipeline

The CV PDF is regenerated on every push by GitHub Actions and locally via `just cv-pdf`. The flow:

1. `sed` strips the TOML frontmatter and `<figure class="cv-margin-photo">…</figure>` blocks from `content/cv/_index.md` into `.build/cv.md`.
2. `pandoc` converts `.build/cv.md` to `cv.typ` using `templates/pandoc-cv.typ` and `scripts/cv-shortcodes.lua`. The lua filter:
   - Rewrites `{% cv_entry(title=…, org=…, meta=…) %}…{% end %}` and the inline `{{ cv_entry(...) }}` form into either `#edu(...)` (in Education), `#work(...)` (in Experience and Research Software), or a generic `### Title` + emphasised meta line.
   - Wraps the Conferences section as a `#grid(columns: 2, ...)` and Coursework as `#grid(columns: 3, ...)` with smaller body text, one cell per `cv_entry`.
   - Flattens the Links bullet list into a single `#align(center)[…]` line.
   - Replaces the `{{ skills(list="…") }}` shortcode with one `#skill-chip("…")` call per item (helper defined in the typst template).
   - Prefixes Online Learning items with platform icons (DataCamp, Exercism) using `static/icons/*.svg`.
   - Drops `<figure class="cv-margin-photo">` blocks that pandoc parses as raw HTML.
   - Rewrites inline `{{ icon_link(...) }}` calls (e.g. inside the Links list) into plain markdown links.
3. `typst compile --root . cv.typ static/cv.pdf` produces the PDF, which Zola serves at `/cv.pdf`.

The pandoc typst template (`templates/pandoc-cv.typ`):
- Imports `@preview/basic-resume:0.2.9` and uses its `resume`, `edu`, `work`, and `generic-two-by-two` helpers.
- Defines a `skill-chip(name)` helper used by the lua filter.
- Sets the page header (cartoon avatar in a circular `box` on the first page only, gated by `#counter(page)`) before the basic-resume show rule, since typst needs the header before page 1 begins layout. All other style overrides (text size, smartquote, font fallback chain) are applied after the show rule so they cascade over basic-resume's defaults.

The font fallback chain prefers `SF Pro Text` / `Inter` / `Helvetica Neue`. Locally the macOS Helvetica Neue picks up; CI falls back further.

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
