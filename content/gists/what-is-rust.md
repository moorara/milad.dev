---
title: "What is Rust and Why is it So Popular?"
date: 2020-03-01T20:00:00-04:00
draft: false
toc: false
tags:
  - rust
  - programming
  - language
---

## TL;DR

  - The Rust compiler is built on top of [LLVM](https://llvm.org).
  - Rust is a **statically-typed** language.
    - Rust has **optional types** for handling _null_ and the compiler requires the `None` case to be handled.
    - Rust requires top-level items like function arguments and constants to have explicit types while allowing type inference inside of function bodies.
  - Rust's strong type system and memory safety are all enforced at compile time!
    - Rust does not need to have a garbage collector!
    - Rust gives you the choice of storing data on the stack or on the heap.
    - Rust determines at compile time when memory is no longer needed and can be cleaned up.
  - Rust projects can be used as libraries by other programming languages via _foreign-function interfaces_.
    - This allows existing projects to incrementally replace performance-critical pieces with Rust code without the memory safety risks.
  - Rust is an ideal language for embedded and bare-metal development.
  - _Borrow checker_ is the part of the compiler ensuring that references do not outlive the data they refer to.
  - When safe Rust is not able to express some concept, you can use unsafe Rust.
    - This enables more power, but the programmer is responsible for ensuring that the code is truly safe.
    - The unsafe code can be wrapped in higher-level abstractions which guarantee that all uses of the abstraction are safe.
  - Many aspects of creating and maintaining production-quality software such as testing, dependency management, documentation, etc. are first-class citizens in Rust.
  - Prototyping solutions in Rust can be challenging since Rust requires covering 100% of the conditions!

## READ MORE

  - [What is Rust and why is it so popular?](https://stackoverflow.blog/2020/01/20/what-is-rust-and-why-is-it-so-popular)
  - [Why Discord is switching from Go to Rust](https://blog.discordapp.com/why-discord-is-switching-from-go-to-rust-a190bbca2b1f)
