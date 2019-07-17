---
title: "Building a Compiler in Go"
date: 2019-07-16T22:00:00-04:00
draft: true
toc: true
images:
tags:
  - lexer
  - parser
  - compiler
  - golang
  - goyacc
---

## Theory

### What is a Language?

Every Langauge is defined by specifying four sets:

#### Alphabet

The most primitive building block of a language is its alphabet.
An alphabet is a _finite set of symbols_.
The alphabet for English consists of letters A to Z (both capital and small) as well as punctuation marks.
The alphabet for a programming language includes characters A to Z, a to z, and other characters such as -, +, *, /, ', ", etc.

#### Words

Having defined the alphabet for a language, we can define the words of that language.
Each word is a combination of symbols from the language's alphabet.
The set of words for a language can be _finite_ or _infinite_.
The set of words in English is finite while the set of words in a programming language, with identifiers with arbitrary length, is infinite.

#### Grammer

The grammar of a language is a _set of rules_ determining how _sentences_ in the language can be constructed.
The English grammar allows a sentence like "Olivia goes to work" while it rejects a sentence like "Oliva to home went" (although all words are in English).
The Go programming language allows a statement like `var i int` while it does allow a statement such as `int i`.

#### Semantic

The semantics of a language, also known as **type system**, determines which sentences are meaningful and which ones are not.
In English, "Olivia eats an apple" makes sense while "An apple eats Olivia" does not!
This is because in English an object with type human can eat an object with type fruit while an object with type fruit cannot eat an object with type human!

### Different Types of Grammars and Languages

In the theory of formal languages, there are four types of grammars and respectively four types of languages.
These classes of _formal grammars_ have been formulated by _Noam Chomsky_ in 1956.

#### Type-3

Type-3 grammars, also known as **regular grammars**, generate **regular languages**.
These languages can be represented and decided by a _finite state machine_.
In a finite state machine, the _next state_ is the function of _current state_ and _the input_.
Equivalently, these languages can be denoted by **regular expressions**.

#### Type-2

Type-2 grammars, also known as **context-free grammars**, generate **context-free languages**.
Type-2 grammars are a superset of type-3 languages.
These languages can be represented and decided by a _non-deterministic pushdown automaton_.
In a pushdown automaton, the _next state_ is the function of _current state_, _the input_, and _the top of the stack_.
Most programming languages are context-free languages (and its subset of deterministic context-free languages).

**BNF** (Backus normal form) is a notation for defining context-free grammars.
We will also use this notation for defining the grammar for our language.

#### Type-1

Type-1 grammars, also known as **context-sensitive grammars**, generate **context-sensitive languages**.
Type-1 grammars are a superset of type-2 languages (thus type-3 languages as well).
These languages can be represented and decided by a _linear bounded automaton_.

#### Type-0

Type-o contains all formal grammars.
They generate all languages that can be represented and decided by a **Turing machine**.
