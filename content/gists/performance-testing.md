---
title: "Performance Testing Explained"
date: 2020-03-22T04:00:00-04:00
draft: false
toc: false
tags:
  - testing
  - performance
---

## TL;DR

The well-known types of performance testing are the following:

  - **Load Testing**
    - Load testing is the simplest form of performance testing.
    - It is conducted to understand the behavior of a system under a specific load.
    - The goal of load testing is to identify performance bottlenecks in the application.
  - **Stress Testing**
    - Stress testing is carried out to understand the behavior of a system in an overload situation.
    - The goal of stress testing is to see if the system will perform satisfactorily when the load goes well above the maximum.
    - Sometimes, stress testing is done to identify the breaking point of the application.
  - **Endurance Testing**
    - Endurance testing (a.k.a. _soak testing_) involves putting a system under a significant load for an extended period of time.
    - The goal of endurance testing is to ensure that the application maintains its expected performance over a long period of time.
  - **Spike Testing**
    - Spike testing is done by suddenly increasing the load and observing the behavior of a system.
    - The goal of spike testing is to see if the performance of the application will suffer from sudden and dramatic changes in load.

There are also other types of testing sometimes referred to as performance testing.

  - **Capacity Testing**
    - Both _load testing_ and _stress testing_ help with determining and testing the capacity of a system.
    - Capacity testing is concerned with testing the capacity of a system to see how many requests it can handle before the performance goals are hurt.
  - **Scalability Testing**
    - Scalability testing is closely related to _stress testing_ and _spike testing_.
    - Scalability testing deals with testing a system capability to _scale up_ or _scale down_.
  - **Configuration Testing**
    - Configuration testing verifies the performance of a system against different configuration changes to the system.

## Read More

  - [Software Performance Testing](https://en.wikipedia.org/wiki/Software_performance_testing)
  - [Performance Testing Tutorial: What is, Types, Metrics & Example](https://www.guru99.com/performance-testing.html)
