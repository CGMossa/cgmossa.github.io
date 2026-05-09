// Pandoc typst template for the CV.
//
// Source: content/cv/_index.md -> pandoc --template=pandoc-cv.typ -> typst
// Do not edit the generated .typ file directly; edit the markdown and
// rebuild via `just cv-pdf`.

#import "@preview/fontawesome:0.6.0": *
#import "@preview/linguify:0.5.0": *
#import "@preview/scienceicons:0.1.0": orcid-icon


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
#set document(author: "Mossa Merhi Reimert", title: "Mossa Merhi Reimert")
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
    #text(size: 21pt, weight: 500)[Mossa Merhi Reimert]
    #v(0.24em)
    #text(size: 8.35pt, fill: cv-muted)[
      #grid(
        columns: (auto, auto, auto, auto),
        column-gutter: 1em,
        row-gutter: 0.28em,
        align: left + horizon,
        contact-item([+45 25 71 13 42], url: "tel:+4525711342"),
        [Copenhagen, Denmark],
        contact-item(contact-with-icon("/static/icons/mail.svg", [#("mossa@a2-ai.com")]), url: "mailto:mossa@a2-ai.com"),
        contact-item([ministats.dev], url: "https://ministats.dev"),
        contact-item(contact-with-icon("/static/icons/github.svg", [GitHub]), url: "https://github.com/cgmossa"),
        contact-item(contact-with-icon("/static/icons/linkedin.svg", [LinkedIn]), url: "https://linkedin.com/in/cgmossa"),
        contact-item(
          [ORCID],
          prefix: [#orcid-icon(color: cv-link, height: 0.95em)#h(0.18em)],
          url: "https://orcid.org/0009-0007-9297-1523",
        ),
        [],
      )
    ]
  ],
  [
    #box(
      clip: true,
      radius: 4em,
      stroke: 0.8pt + cv-border,
      fill: rgb("f6f8fa"),
      image("/static/images/mossa-avatar-normal.png", width: 6em),
    )
  ],
)
#v(0.4em)
#line(length: 100%, stroke: 0.65pt + cv-border)
#v(0.58em)

== Summary
<summary>
Senior Scientific Software Engineer at #link("https://a2-ai.com")[A2-Ai]. PhD in Veterinary Epidemiology and MSc in Statistics from the University of Copenhagen, with additional undergraduate degrees in Mathematics (statistics major) and Science & IT (computational physics). Over a decade of experience spanning statistical modelling, scientific computing, academic research, teaching, and software development. Core maintainer of #link("https://github.com/extendr/extendr")[extendr] and active open-source contributor in the Rust and R ecosystems. Published in journals including the Journal of Theoretical Biology, JOSS, and Preventive Veterinary Medicine, and presented at international conferences in veterinary epidemiology, spatial modelling, and scientific computing.

== Highlights
<highlights>

#[#set list(spacing: 0.7em)
- Build and maintain R and Rust tooling that needs to be fast, reliable,
  and ready for real use
- Bring a deep foundation in mathematics, probability theory, and
  statistics, from measure theory and stochastic processes to Bayesian
  inference and causal reasoning
- Turn research questions into statistical models and then into
  maintainable software
- Develop disease-spread models across wildlife and livestock
  populations, with work on spatial discretisation, surveillance, and
  control strategies
- Work effectively across institutions, disciplines, and international
  collaborations
- Teach and communicate effectively across researchers, developers, and
  students, from university courses to international conference talks
]
== Education
<education>

#block[#edu(
  institution: "University of Copenhagen",
  dates: "2019–2024",
  degree: "PhD in Veterinary Epidemiology",
)]
- Modelled the spread of African Swine Fever between wild boar and domestic pigs
- Worked on simulator-based inference, ordinary differential equations, and wildlife-livestock interface problems
- Relevant coursework included epidemiology, spatial data analysis, network analysis, and targeted maximum likelihood estimation

#block[#edu(
  institution: "University of Copenhagen",
  dates: "2016–2018",
  degree: "MSc in Statistics",
)]

#block[#edu(
  institution: "University of Copenhagen",
  dates: "2013–2015",
  degree: "BSc in Mathematics",
)]
Statistics as study major.

#block[#edu(
  institution: "University of Copenhagen",
  dates: "2010–2013",
  degree: "BSc in Science and IT",
)]
Specialisation in computational physics.

== Experience
<experience>

#block[#work(
  title: "Senior Scientific Software Engineer",
  dates: "2025–Present",
  company: "A2-Ai",
)]
- Build scientific software and technical workflows in domains where modelling, data, and product constraints meet
- Work across implementation, design, and collaboration boundaries to turn prototype code into maintainable systems

