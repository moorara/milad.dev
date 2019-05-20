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
Microservices is neither about the number of microservices you have, different programming lanagues and frameworks, nor your API paradigms!
In essence, microservices architecture is _Software-as-as-Service_ done right!

The most import thing to get microservices right is **service contracts**.
A _service contract_ is an API that a given service exposes thorugh an API paradigm (REST, RPC, GraphQL, etc.).
Once a service is ready (so, is its API), other services start to use and rely on its API.
At this point, the service should not break its API (contract) at any point in time.
Any change to the current major version of API should be backward-compatible.
Breaking changes should be introduced in a new major version of that service (technically a new service!).

## What About gRPC?

gRPC is an RPC API paradigm for service-to-service communications.
You can implement and expose your service API (contract) using gRPC.
Thanks to [grpc-web](https://github.com/grpc/grpc-web) project, you can now make gRPC calls from your web application too.
Topics like comparison between gRPC and REST or whether you need to implement your service API using gRPC are again out of the scope this post.

gRPC itself is heavily based on [Protocol Buffers](https://developers.google.com/protocol-buffers).
Protocol Buffers are a cross-platform language-agnostic standard for serializing and deserialzing structured data.
So, instead of sending plaintext JSON or XML data over the network, you would send and receive highly optimized and compacted bytes of data.
The version 1 of Protocol Buffers have been used internally at Google for many years.
Since version 2, Protocol Buffers are publicly avaialble. The latest and recommended version of Protocol Buffers is version 3.

gRPC uses Protocol Buffers to define service contracts.
Each service definition specifies a number of methods with expected input and output messages.
Using gRPC libraries available for major programming langauges, these gRPC protocol buffers can be implemented either as server or client.
For compiled programming langauges like [Go](https://golang.org), source codes need to be generated using Protocol Buffers Compiler ahead of time.
