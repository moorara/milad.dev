---
title: "gVisor: Building and Battle Testing a Userspace OS in Go"
date: 2019-05-19T15:14:56-04:00
draft: true
toc: false
tags:
  - os
  - linux
  - oci
  - container
  - golang
  - security
---

**TL;DR**

  - A container is a package format and a content addressable bundle of content addressable layers!
  - **namespaces** and **cgroups** are two key features of Linux kernel enabling containerization.
  - Containers running on a host share a single Linux kernel! (a singler scheduler, a single memory manager, and so on)
  - The Linux kernel has so many known and unknown bugs!
  - Sandboxes are a way of getting an extra layer of isolation for containers.
  - [gVisor](https://gvisor.dev) is an [OCI](https://www.opencontainers.org) container runtime implementing Linux kernel API in userspace using Go.
  - gVisor is a sandbox for containers and does not let them talk directly to the kernel.
  - As a result, gVisor comes with a bit of performance cost.

[READ MORE](https://www.infoq.com/presentations/gvisor-os-go)
