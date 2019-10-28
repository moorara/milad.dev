---
title: "An Overview of Observability"
date: 2019-09-08T21:00:00-04:00
draft: false
toc: true
tags:
  - observability
  - logging
  - metrics
  - tracing
  - events
---

**TL;DR**

  - Observability is the ability to understand what is going on in the inner workings of a system just by observing it from the outside.
  - Your software should explain itself and what is doing!
  - Pillars of observability are **logs**, **metrics**, **traces**, and **events**.
  - Logs are structured logging or non-structured textual data.
    - Used for auditing and debugging purposes.
    - Very expensive at scale.
    - Cannot be used for real-time computational purposes.
    - Hard to track across different and distributed processes.
    - You need know what to look for ahead of the time (know unknowns vs. unknown unknowns).
  - Metrics are time-series data (regular) with low cardinality.
    - Aggregated by time.
    - Used for real-time monitoring purposes.
    - Can take the distribution of data into account.
    - Enable service-level indicators (SLIs) and service-level objectives (SLOs).
    - CANNOT be broken down by high-cardinality dimensions (unique ids such user ids).
  - Traces are used for debugging and tracking requests across different processes and services.
    - Can be used for identifying performance bottlenecks.
    - Need to be sampled due to their very data-heavy nature.
    - Not optimized for aggregation.
    - Cannot precisely know about the distribution of data (detecting outliers).
  - Events are time-series (irregular) data.
    - Occur in temporal order, but the interval between occurrences are inconsistent and sporadic.
    - Used for reporting and alerting on important or critical events such as errors, crashes, etc.
  - Logs, metrics, and traces each prematurely optimize one thing and comprise another thing based on a premise upfront.
  - You do NOT want:
    - Writing duplicate data into three different places.
    - Copy-pasting IDs from tool to tool trying to track down a single problem!
    - Paying for three (four) different services doing almost the same thing!
  - You want:
    - One source of truth for your observability data.
    - Looking at high-level dashboards, spot anomalies, and zoom in to get detailed information as needed.
  - You are either throwing away data at ingestion time by **aggregating** or you are throwing away data after that by **sampling**.

[Presentation](/files/observability-20190908.pdf)
