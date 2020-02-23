---
title: "The Configuration Complexity Curse"
date: 2020-02-22T22:00:00-04:00
draft: false
toc: false
tags:
  - cue
  - dcl
  - yaml
  - configuration
  - automation
  - kubernetes
---

## TL;DR

  - Three different approaches to dynamic configuration:
    - **Templating**
      - Examples: [Helm](https://helm.sh), [gomplate](https://gomplate.ca), etc.
      - Text templating very quickly becomes fragile, hard-to-understand, and hard-to-maintain.
      - Template writers lack the tools to build abstractions around the data.
    - **Layering**
      - Examples: [kustomize](https://github.com/kubernetes-sigs/kustomize)
      - Data layering breaks down when configurations grow in complexity and scale.
      - Template writers lack abstraction and type validation.
      - For large scale projects, inheritance creates deep layers of abstractions.
      - Semantics are locked into an opaque tool and not exposed as language features.
    - **Data Configuration Language (DCL)**
      - Examples: [jsonnet](https://jsonnet.org), [ksonnet](https://github.com/ksonnet/ksonnet) [kubecfg](https://github.com/bitnami/kubecfg), etc.
  - Any declarative systems and tools that grow in size and complexity need to be abstracted.
  - [**CUE**](https://cuelang.org) is a language for defining, generating, and validating all kinds of data.
  - CUE is designed around [graph unification](https://en.wikipedia.org/wiki/Graph_theory#Subsumption_and_unification).
    - Sets of _types_ and _values_ can be modeled as directed graphs and then unified to the most specific representation of all graphs.
  - CUE makes tasks like _validation_, _templating_, _querying_, and _code generation_ first class features.
  - CUE's type system is expressive. For a given field, you can specify the type as well as optionality and constraints from other fields.
  - CUE also has a _declarative scripting_ layer built on top of the configuration language.

## Read More

  - [The Configuration Complexity Curse](https://blog.cedriccharly.com/post/20191109-the-configuration-complexity-curse)
  - [CUE](https://cuelang.org)
  - [The CUE Data Constraint Language](https://cue.googlesource.com/cue)
  - [Kubernetes Tutorial](https://cue.googlesource.com/cue/+/refs/heads/master/doc/tutorial/kubernetes/README.md)
