---
title: "Charity Majors on Observability and Quality of Microservices"
date: 2019-08-12T21:00:00-04:00
draft: false
toc: false
tags:
  - observability
  - microservices
---

**TL;DR**

 - Observability refers to three different things: **logs**, **metrics**, and **traces**.
 - The problem with logs is that you have to know what to search for before you know what the problem is!
 - The problem with metrics is they are aggregated by time and you cannot break them down by high-cardinality dimensions (like user id for example).
 - Logs, metrics, traces, and events they each prematurely optimize one thing and comprise another thing based on a premise upfront.
 - You don't want to write your observability data to many different places and copy-paste IDs from tool to tool trying to track down a single problem!
 - You want one source of truth and you want to be able to go from very high-level dashboards to very low-level data.
 - According to control theory definition, observability is the ability to understand what is going on in the inner workings of a system just by observing it from the outside.
 - Libraries that you build into your code should give you insights from the inside out (the software should explain itself).
 - Observability total cost should be 10 to 30 percent of the infrastructure cost.
 - You are either throwing away data at ingestion time by _aggregating_ or you are throwing away data after that by _sampling_.
 - Observability can be incredibly cost-effective by using intelligent sampling.
 - Software engineers should write _operable_ services and run them themselves!
 - Software engineers need to be on-call for their own systems. This is a way to support software engineers to build an observable and scalable system.
 - Every single alert you get should be actionable. Every time you get paged you should be like this is new, I don't understand this (and not oh that again)!
 - Ops should stop being gatekeepers and blocking people. They have to stop a building castle and they have to start building a playground!
 - Every developer should be looking at prod every day. They should know what is normal, how to debug it, and how to get to a known state!
 - If management is not carving out enough project development time to get things fixed, no on-call situation will ever work!
 - SLOs (service-level objectives) define the quality of service that we agree to provide for users.
 - As long as you hit the SLO line, anything you do in engineering if fine! Everyone gets what they need, nobody feels micromanaged, and nobody feels completely abandoned!
 - SLOs help with defining how much time is enough for improving things!

[WATCH HERE](https://www.youtube.com/watch?v=8u8A-bhhlSg)
