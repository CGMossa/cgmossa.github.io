+++
title = "Projects"
description = "Selected open-source and research-oriented projects across R, Rust, interpreters, and modelling tools."
template = "section.html"
+++

A selection of projects I maintain or contribute to. Most of them live where
language tooling, scientific computing, and real-world constraints overlap.

{% project_card(title="extendr", url="https://github.com/extendr/extendr", tags="Rust, R, FFI") %}
Frictionless bindings between R and Rust. Write high-performance R extensions in safe Rust
with ergonomic macros and automatic type conversions.
I am a core maintainer of the extendr organisation.
Published in the [Journal of Open Source Software](https://doi.org/10.21105/joss.06394).
{% end %}

{% project_card(title="extendr (organisation)", url="https://github.com/extendr", tags="Rust, R, Open Source") %}
The broader extendr ecosystem, including `rextendr` (the R companion package),
documentation, CI infrastructure, and community resources for the R-Rust bridge.
{% end %}

{% project_card(title="miniextendr", url="https://github.com/cgmossa/miniextendr", tags="Rust, R, FFI, CRAN") %}
A Rust-R interoperability framework for building R packages with Rust backends.
Features ExternalPtr wrappers, ALTREP support, S3/S4/R6 class systems, worker-thread
execution, and CRAN-ready vendored packaging. Includes a
[documentation site](https://cgmossa.github.io/miniextendr/) with 70+ reference pages.
{% end %}

{% project_card(title="miniR", url="https://github.com/cgmossa/miniR", tags="Rust, R, Interpreter") %}
An R interpreter written in Rust. Reentrant design with per-interpreter state,
800+ builtin entry points, native C extension loading, and a growing CRAN compatibility
corpus. Targets real package code, not toy examples.
[Documentation site](https://cgmossa.github.io/miniR/).
{% end %}

{% project_card(title="Applied epidemiological modelling", url="https://orcid.org/0009-0007-9297-1523", tags="Modelling, Inference, Research Software") %}
Research software and publications around simulator-based inference, spatial
disease spread, and intervention modelling in livestock and wildlife contexts.
This work combines statistical reasoning, domain collaboration, and code that
needs to be inspectable and reproducible.
{% end %}
