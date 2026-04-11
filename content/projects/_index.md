+++
title = "Projects"
template = "section.html"
+++

A selection of open-source projects I maintain or contribute to.

<div class="project-card">
<h3><a href="https://github.com/extendr/extendr" target="_blank" rel="noopener">extendr</a></h3>
<p>
Frictionless bindings between R and Rust. Write high-performance R extensions in safe Rust
with ergonomic macros and automatic type conversions.
I am a core maintainer of the extendr organisation.
Published in the <a href="https://doi.org/10.21105/joss.06394">Journal of Open Source Software</a>.
</p>
<div class="project-tags"><span>Rust</span><span>R</span><span>FFI</span></div>
</div>

<div class="project-card">
<h3><a href="https://github.com/extendr" target="_blank" rel="noopener">extendr (organisation)</a></h3>
<p>
The broader extendr ecosystem &mdash; including <code>rextendr</code> (the R companion package),
documentation, CI infrastructure, and community resources for the R&ndash;Rust bridge.
</p>
<div class="project-tags"><span>Rust</span><span>R</span><span>Open Source</span></div>
</div>

<div class="project-card">
<h3><a href="https://github.com/cgmossa/miniextendr" target="_blank" rel="noopener">miniextendr</a></h3>
<p>
A Rust&ndash;R interoperability framework for building R packages with Rust backends.
Features ExternalPtr wrappers, ALTREP support, S3/S4/R6 class systems, worker-thread
execution, and CRAN-ready vendored packaging. Includes a
<a href="https://cgmossa.github.io/miniextendr/">documentation site</a> with 70+ reference pages.
</p>
<div class="project-tags"><span>Rust</span><span>R</span><span>FFI</span><span>CRAN</span></div>
</div>

<div class="project-card">
<h3><a href="https://github.com/cgmossa/miniR" target="_blank" rel="noopener">miniR</a></h3>
<p>
An R interpreter written in Rust. Reentrant design with per-interpreter state,
800+ builtin entry points, native C extension loading, and a growing CRAN compatibility
corpus. Targets real package code, not toy examples.
<a href="https://cgmossa.github.io/miniR/">Documentation site</a>.
</p>
<div class="project-tags"><span>Rust</span><span>R</span><span>Interpreter</span></div>
</div>
