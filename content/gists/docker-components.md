---
title: "Docker Components Explained"
date: 2019-08-09T22:00:00-04:00
draft: false
toc: false
tags:
 - container
 - docker
 - containerd
 - runc
---

**TL;DR**

 - The Open Container Initiative (OCI) is launched in June 2015 by Docker, CoreOS, and other leaders in the container industry.
 - The OCI currently contains two specifications: [runtime-spec](https://github.com/opencontainers/runtime-spec) and [image-spec](https://github.com/opencontainers/image-spec)
 - **RunC**
   - [RunC](https://github.com/opencontainers/runc) is the runtime for running containers according to the OCI specification (implements OCI runtime-spec).
   - Runc leverages technologies available in Linux Kernel (_cgroups_ and _namespaces_) to create and run containers.
 - **containerd**
   - [containerd](https://github.com/containerd/containerd) is a _daemon_ and it manages the complete lifecycle of a container on the host operating system.
   - containerd manages image storage and transfer, container execution and supervision, low-level storage, network attachment, etc.
   - containerd uses RunC for creating and running containers from OCI-compatible images.
 - **dockerd**
   - dockerd (docker-engine) provides an API for clients via three different types of sockets: unix, tcp, and file.
   - dockerd serves all features of Docker platform.
   - dockerd leverages containerd gRPC API for managing containers.
 - **containerd-shim**
   - containerd-shim allows daemonless containers and acts as a middleman between containers and containerd.
   - Using containerd-shim, runc can exit after creating and starting containers (removes the need for long-running runtime processes for containers).
   - containerd-shim also keeps the STDIO and FDs open for containers in case dockerd or containerd dies.
   - This also allows updating dockerd or containerd without killing the running containers.
 - Docker CLI (docker command) and other Docker clients communicate with dockerd (docker-engine).

**READ MORE**

 - [OCI](https://www.opencontainers.org)
 - [containerd](https://containerd.io)
 - [Docker components explained](http://alexander.holbreich.org/docker-components-explained)
 - [rkt vs other projects](https://github.com/rkt/rkt/blob/v1.29.0/Documentation/rkt-vs-other-projects.md)
 - [How containerd compares to runC](https://stackoverflow.com/questions/41645665/how-containerd-compares-to-runc)
