+++
title = "Home"
description = "Mossa Merhi Reimert builds research software, modelling tools, and open-source R/Rust infrastructure."
+++

{% hero(
subtitle="Software Engineer · Researcher · Open-Source Maintainer"
) %}
R/Rust programmer and statistical modeller. Senior Scientific Software
Engineer at [**A2-Ai**](https://a2-ai.com). I build robust technical systems for
research, modelling, and open-source infrastructure.
{% end %}

## About

I am Mossa Merhi Reimert, PhD. I am a developer, teacher, and researcher, and
a core maintainer of
[extendr](https://github.com/extendr/extendr), which bridges R and Rust.
My research background is in epidemiological modelling, simulator-based
inference, and spatial disease spread.

I build tooling and infrastructure that need to be technically rigorous,
maintainable, and useful in practice. That includes open-source
maintainership, research software, and the work of turning prototype code into
systems other people can run, inspect, and extend.

## Current work

At [A2-Ai](https://a2-ai.com) I build scientific software in settings
where modelling, data, and product constraints meet. Outside of work, I spend
substantial time on R and Rust interoperability, package infrastructure, and
the broader craft of making technical projects easier to maintain.

Active in the [cph.rs](https://cph.rs) community, Copenhagen's monthly
Rust meetup. Father of two.

## Selected projects

{% project_card(title="extendr", url_key="extendr", tags="Rust, R, FFI") %}
Frictionless bindings between R and Rust. I am a core maintainer of the
project and work on the broader tooling around the R-Rust bridge.
{% end %}

{% project_card(
title="miniextendr",
url_key="miniextendr",
tags="Rust, R, CRAN"
) %}
A Rust-R interoperability framework for building R packages with Rust backends,
including ExternalPtr wrappers, ALTREP support, and CRAN-ready packaging.
{% end %}

{% project_card(
title="miniR",
url_key="minir",
tags="Rust, R, Interpreter"
) %}
An R interpreter written in Rust, aimed at real package code rather than
toy examples, with growing compatibility and native extension loading.
{% end %}

[More projects →](/projects/)
