---
title: "Architecture Without an End State"
date: 2019-10-02T22:00:00-04:00
draft: false
toc: false
tags:
  - development
  - architecture
---

**TL;DR**

  - In every organization of any size, the **steady state** is always a superposition of many different wavefronts of changes.
    - Some of those changes are technological and some of them are market-driven
    - The changes are originating at different places and sweeping through the organization at different speeds.
  - Stop chasing the end state!
  - Let's focus on _continuous adaptation_ instead of the grand vision.


  1. **Embrace Plurality**
      - Avoid _single system of record (SSoR)_.
      - Federate extents from multiple different systems (_multiple systems of record_).
  1. **Contextualize Downstream**
      - Business rules are contextual.
      - The more we push rules upstream, the larger the surface area of every change becomes.
      - Augment the information upstream, but contextualize it and apply rules and policies downstream.
      - Apply policies in systems closest to the users.
      - Minimize the entities that all systems need to know about it.
  1. **Beware Grandiosity**
      - Seek compromises.
      - Assume an open world.
      - Begin small and incrementalize.
      - Allow lengthy comment periods.
  1. **Decentralize**
      - Transparency: methods, work, and results must be visible.
      - Isolation: one group's failure cannot cause widespread damage.
      - Economics: distributed economic decision-making.
  1. **Isolate Failure Domains**
      - Six different ways of introducing _modularity_: splitting, substitution, augmenting, excluding, inversion, porting
  1. **Data Outlives Applications**
      - Data outlives many different technologies and applications.
  1. **Applications Outlive Integrations**
      - _Hexagonal architecture_ or _Ports and Adapters_
  1. **Increase Discoverability**
      - Improve by building on the work of others.
      - Visible work: open code repositories, internal blogs, etc.

[Presentation](https://www.infoq.com/presentations/architecture-without-an-end-state)
