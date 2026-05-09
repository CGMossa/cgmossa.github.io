// Pandoc typst template for the CV.
//
// Source: content/cv/_index.md -> pandoc --template=pandoc-cv.typ -> typst
// Do not edit the generated .typ file directly; edit the markdown and
// rebuild via `just cv-pdf`.

#import "@preview/fontawesome:0.6.0": *
#import "@preview/linguify:0.5.0": *
#import "@preview/scienceicons:0.1.0": orcid-icon

$if(highlighting-definitions)$
$highlighting-definitions$

$endif$

#let cv-font = "Avenir Next"
#let cv-accent = rgb("1f6f78")
#let cv-link = rgb("6f42c1")
#let cv-muted = rgb("57606a")
#let cv-border = rgb("d0d7de")

#let skill-chip(name) = box(
  fill: rgb("f6f8fa"),
  stroke: 0.45pt + cv-border,
  inset: (x: 6pt, y: 3pt),
  radius: 4pt,
  outset: (y: 1.8pt),
)[#name]

#set page(
  paper: "a4",
  margin: (x: 0.58in, y: 0.54in),
)
#set document(author: "$author$", title: "$author$")
#set smartquote(enabled: false)
#set text(size: 10.25pt, font: cv-font, lang: "en", ligatures: false)
#set par(justify: true, leading: 0.54em)
#set list(indent: 0.72em, body-indent: 0.36em, spacing: 0.32em)

#show link: set text(fill: cv-link)
#show strong: set text(weight: 300)

#show heading.where(level: 2): it => block(above: 0.7em, below: 0.32em)[
  #grid(
    columns: (auto, 1fr),
    column-gutter: 0.7em,
    align: horizon,
    [#text(size: 10.5pt, weight: 500, fill: cv-accent)[#smallcaps(it.body)]],
    [#line(length: 100%, stroke: 0.65pt + cv-border)],
  )
]

#show heading.where(level: 3): it => block(above: 0.58em, below: 0.16em)[
  #text(size: 10.45pt, weight: 500, fill: cv-accent)[#it.body]
]

#let field(value) = {
  if value == none or value == "" { [] } else { value }
}

#let has-field(value) = value != none and value != ""

#let contact-item(value, prefix: none, url: none) = {
  if value == none or value == "" {
    none
  } else if url == none or url == "" {
    value
  } else if prefix == none {
    link(url)[#value]
  } else {
    link(url)[#prefix#value]
  }
}

#let contact-icon(path) = box(
  width: 0.9em,
  height: 0.9em,
  baseline: 16%,
  image(path, width: 0.9em, height: 0.9em),
)

#let contact-with-icon(path, body) = box[
  #contact-icon(path)#h(0.22em)#body
]

#let entry(title: none, dates: none, company: none, location: none) = block(
  above: 0.52em,
  below: 0.12em,
)[
  #grid(
    columns: (1fr, auto),
    column-gutter: 1em,
    align: (left, right + top),
    [
      #if has-field(title) [
        #text(size: 10.6pt, weight: 500)[#title]
      ]
      #if has-field(company) or has-field(location) [
        #v(-0.8em)
        #text(size: 9.3pt, fill: cv-muted)[
          #if has-field(company) [#company]
          #if has-field(company) and has-field(location) [ #h(0.32em)·#h(0.32em) ]
          #if has-field(location) [#emph[#location]]
        ]
      ]
    ],
    [#if has-field(dates) [#text(size: 9.15pt, fill: cv-muted)[#dates]]],
  )
]

#let edu(
  institution: none,
  dates: none,
  degree: none,
  gpa: none,
  location: none,
  consistent: false,
) = entry(
  title: degree,
  dates: dates,
  company: institution,
  location: location,
)

#let work(
  title: none,
  dates: none,
  company: none,
  location: none,
) = entry(
  title: title,
  dates: dates,
  company: company,
  location: location,
)

#let generic-two-by-two(
  top-left: none,
  top-right: none,
  bottom-left: none,
  bottom-right: none,
) = entry(
  title: top-left,
  dates: top-right,
  company: bottom-left,
  location: bottom-right,
)

#let course-group(title, dates, body) = block(
  above: 0.42em,
  below: 0.15em,
)[
  #set par(leading: 0.5em, justify: true)
  #text(size: 8.4pt)[
    #text(weight: 500)[#title]
    #h(0.22em)#text(fill: cv-muted)[#dates]
    #h(0.38em)#text(fill: cv-muted)[#body]
  ]
]

#let link-icon(path, body) = box[
  #box(baseline: 16%, image(path, height: 0.85em))#h(0.22em)#body
]

#grid(
  columns: (1fr, auto),
  column-gutter: 1em,
  align: horizon,
  [
    #text(size: 21pt, weight: 500)[$author$]
    #v(0.24em)
    #text(size: 8.35pt, fill: cv-muted)[
      #grid(
        columns: (auto, auto, auto, auto),
        column-gutter: 1em,
        row-gutter: 0.28em,
        align: left + horizon,
$if(phone)$        contact-item([$phone$]$if(phone-url)$, url: "$phone-url$"$endif$),
$endif$$if(location)$        [$location$],
$endif$$if(email)$        contact-item(contact-with-icon("/static/icons/mail.svg", [#("$email$")]), url: "mailto:$email$"),
$endif$$if(personal-site)$        contact-item([$personal-site$], url: "https://$personal-site$"),
$endif$$if(github)$        contact-item(contact-with-icon("/static/icons/github.svg", [GitHub]), url: "https://$github$"),
$endif$$if(linkedin)$        contact-item(contact-with-icon("/static/icons/linkedin.svg", [LinkedIn]), url: "https://$linkedin$"),
$endif$$if(orcid)$        contact-item(
          [ORCID],
          prefix: [#orcid-icon(color: cv-link, height: 0.95em)#h(0.18em)],
          url: "https://orcid.org/$orcid$",
        ),
$endif$        [],
      )
    ]
  ],
$if(avatar)$  [
    #box(
      clip: true,
      radius: 4em,
      stroke: 0.8pt + cv-border,
      fill: rgb("f6f8fa"),
      image("$avatar$", width: 6em),
    )
  ],
$endif$)
#v(0.4em)
#line(length: 100%, stroke: 0.65pt + cv-border)
#v(0.58em)

$body$
