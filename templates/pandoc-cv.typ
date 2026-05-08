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

#show: resume.with(
  author: "$author$",
$if(location)$  location: "$location$",
$endif$$if(email)$  email: "$email$",
$endif$$if(github)$  github: "$github$",
$endif$$if(linkedin)$  linkedin: "$linkedin$",
$endif$$if(personal-site)$  personal-site: "$personal-site$",
$endif$$if(accent-color)$  accent-color: $accent-color$,
$endif$)

$if(avatar)$
#place(
  top + right,
  dx: -0.5in,
  dy: -0.5in,
  box(
    clip: true,
    radius: 50%,
    image("$avatar$", width: 0.85in),
  ),
)
$endif$
$body$