#block[#work(
  title: "Postdoctoral Researcher",
  dates: "2024–2025",
  company: "University of Copenhagen",
)]
- Specialised in computational modelling of disease spread, surveillance, and control in an economic context
- Developed modelling software and R packages for applied epidemiological research

#block[#work(
  title: "External Lecturer",
  dates: "Copenhagen · Spring 2025",
  company: "DIS Study Abroad",
)]
- Taught \"Artificial Neural Networks and Deep Learning\"

#block[#work(
  title: "Research Assistant",
  dates: "2021–2022",
  company: "University of Copenhagen",
)]
- Worked on the NordForsk-funded DigiVet project on facilitating registry data between authorities, stakeholders, and citizens
- Coordinated data requirements across multiple stakeholders and improved data quality in research workflows

#block[#work(
  title: "Lecturer / Researcher",
  dates: "2018–2019",
  company: "Applied Science University of Amsterdam",
)]
- Conducted research in the Live Game Design project in collaboration with Knowingo+
- Modelled player experience using statistical methods and visualisation

#block[#work(
  title: "Student Developer",
  dates: "2016–2017",
  company: "Inference Labs",
)]
- Developed a serious game in Unity3D and C\# for teaching the PRINCE2 project-management methodology

#block[#work(
  title: "Data Scientist",
  dates: "2015–2016",
  company: "SHFT ApS",
)]
- Transformed inertial motion sensor data into KPIs describing running technique
- Worked with MATLAB, signal processing, sensor fusion, visualisation, and C\# / Xamarin

#block[#work(
  title: "Teaching Assistant",
  dates: "2011–2018",
  company: "University of Copenhagen",
)]
- Held TA roles across a seven-year span (2011--2018), totalling roughly two years of cumulative teaching alongside studies and other work
- Taught across databases and web programming, programming and problem solving, data mining, statistics, numerical analysis, and modelling
- Supported both undergraduate and graduate teaching, including theoretical statistics

#block[#work(
  title: "Participant, Kod i Ferien",
  dates: "2011–2012",
  company: "Danish Agency for Digitisation",
)]
- Participated twice in Kod i Ferien, a Danish programme comparable to Google Summer of Code
- Planned and implemented a web-backend product using Django and NemHandel
- Worked with open-government initiatives through #link("https://digitaliser.dk/")[digitaliser.dk]

#block[#work(
  title: "Student Worker",
  dates: "2010–2013",
  company: "Danish Science Factory",
)]
- Planned and executed meetings, conferences, and related events
- Handled database entry and administrative support tasks

#block[#work(
  title: "Sales Assistant",
  dates: "2010",
  company: "Netto / Dansk Supermarked",
)]
== Publications
<publications>
=== Peer-reviewed
<peer-reviewed>

#[#set list(spacing: 0.78em)
#set par(leading: 0.62em)
- #strong[Modelling PRRS transmission between pig herds in Denmark and
  prediction of interventions impact] (2025).
  #link("https://doi.org/10.1016/j.prevetmed.2025.106692")[doi:10.1016/j.prevetmed.2025.106692]
- #strong[Choice of landscape discretisation method affects the inferred
  rate of spread in wildlife disease spread models] (2025).
  #link("https://doi.org/10.1016/j.jtbi.2024.111963")[doi:10.1016/j.jtbi.2024.111963]
- #strong[extendr: Frictionless bindings for R and Rust] (2024).
  #link("https://doi.org/10.21105/joss.06394")[doi:10.21105/joss.06394]
- #strong[Social network analysis reveals the failure of between-farm
  movement restrictions to reduce Salmonella transmission] (2024).
  #link("https://doi.org/10.3168/jds.2023-24554")[doi:10.3168/jds.2023-24554]
- #strong[Using registry data to identify individual dairy cows with
  abnormal patterns in routinely recorded somatic cell counts] (2024).
  #link("https://doi.org/10.1016/j.jtbi.2023.111718")[doi:10.1016/j.jtbi.2023.111718]
]
=== Preprints and submitted
<preprints-and-submitted>

#[#set list(spacing: 0.78em)
#set par(leading: 0.62em)
- #strong[Assessing the Spatial and Temporal Risk of HPAIV Transmission
  to Danish Cattle via Wild Birds] (2025).
  #link("https://doi.org/10.48550/arXiv.2504.12432")[arXiv:2504.12432]
- #strong[Spatial discretisation and anonymisation in R using CORINE
  land cover data and the hexscape package], with Matt Denwood,
  #strong[Mossa Merhi Reimert], Carlijn Bogaardt, Maya Katrin Gussmann,
  Carsten Thure Kirkeby and Jess Enright. #emph[Submitted to Preventive
  Veterinary Medicine.]
]
=== In preparation
<in-preparation>

