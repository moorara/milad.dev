---
title: "awk By Examples"
date: 2020-03-22T16:00:00-04:00
draft: false
toc: true
tags:
  - unix
  - linux
  - awk
---

`awk` is a domain-specific language and command for _text processing_ available on Unix-compatible systems.
`gawk` is the GNU AWK and all Linux distributions come with it.
This is a brief tutorial for `awk` covering the most common use-cases.

`awk` reads input line by line from a file, pipe, or stdin and executes a program on each line.
An input line has a number of fields separated by white space or by regular expression `FS`.
The fields are denoted `$1`, `$2`, and so on and `$0` denotes the entire line.
If `FS` is not set, the input line is split into one field per character.

```
awk <options> <program> <input_file>
```

## Options

Here are some options for `awk` command that you most likely need to know about them.

| Option | Description                                             |
|--------|---------------------------------------------------------|
| `-f`   | Specifies the file containing the awk program.          |
| `-F`   | Specifies the regular expression for separating fields. |

## Actions

An action is a sequence of statements.

| Action   | Description                     |
|----------|---------------------------------|
| `print`  | Prints data on standard output. |
| `printf` | Prints data on standard output. |

## Examples

| Example                               | Description                                            |
|---------------------------------------|--------------------------------------------------------|
| `awk 'BEGIN {print "Hello, World!"}'` | Prints _Hello, World!_ on stdout.                      |
| `awk -F '\t' '{print $2, $4}'`        | Prints the second and fourth columns separated by tab. |

## Read More

  - https://www.tutorialspoint.com/awk
  - https://www.gnu.org/software/gawk/manual/gawk.html
