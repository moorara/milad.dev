---
title: "GitOps?"
date: 2019-07-14T15:00:00-04:00
draft: false
toc: false
tags:
  - devops
  - gitops
  - kubernetes
  - automation
  - continuous-integration
  - continuous-delivery
---

## TL;DR

  - GitOps is an operation model for cloud-native applications running on Kubernetes (created by _Weaveworks_).
  - To the most part, it is _infrastructure-as-code_ with continuous integration and continuous delivery.
  - The idea is having _Git_ as _the source of truth_ for all operations.
  - A single Git repository describes the entire desired state of the system.
  - Operational changes are made through pull requests.
  - Changes can be peer-reviewed, versioned, released, rolled back, audited, etc.
  - Diff tools detect any divergence and sync tools enable convergence.
  - GitOps can be used for managing Kubernetes clusters since Kubernetes uses declarative resource definitions.
  - Kubernetes secrets can also be stored in Git repo using one-way encryption (take a look at [sealed-secrets](https://github.com/bitnami-labs/sealed-secrets))
  - GitOps in contrast to CIOps improves your workflow in the following ways:
    - All of your configurations and changes to them are centralized in one place (easier to track, audit, and reason about).
    - Divergences will be detected and the cluster will be converged again automatically (failed deployments will be retried too).
  - GitOps can be done using either a _Push_ approach or a _Pull_ approach.
  - With _push_ your cluster credentials are in your build system whereas with _pull_ no external system has access to your cluster.

## Read More

  - [GitOps](https://www.weave.works/technologies/gitops)
  - [GitOps - Operations by Pull Request](https://www.weave.works/blog/gitops-operations-by-pull-request)
  - [Kubernetes Anti-Patterns: Let's do GitOps, not CIOps!](https://www.weave.works/blog/kubernetes-anti-patterns-let-s-do-gitops-not-ciops)
  - [Managing Secrets in Kubernetes](https://www.weave.works/blog/managing-secrets-in-kubernetes)
  - [GitOps — Comparison Pull and Push](https://medium.com/faun/gitops-comparison-pull-and-push-88fcbaadfe45)
  - [Argo CD](https://argoproj.github.io/argo-cd)
