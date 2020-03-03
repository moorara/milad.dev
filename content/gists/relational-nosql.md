---
title: "Back to the Future with Relational NoSQL"
date: 2020-02-29T22:00:00-04:00
draft: false
toc: false
tags:
  - sql
  - nosql
  - database
  - dbms
  - rdbms
---

**TL;DR**

  - Distributed transactions are one of the hardest problems in computer science.
  - NoSQL was a response to scalability limitation and a very high cost of traditional RDBMS.
  - **CAP** theorem says in case of **network partitions**, among **consistency** (correctness) and **availability**, one has to be comprised in favor of the other.
  - The first generation of NoSQL DBMS chose _availability_ and they were _eventually consistent_.
    - In theory, they will reconcile conflicts in a finite time after a network partitioning by probabilistically voting on what the data is supposed to be.
    - Most real-world eventually consistent systems use a simplistic _last-write-wins_ based on the local system time.
  - Although NoSQL systems are _available_ and _eventually consistent_, they do NOT guarantee _correctness_.
  - Therefore, databases need _external consistency_ or _ACID_.
  - Legacy databases have a single centralized machine and serialize writes to a single disk in a deterministic order. Scalability is only vertical.
  - In primary/follower replicated databases, followers asynchronously replicate the state of the primary.
  - Google's Spanner:
    - Multi-shard transactions are done by a two-phase prepare/commit algorithm.
    - Shard failover is automated via Paxos.
    - Physical atomic clock hardware synchronizes the system time on all shards within very small error bounds.
    - Google has the resources to build and maintain atomic clock hardware and bounded-latency networks.
  - Calvin is a logical clock oracle that does not rely on any single physical machine and can be widely distributed.
    - The order of transactions is determined by preprocessing an externally consistent order to all incoming transactions.
  - FaunaDB is a Relation NoSQL system implementing Calvin model.
  - In practice, the availability of systems like Spanner and FaunaDB in the cloud is the same as the availability of AP systems.
  - Bounded consistency is better than eventual consistency.

[READ MORE](https://www.infoq.com/articles/relational-nosql-fauna)
