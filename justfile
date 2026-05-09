set shell := ["bash", "-cu"]

default:
    @just --list

# Live-reload dev server at http://127.0.0.1:1111
serve:
    zola serve

# Build site to public/ (gitignored)
build:
    zola build

# Validate links and config without building
check:
    zola check

markdownlint:
    npx --yes markdownlint-cli "content/**/*.md"

new-blog slug title='' description='':
    #!/usr/bin/env bash
    set -euo pipefail

    file="content/blog/{{slug}}.md"
    if [[ -e "$file" ]]; then
      echo "$file already exists" >&2
      exit 1
    fi

    post_title='{{title}}'
    if [[ -z "$post_title" ]]; then
      post_title="$(printf '%s' '{{slug}}' | tr '-' ' ' | sed -E 's/(^|[[:space:]])([[:alpha:]])/\1\U\2/g')"
    fi

    post_description='{{description}}'
    post_date="$(date +%F)"

    cat > "$file" <<EOF
    +++
    title = "$post_title"
    date = $post_date
    description = "$post_description"
    draft = true
    +++

    EOF

    printf 'Created %s\n' "$file"

# --- CV PDF ---

build_dir := ".build"

# Build static/cv.pdf from content/cv/_index.md via pandoc + typst.
# Requires: pandoc 3.x (with typst writer), typst.
cv-pdf:
    #!/usr/bin/env bash
    set -euo pipefail
    mkdir -p {{build_dir}}
    # Strip TOML frontmatter (pandoc only knows YAML) and the
    # margin-photo figures (multi-line HTML pandoc fragments badly).
    sed -e '/^+++$/,/^+++$/d' \
        -e '/<figure class="cv-margin-photo"/,/<\/figure>/d' \
        content/cv/_index.md > {{build_dir}}/cv.md
    pandoc {{build_dir}}/cv.md -o cv.typ -t typst \
        --template=templates/pandoc-cv.typ \
        --lua-filter=scripts/cv-shortcodes.lua \
        --from=markdown-smart \
        --standalone --wrap=none \
        -V author="Mossa Merhi Reimert" \
        -V location="Copenhagen, Denmark" \
        -V email="mossa@a2-ai.com" \
        -V phone="+45 25 71 13 42" \
        -V phone-url="tel:+4525711342" \
        -V github="github.com/cgmossa" \
        -V linkedin="linkedin.com/in/cgmossa" \
        -V personal-site="ministats.dev" \
        -V orcid="0009-0007-9297-1523" \
        -V avatar="/static/images/mossa-avatar-normal.png"
    typst compile --root . cv.typ static/cv.pdf
    echo "static/cv.pdf — $(du -h static/cv.pdf | cut -f1 | tr -d ' ')"

# Remove the generated PDF and intermediate cv.md output.
clean-cv-pdf:
    rm -rf {{build_dir}}
    rm -f static/cv.pdf cv.typ
