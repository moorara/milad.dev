---
title: "What is Nix?"
date: 2021-12-14T22:00:00-04:00
draft: false
toc: false
tags:
  - nix
  - nixos
---

## TL;DR

Nix is a purely **functional package manager**.
It treats packages like values in purely functional programming languages.
Packages are built by functions that do not have side-effects, and they never change after they have been built.

## Concepts

Everything on your computer implicitly depends on a whole bunch of other things on your computer.
Your computer is trusted to have acceptable versions of acceptable libraries in acceptable places.
Nix removes these assumptions and makes the whole graph explicit.

  - All software exists in a graph of dependencies.
  - Most of the time, this graph is implicit.
  - Nix makes this graph explicit.

### The Nix Store

  - Nix stores packages in the Nix store, usually the directory `/nix/store`, where each package has its own unique subdirectory.
  - This directory represents a **graph**.
    - Each file or directory is a **node**.
    - The relationships between them constitute **edges**.
  - Only the Nix itself can write to `/nix/store` directory.
  - Once Nix writes a node into this graph database, it is completely **immutable** forever after.
    - Nix guarantees that the content of a node does not change after it is been created.
  - An Edge directed from a node is a dependency.
    - If a node includes a reference to another node, it depends on that node.
    - The **transitive closure** includes dependencies of dependencies as well.

| Command | Description |
|---------|-------------|
| `nix-store --query --references`| Shows all immediate dependencies for a store path (edges directed from a node). |
| `nix-store --query --requisites`| Shows all direct and indirect dependencies for a store path (transitive closure of all edges directed from a node). |
| `nix-store --query --referers` | Shows all store paths that directly depend on a store path (edges directed to a node). |
| `nix-store --query ----referrers-closure` | Shows all store paths that directly or indirectly depend on a store path (transitive closure of all edges directed to a node). |

### Derivations

  - A derivation is a recipe to build some other path in the Nix Store.
  - A derivation is a special node (`*.drv`) in the Nix store, which tells Nix how to build one or more other nodes.
  - It is a special format written and read by Nix, which gives build instructions for anything in the Nix store.
    - Everything required to build this derivation is explicitly listed in the file by path (*outputs, inputDrvs, inputSrcs, platform, builder, args, env*).
  - Everything, except derivations themselves, in the Nix store is put there by building a derivation.
  - The hash in a derivation path is a hash of the content of the derivation file.
    - If a dependency of the derivation changes, that changes the hash of the derivation.
    - It also changes the hashes of all of that derivation's outputs.
    - Changing a dependency bubbles all the way down, changing the hashes of every derivation and all those derivation's outputs that directly or indirectly depend on.

### Sandboxing

  - A derivation build simply cannot access anything not declared by the derivation.
    - Nix uses patched versions of compilers and linkers that do not try to look in the default locations.
    - Nix builds derivations in an actual sandbox that denies access to everything that the build is not supposed to access.

### The Nix Language

  - The Nix language is **lazy-evaluated** and **free of side-effects**.
  - The Nix Language is just a *Domain Specific Language* for creating derivations.
    - The Nix Language does not build anything. It creates derivations, and later, other Nix tools read those derivations and build the outputs.

## Read More

  - [NixOS](https://nixos.org)
  - [nix.dev](https://nix.dev)
  - [What is Nix](https://shopify.engineering/what-is-nix)
