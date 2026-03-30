---
title: "Docker vs. Podman"
date: 2026-03-30T13:50:00-04:00
draft: false
toc: true
tags:
  - docker
  - podman
  - kubernetes
  - container
---

When [Docker](https://www.docker.com) came onto the scene, it did not invent containers from scratch.
The real magic was already implemented inside the Linux kernel in the form of two core technologies: **cgroups** and **namespaces**.
[cgroups](https://man7.org/linux/man-pages/man7/cgroups.7.html) allow managing and profiling system resources on a per-process basis (CPU, memory, and I/O).
[namespaces](https://man7.org/linux/man-pages/man7/namespaces.7.html), on the other hand, customize the system view of a process,
giving each one a virtual and exclusive view of the file system, network, memory space, process space, and more.
Linux had these core technologies for years, but they were hard to use.
Docker invented the idea of container images layered as immutable files, where each layer only contains the changes made to the one before.
Docker abstracted all of this complexity in tooling that was dead-easy to use, and that changed everything.

## Docker's Open-Source Contribution

Beyond the tooling, Docker made a massive contribution to the broader ecosystem
by open-sourcing and standardizing the most important components of their technology.
Things like the [OCI](https://opencontainers.org) specification, [containerd](https://containerd.io),
and [runc](https://github.com/opencontainers/runc) are all either created or heavily contributed to by Docker.
These became the shared foundation that the entire container ecosystem now builds on.
[Moby](https://mobyproject.org) is the set of open-source components that implement Docker itself,
the upstream project from which the Docker product is assembled.

## The Daemon Architecture

Docker uses a daemon-based architecture for running and managing containers.
There is a background service (dockerd), the Docker Engine, that stays running at all times, even when no container is active.
Clients talk to this daemon through an API exposed over three types of sockets: *Unix*, *TCP*, and *file*.

    Docker CLI → dockerd → containerd → runc → Linux kernel

This architecture has some real advantages:
The daemon keeps state, so clients do not need to rediscover the entire state of the system (networks, volumes, other running containers) every time they run.
The abstraction also means clients can be command-line tools, desktop apps, or remote clients.
and some components can even be swapped out hot while containers are still running.

The tradeoffs are significant:
The daemon must run as root, which means a compromised daemon gives a bad actor access to the entire system.
It consumes resources in the background constantly, regardless of whether anything is running.
If the daemon crashes, all containers need to be restarted.
The daemon has a large attack surface by design.

## Where Kubernetes Parted Ways

[Kubernetes](https://kubernetes.io) exposed these limitations at scale.
Kubernetes simply needed to spin up containers and manage their lifecycle directly, not needing everything else Docker brought along.
The daemon-based architecture made this awkward. When the daemon was unresponsive, Kubernetes lost visibility into what was happening with containers.
The daemon was a heavyweight intermediary standing between Kubernetes and the containers, and bridging that gap required a shim just to interface with Docker.
Kubernetes eventually deprecated Docker as a container runtime
in favor of directly using containerd through the [Container Runtime Interface (CRI)](https://kubernetes.io/docs/concepts/containers/cri).
Containerd is itself a daemon, but a much more focused one. It manages the complete lifecycle of a container on the host OS.

## Podman

[Podman](https://podman.io) takes a fundamentally different approach.
It is a lightweight, **daemonless** alternative designed primarily for running containers on local machines for development purposes.
Podman runs as a single binary that prepares and starts a container and then exits. Each container runs as a child process of the Podman invocation.
By default, Podman runs in **rootless** mode. This makes the security profile significantly better than Docker.
Podman also natively supports the concept of Pods: groups of containers that share namespaces with each other, much like Kubernetes Pods.

Under the hood, Podman uses a different set of tools compared to Docker:

  - [Buildah](https://github.com/containers/buildah) for building OCI-compliant images
  - [Skopeo](https://github.com/containers/skopeo) for working with remote images and registries
  - [crun](https://github.com/containers/crun) for preparing and running containers on the host Linux

## The Desktop Catch 

Both Docker and Podman have an important limitation when running on non-Linux machines.
Since containers are fundamentally a Linux kernel feature, both need to spin up a Linux VM to actually run them.
On a Mac or Windows machine, all containers are really running inside this virtual machine, not on the host OS directly.
This creates a subtle issue: many observability tools work by mounting specific directories from the host file system and then accessing them inside the container.
But those directories live inside the VM, and they do not exist on the host machine at all.

## Reading More

  - [What is Docker?](https://docs.docker.com/get-started/docker-overview/)
  - [What is Podman?](https://docs.podman.io/en/latest/)
  - [Don't Panic: Kubernetes and Docker](https://kubernetes.io/blog/2020/12/02/dont-panic-kubernetes-and-docker)