#[#set list(spacing: 0.78em)
#set par(leading: 0.62em)
- #strong[Habitat-centric clustering of wildlife populations: methods
  and implications for the population dynamics of wild boar], with
  #strong[Mossa Merhi Reimert], Maya Katrin Gussmann, Anette Ella
  Boklund, Philip Rasmussen and Matt Denwood. #emph[In preparation for
  Ecological Modelling.]
]
== Research Software
<research-software>

#block[#work(
  title: "extendr",
  dates: "Core maintainer · 2020–Present",
  company: "github.com/extendr/extendr",
)]
Frictionless bindings between R and Rust. Core maintainer of the project and the wider tooling around the R-Rust bridge. Published in JOSS (#link("https://doi.org/10.21105/joss.06394")[doi:10.21105/joss.06394]) and supported by an R Consortium ISC grant for modern OOP tooling.

#block[#work(
  title: "miniextendr",
  dates: "Author · 2024–Present",
  company: "github.com/cgmossa/miniextendr",
)]
A Rust-R interoperability framework for building R packages with Rust backends. Includes ExternalPtr wrappers, ALTREP support, and CRAN-ready packaging.

#block[#work(
  title: "hexscape",
  dates: "Co-author",
  company: "R package",
)]
Spatial discretisation and anonymisation in R using CORINE land cover data. Companion to the submitted Preventive Veterinary Medicine manuscript.

== Grants
<grants>
- Accepted by the R Consortium Infrastructure Steering Committee (ISC) for #strong[\"extendr: Modern OOP tools\"] (2025), covering the `vctrs/S3 Support` and `S7 Support` milestones

== Teaching Portfolio
<teaching-portfolio>

#block[#work(
  title: "External Lecturer, Artificial Neural Networks and Deep Learning",
  dates: "Copenhagen · Spring 2025",
  company: "DIS Study Abroad",
)]
- Designed and delivered an upper-division course on artificial neural networks and deep learning for visiting international students
- Covered foundations through modern architectures, with hands-on implementation work alongside the theoretical material

#block[#work(
  title: "Teaching Assistant",
  dates: "2011–2018",
  company: "University of Copenhagen",
)]
Taught and supported a broad range of undergraduate and graduate courses in the Department of Mathematical Sciences and the Department of Computer Science, including:

- Databases and web programming
- Programming and problem solving
- Data mining
- Statistics 1 and 2 (theoretical statistics)
- Numerical analysis
- Modelling in science

Responsibilities spanned exercise sessions, problem-set design, grading, and one-on-one student support. Roughly two years of cumulative TA work spread across a seven-year span (2011--2018), held alongside studies and other roles.

== Conferences
<conferences>

#grid(
  columns: 1,
  gutter: 1em,
  [

#block[#work(
  title: "Typst Meetup Berlin 2026",
  dates: "Berlin · 28 February 2026 · 14:30 CET",
  company: "Typst",
)]
Attended.
  ],
  [

#block[#work(
  title: "Cascadia R Conf 2025",
  dates: "Portland, OR · 20 June 2025",
  company: "cascadiarconf.org",
)]
Co-authored
#link("https://josiahparry.github.io/2025-cascadia-rust-for-r-devs/")[workshop material]
with Josiah Parry for two workshops:
\"#link("https://cascadiarconf.org/2025/workshop/rust1/")[Intro to Rust for R Developers]\"
and
\"#link("https://cascadiarconf.org/2025/workshop/rust2/")[Building Rust based R Packages]\"
using extendr.
  ],
  [

#block[#work(
  title: "Scientific Computing in Rust 2024",
  dates: "18 July 2024 · Online",
  company: "scientificcomputing.rs",
)]
Talk: \"extendr: Frictionless bindings for R and Rust.\" Live and online
presentation (10 min). Hosted by organisers from University College
London (UK) and University of Colorado Boulder (USA).
  ],
  [

#block[#work(
  title: "GeoVet 2023",
  dates: "20 September 2023",
  company: "Silvi Marina, Teramo, Italy",
)]
Senior oral presentation (20 min + 5 min discussion): \"Choice of
Landscape Discretisation Affects the Rate of Spread in Wildlife Disease
Models.\" International Conference of Spatial Epidemiology,
Geostatistics and GIS applied to animal health, public health, and food
safety.
  ],
  [

#block[#work(
  title: "ISVEE 16",
  dates: "7–12 August 2022",
  company: "Halifax, Canada",
)]
Oral presentation: \"An ecological process-based model of wild boar.\"
16th International Symposium of Veterinary Epidemiology and Economics.
  ],
  [

#block[#work(
  title: "ModAH 2021",
  dates: "2 July 2021 · Online",
  company: "INRAE, Nantes, France",
)]
Talk: \"Influence of ecological processes within disease models.\" Live
presentation (webinar). Modelling in Animal Health conference.
  ],
  [

#block[#work(
  title: "Det 41. symposium i anvendt statistik",
  dates: "28–30 January 2019",
  company: "University of Copenhagen",
)]
Attended.
#link("https://www.statistiksymposium.dk/")[statistiksymposium.dk]
  ],
  [

#block[#work(
  title: "SAFJR 2019",
  dates: "2019",
  company: "",
)]
Attended.
  ],
)
== External Roles
<external-roles>
- Partner-sponsored developer at A2-Ai in the RSMF-backed project #link("https://blog.r-project.org/2025/12/17/rsmf-enabling-the-next-generation-of-contributors-to-r/")[Enabling the Next Generation of Contributors to R]

