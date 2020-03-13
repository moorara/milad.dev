---
title: "sed By Examples"
date: 2020-03-11T14:00:00-04:00
draft: false
toc: true
tags:
  - unix
  - linux
  - sed
---

`sed` is a _stream editor_ command available on all Unix-compatible systems.
`sed` is quite a powerful tool, but the learning curve is also high comparing to other similar tools such as `grep` or `awk`.
Almost every time I want to do something with `sed`, I need to look it up and search for some examples.
So, I decided to compile a concise tutorial for `sed` that covers the most common useful use-cases.

With `sed`, you usually specify a few _options_ and a _script_ and feed it with an input file.

```
sed <options> <script> <input_file>
```

## Options

Here are some options for `sed` command that you most likely need to know about them.

| Option | Description                             |
|--------|-----------------------------------------|
| `-i`   | Edits the input file in-place.          |
| `-e`   | Specifies the scripts for editing.      |
| `-n`   | Suppresses printing each line of input. |

## Commands

Here are some common _commands_ that you may use in `sed` scripts:

| Command                 | Description                                              |
|-------------------------|----------------------------------------------------------|
| `g`                     | Global applies a command to every line of input.         |
| `p`                     | Prints the matching patterns to standard output.         |
| `d`                     | Deletes the matching patterns from output or input file. |
| `s/regexp/replacement/` | Replaces a _regexp_ instance with the _replacement_.     |

## Examples

| Example                          | Description                                               |
|----------------------------------|-----------------------------------------------------------|
| `sed -n '2p' input.txt`          | Shows a single line by line number.                       |
| `sed -n '2!p' input.txt`         | Shows all lines except one line number.                   |
| `sed -n '2p;4p' input.txt`       | Shows multiple lines by line numbers.                     |
| `sed -n '2,4p' input.txt`        | Shows multiple lines by a range.                          |
| `sed -n '2,4!p' input.txt`       | Shows all lines except a range of lines.                  |
| `sed -n '2,$p' input.txt`        | Shows all lines after a line number.                      |
| `sed -n '2,$!p' input.txt`       | Shows all lines before a line number.                     |
| `sed -i '2d' input.txt`          | Deletes a particular line in-place.                       |
| `sed -i '2,4d' input.txt`        | Deletes a range of lines in-place.                        |
| `sed -i '/regex/d' input.txt`    | Deletes all lines matching `regex` in-place.              |
| `sed -i '/regex/,$d' input.txt`  | Deletes all lines after a line matching `regex` in-place. |
| `sed -i 's/foo/bar/g' input.txt` | Replaces all occurrences of `foo` with `bar` in-place.    |

## Read More

  - https://www.tutorialspoint.com/sed
  - https://www.gnu.org/software/sed/manual/sed.html
