---
title: "What is a Rules Engine?"
date: 2020-08-11T02:00:00-04:00
draft: false
toc: false
tags:
  - dsl
  - rules-engine
  - expert-system
---

## TL;DR

  - A **Rule** is a set of conditions triggering a set of actions (`if <conditions> then <action>`).
  - A _domain expert_ models the _domain knowledge_ (buisness rules) by defining the set of all the rules.
  - Rules are usually defined using a _domain-specific lanaguage_ also known as DSL.
  - Using these sets of rules, we can build an _expert system_ that can make decisions on behalf of _domain experts_.
  - A _rules engine_ is in the core of an _expert system_.
    - Data constantly come through the system in streams or in batches.
    - The rules engine decides when to evaluate which rules (evaluation can happen on-demand or in cycles).
    - The order in which rules are defined does not matter. The rules engine decides which rules should be evaluated in what order.
  - _Chaining_ happens when the action part of one rule changes the state of the system and the conditions of other rules which can lead to triggering other actions as well.
    - Chaining makes it very hard to reason about and debug the system.
  - An _inference engine_ applies logical rules to the knowledge base to infer new information from known facts.
    - Inference engines usually proceed in two modes: _forward chaining_ and _backward chaining_.
  - There are some challenges with rule-based systems and expert systems:
    - The sets of rules need to be defined and maintained by domain experts.
    - An expert system is just as capable and precise as the rules are.
    - For performance reasons, there are limitations applied to rule definitions (no. of rules, no. of conditions, cardinality of dimensions, etc.).

## Read More

  - [Rules Engine](https://martinfowler.com/bliki/RulesEngine.html)
  - [Domain Specific Languages](https://martinfowler.com/books/dsl.html)
  - [What is Rule-Engine?](https://medium.com/@er.rameshkatiyar/what-is-rule-engine-86ea759ad97d)
