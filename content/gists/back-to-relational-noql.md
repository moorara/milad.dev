---
title: "Back to the Future with Relational NoSQL"
date: 2019-07-14T10:12:00-04:00
draft: true
toc: false
tags:
  - dbms
  - rdbms
  - sql
  - nosql
---

**TL;DR**

  - NoSQL was a response to scalability limitation and very high cost of traditional RDBMS.
  - CAP theorem says in case of **network partitions**, among **consistency** (correctness) and **availability**, one has to be comprised in favor of the other.
  - The first generation of NoSQL DBMS chose availability and they were _eventuallyc consistent_.
  - Most NoSQL systems uses *last-write-wins* based on the local system time.
  - As a result, although most NoSQL systems are *eventually consistent*, but they do NOT guarantee *correctness*.

[READ MORE](https://www.infoq.com/articles/relational-nosql-fauna)
