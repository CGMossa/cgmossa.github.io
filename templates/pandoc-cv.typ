// Pandoc typst template for the CV.
//
// Source: content/cv/_index.md -> pandoc --template=pandoc-cv.typ -> typst
// Do not edit the generated .typ file directly; edit the markdown and
// rebuild via `just cv-pdf`.

#import "@preview/basic-resume:0.2.9": *

$if(highlighting-definitions)$
$highlighting-definitions$

$endif$
#set smartquote(enabled: false)

#let cv-font = ("SF Pro Text", "Inter", "Helvetica Neue", "Helvetica", "Arial")

#let skill-chip(name) = box(
  fill: rgb("f6f8fa"),
  stroke: 0.5pt + rgb("d0d7de"),
  inset: (x: 6pt, y: 3pt),
  radius: 4pt,
  outset: (y: 2pt),
)[#name]

$if(avatar)$
#set page(
  header: context if counter(page).get().first() == 1 {
    place(top + right, dx: 0in, dy: 0in, box(
      clip: true,
      radius: 50%,
      image("$avatar$", width: 0.95in),
    ))
  },
)
$endif$

#show: resume.with(
  author: "$author$",
$if(location)$  location: "$location$",
$endif$$if(email)$  email: "$email$",
$endif$$if(github)$  github: "$github$",
$endif$$if(linkedin)$  linkedin: "$linkedin$",
$endif$$if(personal-site)$  personal-site: "$personal-site$",
$endif$$if(accent-color)$  accent-color: $accent-color$,
$endif$  font: cv-font,
)

#set text(size: 13pt, font: cv-font)

$body$
