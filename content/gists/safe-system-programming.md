---
title: "A Safer System Programming Language (Rust)"
date: 2019-08-08T18:00:00-04:00
draft: false
toc: false
tags:
 - rust
 - memory-safety
 - programming-language
---

## TL;DR

  - The majority (70%) of CVE and vulnerabilities fixed at Microsft are caused by memory corruption bugs in C/C++ code.
  - There are many tools for preventing, detecting, and fixing memory bugs.
  - Developers tend to miss these tools because they are not the first-class citizen of the programming language and their learning curve are high.
  - Developers should worry more about features and less about tooling and security.
  - A **memory-safe** programming language removes the burden from developers and puts it on language designers.
  - Memory safety is a property of programming languages where all memory accesses are well-defined.
  - Most programming languages are memory-safe by using some of form of _grabage collection_.
  - System programming languages cannot afford the runtime overhead of using _grabage collector_.
  - **Spatial memory safety** is about ensuring all memory accesses are within bounds of the type being accessed.
  - **Temporal memory safety** is about ensuring pointers still point to valid memory when dereferencing.
  - A **data race** happens when two or more threads in a process, that one of them at least is a _writer_, concurrently access the same memory location without any mechanism for exclusive access.
  - Rust is a _memory-safe programming language_ for system programming and high-performance use-cases.
  - Rust provides _strong memory safety_ and it is _completely memory safe_ (except the `unsafe` keyword).
  - Rust is comparable with C/C++ in terms of performance, speed, control, and predictability.
  - Rust runtime (standard library) depends on `libc`, but it is optional. (it can be run without an operating system).
  - Rust provides performance, control on memory allocation, and strong memory-safety and empowers developers to write robust and secure programs.
  - Some of the issues with Rust are lack interoperability with C/C++ and limiting the usage of the `unsafe` superset at scale.

## Read More

  - [Rust](https://msrc-blog.microsoft.com/tag/rust)
  - [A proactive approach to more secure code](https://msrc-blog.microsoft.com/2019/07/16/a-proactive-approach-to-more-secure-code)
  - [We need a safer systems programming language](https://msrc-blog.microsoft.com/2019/07/18/we-need-a-safer-systems-programming-language)
  - [Why Rust for safe systems programming](https://msrc-blog.microsoft.com/2019/07/22/why-rust-for-safe-systems-programming)
