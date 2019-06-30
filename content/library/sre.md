---
title: "Site Reliability Engineering"
date: 2019-06-30T00:58:00-04:00
draft: true
toc: false
tags:
  - book
  - sre
  - devops
---

<br/>![Book Cover](/images/book-sre.jpg "Site Reliability Engineering")<br/>

## Recap

Site reliability engineering is Google's approach to service management.
If you think of DevOps more of as a culture, as a mindset, or as a set of guidelines, SRE is a framework that implements DevOps.
This book is more like a collection of essays with a single common vision.

SRE teams consist of people with software engineering skills and operation knowledge.
Google places a 50% cap on all operation (ops) work aggregated for all SREs,
and the remaining 50% should be spent on development work for the purpose of automation.
Ideally, SRE teams should spend all of their time and capacity on development as opposed to operations.
This is possible if services are autonomous and run and repair themselves.
Monitoring the amount of operational work done by SREs is necessary.
Once the 50% cap is reached, extra operational work should be redirected and delegated to development teams.

The following is a summary of some of the key chapters in this book.

### Risk and Error Budget

Site reliability engineering tries to balance the risk of service unavailability with development velocity.
SRE manages service reliability mostly by managing the risk. One metric to measure the risk tolerance of service is availability.
100% reliability or availability is never right! It is impossible to achieve and most likely is not what a user needs.
As reliability increases, the cost does not increase linearly. From 3 nines availability to 5 nines, the cost may increase by the factor of 100!
In the context of SRE, availability is not just uptime. It is measured as request success rate, latency, and so on.
Google sets quarterly availability targets for services and tracks them against those target on a monthly, weekly, and sometimes daily basis.
When setting availability targets, the background error rate (availability of the underlying network, infrastructure, etc.) should be taken into account.

One very interesting and useful concept defined by SRE framework is the concept of **error budget**.
Once the product team defines an availability target, the error budget is one minus the availability target.
Error budget provides a common incentive and a quantitative measure for both development and SRE teams to find the right balance between innovation and reliability.

### SLI, SLO, and SLA

A **service-level indicator** (SLI) is a quantitative measure for some aspects of the level of service provided.
It can be defined as _request latency_, _request throughput_, _error rate_, etc.

A **service-level objective** (SLO) is a specific target value or range of values for a service level measured by an SLI.
SLO sets the expectations for the user of a service. Choosing an appropriate SLO is not a straightforward task.
Do NOT pick an SLO based on the current performance of the system. Keep your SLOs few and simple and do NOT strive for perfection!

A **service-level agreement** (SLA) is an implicit or explicit contract that tells users what are the consequences of not meeting the SLOs.

SLIs for services usually can be chosen from one of the following categories:

  - All systems should care about _correctness_.
  - User-facing systems generally care about _availability_, _latency_, and _throughput_.
  - Storage systems often deal with _latency_, _availability_, and _durability_.
  - Data processing services usually care about _throughput_ and _end-to-end latency_.

Average metrics may seem simple and good enough, but they hide the details and they do not reveal anything about special cases.
For example, when a burst of requests come or when the system is overloaded.
Research has shown that users prefer a slightly slower system to a system with high variance.
Thus, the distribution of data is important. Using percentiles for SLIs take the shape of the distribution into account as well.

SLOs represent users expectations, so they should be used as a driver for prioritizing work for SREs and product developers.
As far as SLOs are met, new risk can be taken and development velocity can increase.
If any of the SLOs is violated, all effort should be spent on meeting the SLOs again.
Define your SLIs, sets your SLOs against these SLIs, monitor your SLIs and SLOs, and alert on violation of SLOs.
When defining SLOs, keep a _safety margine_ and do NOT _overachieve_!

### Monitoring & Alerting

Monitoring is the process of collecting, aggregating, processing, and presenting real-time quantitative data about a system.
A monitoring system should determine _"what is broken"_ and _"why is broken"_.
The symptoms can be used for answering _"what is broken"_ and the _cause_ can be used for answering _"why is broken"_.

Choose an appropriate _resolution_ for measurements. Your SLOs can help with choosing the right resolution.
Google prefers simple monitoring systems and avoids magic systems that try to learn threshold and automatically detect causality.

For golden signals that Google defines for paging humans are the following:

   - Latency: how long it takes for requests to be fulfilled.
   - Error: the rate of requests that fail.
   - Traffic: how much demand is currently being placed on your system.
   - Saturation: the utilization of available resources to your system.

Every page that happens distracts a human from improving the system and building more automation!
Pages should have enough context, should be _actionable_, and should require human intelligence (not a robotic response).
When a system is not able to automatically fix itself, we can notify a human to investigate the issue.
Your alerting and paging system should keep the _noise low_ and _signal high_.
Rules that generate alerts for people should be simple to understand and represent a clear failure.

### Playbooks

Reliability is a function of _mean time to failure_ (MTTF) and _mean time to restore_ (MTTR).
Recording the procedures and best practices ahead of time in playbooks improve MTTR metrics by 3x.
Google's SREs rely on playbooks as well as other practices such as _Wheel of Misfortune_, _DiRT_, etc.

### Postmorterm Culture

### Handling Overload

### Cascading Failures

### Data Integrity

### Product Launch
