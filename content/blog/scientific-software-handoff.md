+++
title = "Scientific Software Has to Survive Handoff"
date = 2026-04-10
description = "What I care about when turning research code into tools that another person can run, inspect, and trust."
[taxonomies]
tags = ["scientific-software", "rust", "r"]
+++

A lot of research code only has to work once: for the person who wrote it,
on the data they already know, under the deadline already staring at them.
That is fine for exploration. It is not enough for software that needs to
outlive the moment.

For me, the real test is handoff.

Can someone else run the code without reverse-engineering my directory
structure? Can they see what the inputs are, what the outputs are, and where
the assumptions live? Can they change one part without quietly breaking
another? If not, then I may have a useful analysis, but I do not yet have
useful software.

## Make data movement obvious

One of the fastest ways to make technical work fragile is to let data shape
the program implicitly.

If a function expects a very particular layout, unit convention, or column
naming scheme, I want that expectation to show up in the interface. If a file
format is central to the workflow, I want the conversion points to be visible.
If a model has assumptions that matter to interpretation, I want them close to
the code that uses them.

This does not have to mean heavyweight architecture. Often it just means
choosing names carefully, making transformation steps explicit, and refusing to
hide domain decisions inside convenience wrappers.

## Keep the interface boring

There is a kind of technical ambition that shows up as cleverness at the
boundary: too many options, too much magic, too much behavior inferred from too
little information.

I do not think that ages well.

The interface should be the boring part. It should be obvious how to call the
thing, what comes back, and what can go wrong. The interesting work should
happen behind that surface: the model, the algorithm, the implementation
details, the performance decisions.

This is one reason I like working with R and Rust together. R is a good place
to meet users where they already are: exploratory, interactive, close to the
analysis. Rust is a good place to make invariants explicit, control data
movement, and build the pieces that need to stay reliable under pressure.

## Show your confidence

By "confidence" I do not mean certainty. I mean giving the next person a way to
see why they should trust the result to the degree that they do.

Tests are part of that. So are examples, documentation, CI, reproducible
inputs, and small scripts that demonstrate the intended path through the code.
When those things are missing, the code may still be correct, but it asks too
much faith from the next maintainer.

That matters even more in scientific contexts, where there is often a strong
temptation to treat the result as the main artifact and the software as a
temporary means to an end. In practice, the software often becomes the thing
people inherit.

## Make the next step cheaper

The goal is not ceremony. The goal is to make the next step cheaper.

Maybe that next step is a collaborator reproducing the run. Maybe it is a new
dataset. Maybe it is a review comment, a package release, or a bug report six
months later. Good scientific software does not eliminate uncertainty, but it
does make change less expensive.

That is the standard I keep coming back to: not just "does it run?" but "does
it survive handoff?"
