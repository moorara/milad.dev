---
title: "gRPC in Microservices"
date: 2019-05-19T16:38:33-04:00
draft: true
toc: true
tags:
  - api
  - rpc
  - grpc
  - protobuf
  - golang
  - microservices
  - backend
---

I have been working with a microservices application using [gRPC](https://grpc.io) as the main service-to-service communication mechanism for almost a year.
So, I decided to write a blog post and share my experience on how to do gRPC right in a microservices world! So, let's get started!

## Microserviecs?

Defining what _microservices_ architecture is and whether you need to adopt it or not are beyond te scope of this post.
Unfortunately, the term microservices has become one of those buzz words these days.
Microservices is neither about the number of microservices, different programming lanagues and frameworks, nor your API paradigms!
In essence, microservices architecture is _Software-as-as-Service_ done right!

The most import thing to get microservices right is **service contracts**.
A _service contract_ is an API that a given service exposes thorugh an API paradigm (REST, RPC, GraphQL, etc.).
In microservices world, the only way for microservices to communicate and share data is through their APIs.
A microservice is solely the source of truth for a bounded context or resource that it owns.
Once a service is ready (so, is its API), other services start to use and rely on its API.
At this point, the service should not break its API (contract) at any point in time.
Any change to the current major version of API should be backward-compatible.
Breaking changes should be introduced in a new major version of that service (technically a new service!).

One important implication of microservices architecture is the organizational change that it requires and introduces!
The same way that microservices are small, independent, and self-sufficient,
the same way they can use different technologies and follow different development workflow and release cycles,
the same way microservices should be managed from an organizational point of view!
This means each microservice can be owned by a very small team (usually one or two)
and different teams (microservices) can adopt slightly different practices (coding style, dependency management, etc.)
as far as they don't break their commitment (service contract or API) to other teams (other microservices).

## What About gRPC?

gRPC is an RPC API paradigm for service-to-service communications.
You can implement and expose your service API (contract) using gRPC.
Thanks to [grpc-web](https://github.com/grpc/grpc-web) project, you can now make gRPC calls from your web application too.
Topics like comparison between gRPC and REST or whether you need to implement your service API using gRPC are again out of the scope of this post.

gRPC itself is heavily based on [Protocol Buffers](https://developers.google.com/protocol-buffers).
Protocol Buffers are a cross-platform language-agnostic standard for serializing and deserialzing structured data.
So, instead of sending plaintext JSON or XML data over the network, you would send and receive highly optimized and compacted bytes of data.
The version 1 of Protocol Buffers have been used internally at Google for many years.
Since version 2, Protocol Buffers are publicly avaialble. The latest and recommended version of Protocol Buffers is version 3.

gRPC uses Protocol Buffers to define service contracts.
Each service definition specifies a number of methods with expected input and output messages.
Using gRPC libraries available for major programming langauges, these gRPC protocol buffers can be implemented both as server or client.
For compiled programming langauges like [Go](https://golang.org), source codes need to be generated using Protocol Buffers Compiler ahead of time.

## Architecture

The Microservices architeture I have been working on consists of roughly 40 microservices
all written in [Go](https://golang.org) and containerized using [Docker](https://www.docker.com).
Since Go is a compiled and statically typed language, all gRPC/ProtoBuf defnitions should be compiled and source codes for Go should be generated in advance.
An API gateway receives HTTP RESTful requests and backend communications are done through gRPC calls between different microservices.

<br/>![Example image](/images/ms-grpc-arch.png "Microservices gRPC Architecture")<br/>

## Challenges

### Health Check?

One immediate question for a service that only talks gRPC is how do we implement **health check**?
Or if you are using Kubernetes as your container  platform, how do we implement **liveness** and **readiness** probes?

To this end, we have two options:

  - Defining and implementing the health check probes as gRPC calls.
  - Starting an http server on a different port and implementing health check probes as http endpoints.

### Load Balancing

Here is another interesting challenge! How do we do load balancing for services talking gRPC?
For answering this question, we need to remember how gRPC is working under the hood.

### Dependency Management

Dependency management is another important topic for maintaining microservices in general.
gRPC community has done a great job maintaining backward-compatibility between different versions Protocol Buffers compiler (protoc).
This is one of the key factors in making gRPC a successful RPC API paradigm.
protoc plugin for generating Go source codes also has done a good job maintaining backward-compatibility among different versions of `protoc` and `go`.

### Centralize or Decentralize Protocol Buffers Management?

When it comes to managing your gRPC Protocol Buffers and generated files, you have two options:

  - Keep Protocol Buffers and generated files on the same repo as the owner microservice (decentralize)
  - Centralizing all Protocol Buffers and generated files in one mono repo.

## Lessons Learnt

### 1. Implement healch check probes as http endpoints

### 2. Use service mesh for load balancing

### 3. Use globally unique name for your gRPC Protocol Buffers

### 4. Use singular form of a name for your package name

### 5. Use a prefix or suffix for your package name to indicate that this package is a protocol buffer

### 6. Centralize your gRPC Protocol Buffers in a mono repo

### 7. Automate your dependency management

### 8. Generate the source codes as build artifacts in your pipeline
