---
title: "Building a Compiler in Go"
date: 2019-09-01T01:00:00-04:00
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

Type-0 grammars, also known as **unrestricted grammars** and **recursively enumerable**, contains all formal grammars.
They generate all languages that can be represented and decided by a **Turing machine**.

<br/>![Diagram](/images/chomsky-hierarchy.png "Chomsky hierarchy")<br/>

## What is a Compiler?

A _compiler_ is a computer program that translates a source code written in one programming language (source language) into another programming language (target language).
Compilers are usually used for translation from a higher-level programming language (Go, C/C++, etc.) to a lower-level one (assembly, binary code, etc.) for creating an _executable_ program.

### Compilers Architecture

Compilers benefit from a moduler design.
Very high level, compilers have three modules: **front-end**, **middle-end**, and **back-end**.

<br/>![Diagram](/images/compiler-arch.png "Compiler Architecture")<br/>

#### Front-end

The front-end of a compiler takes the source code as input and generates an _intermediate representation_ for it.
The front-end has four sub-modules: **lexer (scanner)**, **parser**, **semantic analyzer**, and **intermediate code generator**.
Hence, lexers are usually implemented using _finite state machines_.

<br/>![Diagram](/images/compiler-front-end.png "Compiler Front-end")<br/>

Lexer or scanner takes the source code as a stream of characters, tokenize them, and returns a stream of tokens as output.
If you remember, a language is defined by four sets. Characters are defined by language [alphabet](#alphabet) and tokens are defined by language [words](#words).
Tokens are language keywords, valid identifiers, literals, and so on. Tokens are defined using regular expressions ([type-3](#type-3)).

Parser is the sub-module that understands the language [grammar](#grammer).
Parser takes the stream of tokens and generates an abstract syntax tree.
Abstract syntaxt tree is a data structure that has all sentences (expressions) of your program.
The syntax of a language is usually defined using _context-free grammars_ ([type-2](#type-2)) and in BNF (Backus normal form).

Semantic analyzer is the sub-module that understands the language [semantic](#semantic).
It traverse the AST (abstract syntax tree) and ensures sentences (expressions) are semantically valid using the _type system_.
The output of this module is an _intermediate representation_ which is the AST with additional metadata, properties, and resolved references using _symbol table_.

The front-end of a compiler is the core of a compiler.
It translates the source code into a _machine-independent code_ that can later be translated into _machine-dependent code_.

#### Middle-end

The middle-end of a compiler takes the raw _intermediate representation_ and optimize it.
THe optimization is still independent of the target machine.

<br/>![Diagram](/images/compiler-middle-end.png "Compiler Middle-end")<br/>

#### Back-end

The back-end of a compiler takes the (optimized) intermediate representation and generates a _machine-dependent_ code that can be executed.
It has two sub-modules. The first sub-module generates machine code and the second sub-module optimize the generated machine code.
The end result is an assembly code targeted and optimized for a specific architecture (_386_, _amd64_, _arm_,  _arm64_, ...). 

<br/>![Diagram](/images/compiler-back-end.png "Compiler Back-end")<br/>

### Tools

In this section, we briefly review some the widely-used tools available for building compilers.

#### Lex/Flex

Lex is a program for generating and creating _lexers_ and _scanners_.
[Flex](https://github.com/westes/flex) (fast lexical analyzer generator) is an alternative to Lex.
Flex takes an input file that defines all valid tokens (words) of a language and generates a lexer in C/C++.
You can find an example of using Flex [here](https://github.com/moorara/compiler/tree/master/1-flex).

#### Yacc/Bison

Yacc (Yet Another Compiler-Compiler) is program for creating and generating LALR parsers ([Look-Ahead LR parser](https://en.wikipedia.org/wiki/LALR_parser)).
[Bison](https://www.gnu.org/software/bison) is a version of Yacc. Yacc/Bison are used together with Lex/Flex.
Bison reads a specification of a _context-free language_ written in _BNF_ and generates a parser in C/C++.
You can find an example of using Bison [here](https://github.com/moorara/compiler/tree/master/2-bison).

#### LLVM

[LLVM](https://llvm.org) (The LLVM Compiler Infrastructure) is an open-source project providing a set of tools
for building a _front-end_ for any programming language and a _back-end_ for any target instruction-set (architecture).
LLVM is built around a machine-independent intermediate representation which is a portable high-level assembly language.
You can find examples and tutorials get getting started with LLVM [here](https://llvm.org/docs/tutorial)

## Building A Compiler in Go

Now it is time for the fun part! We want to build a micro-compiler in Go.

### Defining The Language

Let's first define our language.
Our language has a very simple syntax for defining a logical formula of labels for querying different contents.
For example `(food,health)` means that we want all products belonging to _food_ and _health_ categories.
Or, `(store-1;store-2)` means that we are interested in all products that are available either in _store 1_ or _store 2_.

For defining a language, we need to specify four sets: _alphabet_, _words_, _grammer_, and _semantic_.
We define these four sets informally as follows:

  - alphabet = `unicode characters`, `digits`, `-`, `,`, `;`, `(`, and `)`
  - words = `(`, `)`, `,`, `;`, and `<labels>` (a unicode char followed by unicode chars, digits, or/and -)
  - grammar = a sequence of `<labels>` separated by `,` or `;` and enclosed by `(` and `)`
  - semantic = `empty set` (no semantic and no type-system)

Examples of letters in alphabet are `a`, `b`, `c`, `m`, `x`, `0`, `1`, `7`, `-`, `(`, `)`.
Examples of words are `food`, `health`, `store-1`, `store-2`, `(`, `)`.
Examples of sentences (based on words and grammar) are `(food,health)`, `(store-1;store-2)`.

### Building The Compiler

For building a compiler, we need to build a **scanner** and a **parser**.
Parse will create the **abstract synta tree** (_intermediate representation_).
We then use AST to generate our target code.

[goyacc](https://godoc.org/golang.org/x/tools/cmd/goyacc) is a version of Yacc for building parsers and syntax analyzers in Go.
For building the scanner in Go, there is no equivalent of Lex. You have few options.
Depending on how complex is your language, you can create your own scanner/lexer using available packages such as `text/scanner`.
There are also tools like [Ragel](http://www.colm.net/open-source/ragel) for generating lexical analyzers in Go.
Many times, using a tool for generating your lexer is overkill and generated lexers are not usually as fast as hand-written ones.

In our example we are going to create a simpe lexer using built-in `text/scanner` package.

## References

  - [Chomsky hierarchy](https://en.wikipedia.org/wiki/Chomsky_hierarchy)
  - [Compiler Wikipedia](https://en.wikipedia.org/wiki/Compiler)
  - [Compiler Architecture](https://cs.lmu.edu/~ray/notes/compilerarchitecture)
  - [LLVM Wikipedia](https://en.wikipedia.org/wiki/LLVM)

**Tutorials**:

  - [Writing A Compiler In Go](https://compilerbook.com)
  - [How to Write a Parser in Go](https://about.sourcegraph.com/go/gophercon-2018-how-to-write-a-parser-in-go)
  - [Lexical Scanning in Go](https://talks.golang.org/2011/lex.slide)
  - [A look at Go lexer/scanner packages](https://medium.com/@farslan/a-look-at-go-scanner-packages-11710c2655fc)
  - [Lexing with Ragel and Parsing with Yacc using Go](https://medium.com/@mhamrah/lexing-with-ragel-and-parsing-with-yacc-using-go-81e50475f88f)
  - [How to write a compiler in Go: a quick guide](https://www.freecodecamp.org/news/write-a-compiler-in-go-quick-guide-30d2f33ac6e0)
