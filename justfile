set shell := ["bash", "-cu"]

default:
    @just --list

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
