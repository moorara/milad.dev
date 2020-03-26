---
title: "Service Meshes and SMI Demystified"
date: 2019-06-10T14:00:00-04:00
draft: false
toc: false
tags:
  - microservices
  - container
  - kubernetes
  - networking
  - service-mesh
  - istio
  - linkerd
  - consul
  - observability
---

## TL;DR

  - Microservices are about communicating through APIs!
  - A service mesh defines the **communication interface** between microservices.
  - In an orchestrated environment (Kubernetes), containers talk to each other on top of overlay networking.
  - Service mesh is a central source of truth for **controlling the information flow** between microservices.
  - Mesh enables both the scalability benefits of microservices as well as centralized advantages of monoliths.
  - Service meshes come with built-in observability (**logging**, **metrics**, and **tracing**) for microservices communications.
  - Service meshes have built-in support for resiliency features (_retries_, _timeouts_, deadlines, and _circuit breaking_).
  - They also have capabilities such as _east-west routing_, _access control_, _mTLS_, _smart load balancing_, etc.
  - **Data plane** refers to the layer allowing data to move between microservices and is implemented using _sidecars_.
  - A **sidecar** is an auxiliary container running side-by-side of the main container in your _pod_.
  - Microservices (main containers) communicate to each other through these sidecar containers.
  - Data plane does things like _service discovery_, _routing_, _load balancing_, _health checking_, _authn and authz_.
  - **Control plane** refers to the layer defining communication rules between microservices.
  - Control plane provides configurations and rules for all running data planes in the mesh.
  - Service mesh interface (SMI) defines a standard API for different services meshes, so they can interoperate.
  - [Istio](https://istio.io), [Linkerd](https://linkerd.io), and [Consul](https://www.consul.io) are service meshes adopted widely.

## Read More

  - [Service Mesh Ultimate Guide](https://www.infoq.com/articles/service-mesh-ultimate-guide)
  - [What is a Service Mesh?](https://www.hashicorp.com/resources/what-is-a-service-mesh)
  - [Intro to Service Meshes: Data Planes, Control Planes, and More](https://www.youtube.com/watch?v=CM2Y6B1yuDg)
  - [You Have a Service Mesh, Now What?](https://www.youtube.com/watch?v=IFjai8KniSs)
  - [Service Mesh Data Plane vs. Control Plane](https://blog.envoyproxy.io/service-mesh-data-plane-vs-control-plane-2774e720f7fc)
  - [Microservices Mesh — Part I](https://medium.com/faun/microservices-mesh-part-i-16ec52074dd2)
  - [Microservices Mesh — Part II](https://medium.com/faun/microservices-mesh-part-ii-istio-basics-b9c343594a05)
  - [Microservices Mesh — Part III](https://medium.com/faun/microservices-mesh-part-iii-istio-advanced-b969eef758bd)
  - [Hello Service Mesh Interface (SMI)](https://cloudblogs.microsoft.com/opensource/2019/05/21/service-mesh-interface-smi-release)
  - [Comparing Service Meshes: Istio, Linkerd and Consul Connect](https://www.cloudops.com/2019/03/comparing-service-meshes-istio-linkerd-and-consul-connect)
  - [Comparing Kubernetes Service Mesh Tools](https://caylent.com/comparing-kubernetes-service-mesh-tools)
  - [API Gateways and Service Meshes: Opening the Door to Application Modernisation](https://www.infoq.com/articles/api-gateway-service-mesh-app-modernisation)
