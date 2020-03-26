---
title: "Multi-Tenancy Microservice Architecture"
date: 2020-03-23T12:00:00-04:00
draft: false
toc: false
tags:
  - architecture
  - multi-tenancy
  - microservices
  - testing
  - devops
  - sre
---

## TL;DR

  - Microservices architecture encompasses a few services to thousands of services that communicate with each other through APIs.
  - Microservices should NOT introduce any breaking changes to their APIs.
  - Every change in one microservice should be tested against other microservices that rely on it.
  - There are two approaches for _integration testing_ in a microservices architecture:
    - **Replica Environments** (**Parallel Testing**)
      - Creating a copy of the production environment for handling test traffic (_integration_ or _staging_ environment).
      - This environment is completely isolated from the production environment, always up and running, and usually operating at a smaller scale.
      - Every new change will be first deployed and tested in this environment and only then it will be deployed to the production.
      - This approach is falling short in the following ways:
        - **Extra Cost**: there is going to be an extra operational cost.
        - **Data Synchronization**: Keeping data in sync between the production environment and the staging environment is a challenge.
        - **Dependency Synchronization**: Keeping the external dependencies identical is also a challenge.
        - **Unreliable Testing**: As the two environment deviates, the results of tests become less reliable.
        - **Inaccurate Performance Testing**: Running different types of performance testing such as _load testing_, _capacity testing_, etc. is another challenge in a separate environment.
    - **Multi-Tenant Environments** (**Testing in Production**)
      - Making the production system _multi-tenant_.
      - Multi-tenancy requires:
        - **Traffic Routing** based on the kind of traffic.
        - **Isolation** and **Fairness** for both _data-in-transit_ and _data-at-rest_.
      - Production traffic and test traffic can co-exist by making every service able to handle both kinds of traffics.
      - Test traffic goes to service-under-test (SUT) and production traffic stays unaffected by test traffic.
      - Multi-tenancy paves the path for the following capabilities as well:
        - **A/B Testing**
        - **Advanced Deployments**: _Blue-Green deployments_, _Rolling deployments, and _Canary deployments_, etc.
        - **Record/Replay and Shadow Traffic**: Replaying previously captured live traffic or replaying a shadow copy of live production traffic
  - **Tenancy-Oriented Architecture**
    - Tenancy should be treated as a _first-class object_ and the notion of tenancy should be attached to both _data-in-flight_ and _data-at-rest_.
    - Ideally, we want services to not deal with tenancy explicitly.
    - **Context**
      - A _tenancy context_ should be attached to every execution sequence.
    - **Context Propagation**
      - Tenancy context should always be passed from one service to another service.
      - Tenancy context should also be included in the messages in messaging queues.
      - Tenancy context should also be attached to _data-at-rest_.
      - Context propagation can be achieved using tools like _OpenTelemetry_ and _Jaeger_.
    - **Tenancy-Based Routing**
      - We should route requests based on their tenancy.
      - In general, tenancy-based routing can be achieved either at the _egress_ or at the _ingress_ of services.
      - **Service Mesh** tools such as _Envoy_, _Istio_, etc. can be leveraged for tenancy-based routing.
    - **Data Isolation**
      - The storage infrastructure needs to take tenancy into account and create isolation between tenants.
      - There are two high-level approaches:
        - Embed the notion of tenancy with the data and co-locate data with different tenancies.
        - Explicitly separate out data based on the tenancy at service-level or using an abstraction layer.
      - Configurations should also be multi-tenant.
  - **Database Tenancy Patterns**
    - **Standalone Single-Tenant App with Single-Tenant Database**
      - The whole stack will be spun up repeatedly for each tenant.
      - This model provides the strongest _tenant-isolation_ at infrastructure, application, and database levels.
    - **Multi-Tenant App with Database-per-Tenant**
      - The application is tenant-aware and there is going to be a single-tenant database per tenant.
      - In this model, we need a _catalog_ to map tenants to corresponding databases.
      - This model offers _tenant-isolation_ at the database level.
    - **Multi-Tenant App with a Single Multi-Tenant Database**
      - In this model, the database is also tenant-aware.
      - Depending on the underlying database implementation, data for different tenants could be either _co-located_, _isolated_, or _encrypted-per-tenant_.
    - **Multi-Tenant App with Sharded Multi-Tenant Databases**
      - This model is a combination of the previous two models.
      - Instead of having a single-tenant database per tenant, we will have a multi-tenant database per shard of tenants.
      - This model provides better _scalability_.

## Read More

  - [Why We Leverage Multi-Tenancy in Uber’s Microservice Architecture](https://eng.uber.com/multitenancy-microservice-architecture)
  - [Multi-tenant SaaS Database Tenancy Patterns](https://docs.microsoft.com/en-us/azure/sql-database/saas-tenancy-app-design-patterns)