== Awards
<awards>
- Member of the winning team at Aarhus\' COVID-19 Datathon (2021), a weekend-long data-analysis challenge hosted jointly by MIT, Imperial College London, and Aarhus University

== Skills
<skills>

#skill-chip("R") #h(0.4em) #skill-chip("Rust") #h(0.4em) #skill-chip("Foreign Function Interface (FFI)") #h(0.4em) #skill-chip("Git & GitHub Actions") #h(0.4em) #skill-chip("MATLAB") #h(0.4em) #skill-chip("Python") #h(0.4em) #skill-chip("PyTorch") #h(0.4em) #skill-chip("C#") #h(0.4em) #skill-chip("C / C++") #h(0.4em) #skill-chip("Bash") #h(0.4em) #skill-chip("Typst") #h(0.4em) #skill-chip("Statistical modelling") #h(0.4em) #skill-chip("Scientific computing") #h(0.4em) #skill-chip("Technical teaching")
== Coursework
<coursework>

#[

#course-group([MSc in Statistics], [2016–2018], [Discrete Models\; Regression\; Project in Statistics\; Advanced Probability Theory 1\; Advanced Probability Theory 2\; Bayesian Statistics\; Causality\; Computational Statistics\; Monte Carlo Methods in Insurance and Finance\; Sparse Learning.])

#course-group([BSc in Mathematics], [2013–2015], [Discrete Mathematics\; Probability Theory and Statistics\; Algebra 1\; Geometry 1\; Analysis 2\; Measures and Integrals\; Statistics 1\; Statistics 2\; Stochastic Processes\; Graphical Models.])

#course-group([BSc in Science & IT], [2010–2013], [Introduction to Mathematics for Science\; Modelling in Science\; Linear Algebra in Science\; Programming and Problem Solving\; Analysis 0\; Algorithms and Data Structures\; Databases and Data Mining\; Statistical Models in Science\; Introduction to Numerical Analysis\; Numerical Solution of Differential Equations: Finite Difference Methods\; Project Course: Science and IT\; Philosophy of Computer Science\; Electrodynamics and Waves\; Quantum Mechanics 1\; Introduction to Mechanics and Relativity Theory\; Classical Mechanics\; Thermodynamics and Project\; Electromagnetism\; Analytical Mechanics and Chaos\; Analysis 1\; Mathematics for Physicists.])

]
== Online Learning
<online-learning>
- #box(image("/static/icons/datacamp.svg", height: 0.9em)) Completed 110 DataCamp courses, 9 tracks, and 37 projects across R, SQL, machine learning, and statistics (#link("https://www.datacamp.com/portfolio/cgmossa")[portfolio])
- #box(image("/static/icons/exercism.svg", height: 0.9em)) Completed the Exercism Rust track with 83 problems and iterative review-driven refinement (#link("https://exercism.org/profiles/CGMossa")[profile])

== Personal
<personal>
- Father of two
- Avid collector of custom mechanical keyboards

== Links
<links>

#align(center)[
#link("https://orcid.org/0009-0007-9297-1523")[#link-icon("/static/icons/orcid.svg", [ORCID: 0009-0007-9297-1523])] #h(0.5em)·#h(0.5em) #link("https://github.com/cgmossa")[#link-icon("/static/icons/github.svg", [GitHub])] #h(0.5em)·#h(0.5em) #link("https://www.linkedin.com/in/cgmossa")[#link-icon("/static/icons/linkedin.svg", [LinkedIn])] #h(0.5em)·#h(0.5em) #link("https://www.datacamp.com/portfolio/cgmossa")[#link-icon("/static/icons/datacamp.svg", [DataCamp portfolio])] #h(0.5em)·#h(0.5em) #link("https://exercism.org/profiles/CGMossa")[#link-icon("/static/icons/exercism.svg", [Exercism profile])]
]
