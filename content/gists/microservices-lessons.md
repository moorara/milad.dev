---
title: "Lessons from the Birth of Microservices"
date: 2020-02-24T14:00:00-04:00
draft: false
toc: false
tags:
  - microservices
  - cloud-computing
  - serverless
  - observability
  - google
---

**TL;DR**

  - **Know Why**
    - With microservices, you will inevitably ship your _org chart_!
    - Think about why you are doing it at an organizational level.
    - Don't focus on _computer science_! Focus on _velocity_.
    - Optimize for velocity (not engineering velocity and not systems throughput).
    - By assigning project teams to microservices, you reduce person-to-person communication and increase velocity.
  - **Serverless Still Runs on Servers**
    - The idea of _single-purpose_ services is a failure mode to do it blindly.
    - There is a tendency to break things down into smaller and smaller pieces.
    - Don't forget about the significant cost of having two processes communicate with each other over a network.
    - Structure services around functional units in an engineering organization.
    - Think about compartmentalization and not breaking down services into the smallest possible pieces.
    - Don't keep on making things smaller and smaller. You will regret that!
  - **Independence**
    - If you let teams make their own decisions, you will not have a mechanism to _observe_ everything.
    - Think about which dimensions are independent, and which ones should be delegated to a platform team.
  - **Beware Giant Dashboards**
    - Each service generates a lot of pro-forma dashboards and then you put in the business metrics as well.
    - Figuring out the _root cause_ becomes hard when cascading failures are visible in all interdependent microservices.
    - The dashboards should be limited to _SLIs_ (what your consumer cares about) and the root cause analysis will be a guided refinement.
    - Observability is not about the three pillars. It's about detection and refinement.
    - Observability boils down to two activities:
      - Detection of critical signals
      - Refining the search space
  - **You Can't Trace Everything**
    - Distributed tracing is a way to do transactional logging with some kind of sampling built-in.

[READ MORE](https://www.infoq.com/presentations/google-microservices)
