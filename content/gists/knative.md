---
title: "What is Knative?"
date: 2019-06-08T15:00:00-04:00
draft: true
toc: false
tags:
  - knative
  - container
  - kubernetes
  - serverless
---

## TL;DR

  - Knative is a cloud-native **serverless** framework for Kubernetes environments.
  - It is created and open-sourced by Google with contributions from other companies (Pivotal, IBM, Lyft, etc.).
  - Unlike current serverless frameworks (AWS Lambda, Azure Functions, ...), Knative eliminates cloud vendor lock-in.
  - Knative usese _Kubernetes_ for container orchestration and _Istio_ service mesh for routing, load balancing, etc.
  - Knative has three components: **Build**, **Serving**, and **Eventing**.
  - **Build**: builds containers from source code on Kubernetes (on-cluster container builds).
  - **Eventing**: enables a scalable _event-driven_ system for management of events between producers and consumers.
  - **Serving**: provides an abstraction for deployment, gradual _rollouts_, _autoscaling_, and configuring _Istio_ components.
  - **Cloud Run** is a managed Knative service offered by Google Cloud.

## Read More

  - [Knative](https://cloud.google.com/knative)
  - [Cloud Run](https://cloud.google.com/run)
  - [Knative: The Serverless Environment for Kubernetes Fans](https://blog.aquasec.com/knative-serverless-for-kubernetes)
  - [Knative: A Complete Guide](https://www.ibm.com/cloud/learn/knative)
  - [Hands on Knative — Part 1](https://medium.com/google-cloud/hands-on-knative-part-1-f2d5ce89944e)
  - [Hands on Knative — Part 2](https://medium.com/google-cloud/hands-on-knative-part-2-a27729f4d756)
  - [Hands on Knative — Part 3](https://medium.com/google-cloud/hands-on-knative-part-3-d8731ad2f23d)
