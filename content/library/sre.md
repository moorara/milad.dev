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

### Automation

Automation is superior to manual operation in software, but more importantly, we need to build _autonomous_ systems.
Automated systems serve as platforms that can be extended for applying to more system and use-cases.
In many cases, they can be productized for the benefits of the business and profit as well.

Needless to say, automation brings many values: _consistency_, _reliability_, _scaling_, _quickness_, _time_, _cost_, and so forth.
It is not pragmatic to automated every aspect of a system for different reasons.
Automated systems should not be maintained separately from core systems; otherwise, they start to diverge and fail.

_Autonomous_ systems do not require human intervention and automation of operations.

**Automate yourself out of a job!** Automating all the things and everything that can be automated.
Such improvements have a cascading effect. The more time you spend on automating, the more time you would have for more automation and optimization.

### Simplicity

_Simplicity is a prerequisite to reliability.
Constantly strive for eliminating complexity in the systems.

_Essential complexity_ and _accidental complexity_ are very different!
Essential complexity is an inherent property of the problem and cannot be removed
while accidental complexity is associated with the solution and can be removed.

_Software bloat_ refers to the situation in which a piece of software getting bigger, slower and
harder to maintain over time as a result of adding more features, codes, and case-specific logics.

Do not build something that will be not used. Do not comment code or flag it for possible use in the future!
In software, **less is more**! Creating clear and minimal APIs are an integral aspect of having a simple system.
_Modularity_, _versioning_, _well-scoped functionalities_, _releasing smaller batches_, etc. are all examples of requirements for simplicity.

### Monitoring and Alerting

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
Pages should have enough context, should be _actionable_, and should require human intelligence.
If a page can be resolved by a robotic response, it the response should be autoamted and there should not be a page for it.
When a system is not able to automatically fix itself, we can notify a human to investigate the issue.

Your alerting and paging system should keep the _noise low_ and _signal high_.
Rules that generate alerts for people should be simple to understand and represent a clear failure.
The rules should allow a minimum period in which the alerting rule is true before firing an alert (to prevent the _flapping_ situation).

It is also very important to monitor a system from the user point of view to
make sure we monitor the actual user experience and what the user sees (black-box monitoring).
Making sure that the cost of maintenance scale _sublinearly_ with the size of service and number of services,
is the key to make monitoring and alerting maintainable. 

### Postmorterm Culture

The primary goals of writing a postmortem are to ensure:

  - The incident is documented
  - All root cause(s) are well understood
  - Preventive actions are put in place

Every incident is an opportunity to improve and harden the system. Postmortems must be **blameless**.
They should focus on the contributing root cause(s) of the incident without mentioning any individual or team.
A blameless postmortem culture gives people the confidence to escalate an incident without fear.

### Testing For Reliability

Traditional tests:

  - Unit tests
  - Integration tests
  - System tests:
    - Smoke tests
    - Performance tests
    - Regression tests

Production tests:

  - Configuration test
  - Stress test
  - Canary test

### Overloads and Cascading Failures

Clients and backend applications should be built to handle resource restrictions _gracefully_.
In case of overload, they redirect when possible, serve degraded results, and handle errors transparently.

In case of a _global overload_, the service should only return errors to misbehaving clients and keep others unaffected.
Service owners should provision capacity for their services based on usage quotas per client
assuming that not all of the clients are going to hit their limits simultaneously.
When a client hits its quota, the backend service should quickly reject the requests.
When the client detects that a large number of requests are rejected due to insufficient quota,
it should start to self-regulate and cap the number of outgoing requests it makes.
Adaptive throttling works well with clients that make frequent (as opposed to sporadic) requests.

When the utilization approaches the configured threshold, the requests should be rejected based on their _criticality_.
Requests with higher criticalities should have higher thresholds.
Usually, a small number of services are overloaded. In this case, failed requests can be retried with a retry budget.
If a large number of services are overloaded, failed requests should not be retried and errors should bubble up all the way to the caller.

Blindly retrying requests can have a cascading effect and lead to even more overload and failures.
Requests should be retried at the layer immediately above the layer that rejected the requests
(return an error code implying the downstream service is overloaded and do not retry).
Limit retries per request and always use randomized _exponential backoff_ when scheduling retries.

The most common cause of cascading failures is _overload_.
_Processor_, _memory_, _threads_, and _file descriptors_ are examples of resources that can be exhausted.
When a couple of services become unavailable due to overload, the load on other services increases and cause them to become unavailable too.

To prevent service overload, the following measures can be taken:

  - Perform capacity planning
  - _Load test_ the capacity limits of services, and test the _failure mode_ for overload
  - Serve degraded responses
  - Reject requests when the service is overloaded
  - Upstream systems should reject the requests, rather than overloading the downstream ones:
    - At the _reverse proxies_
    - At the _load balancers_

**Load shedding** refers to dropping some amount of load (incoming requests/traffic) when a service approaches overload conditions.
**Graceful degradation** refers to reducing the amount of work required for fulfilling a request when a service is overloaded.
Make sure you monitor and alert when services entering any of these modes.

Long deadlines can result in resource consumption in upstream systems while downstream systems having problems.
Short deadlines also can cause expensive requests to fail consistently (including retries).
Sometimes services spend resources on handling requests that will miss their deadlines (retries will cause more resource waste in turn).
Services should implement **deadline propagation**. For the requests that get fulfilled in multiple stages,
at every stage, every service should check how much time is left before trying to work on the request.
Also, consider setting an upper bound for outgoing deadlines.
Services should also implement **cancellation propagation** to prevent unnecessary work being done by downstream services.

You should test your services to understand how they behave when approaching overload and when overloaded.
Under overload situation, the service starts serving errors and/or degraded results,
but the rate at which requests are served successfully should not reduce significantly.
You should also test and understand how your services return back to normal load situation.
Furthermore, you should test and understand how clients use your services.

Some of the factors that can trigger a cascading failure:

  - Process death
  - Process updates
  - New rollouts
  - Organic growth
  - Changes in request profile
  - Changes in resource limits

Here are some immediate measures you can take in response to a cascading failure:

  - Increase resources (scale up vertically)
  - Temporarily disable health checks until all the services are stable
  - Restart services
  - Drop traffic
  - Enter degraded modes 
  - Eliminate batch load (non-critical offline jobs)
  - Eliminate bad traffic (requests creating heavy load or causing crashes)

### Data Integrity

### Product Launch
