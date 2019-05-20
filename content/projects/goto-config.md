---
title: "Zero-Config Configuration Management"
date: 2019-04-27T03:33:33-04:00
draft: false
toc: true
tags:
  - dry
  - config
  - golang
  - microservices
  - backend
---

[**goto/config**](https://github.com/moorara/goto/tree/master/config) is a _configuration management_ library for [Go](https://golang.org) applications.
I built this library as a response to repeating myself across every single microservice I have been working on.
This library has been used in production both in my past and current jobs for more than year.

goto/config is based on [The Twelve-Factor App](https://12factor.net/config).
It is a very minimal and lightweight library for reading configuration values either from _command-line arguments_, _environment variables_, or _files_.
It uses reflection to automatically convert the input values to the desired types defined in golang.
It also supports `slice`, `time.Duration`, and `url.URL` types.
It does NOT use the built-in `flag` package, so you can separately define your command-line flags.

These are all types supported currently:

  * `bool`, `[]bool`
  * `string`, `[]string`
  * `int`, `int8`, `int16`, `int32`, `int64`
  * `[]int`, `[]int8`, `[]int16`, `[]int32`, `[]int64`
  * `uint`, `uint8`, `uint16`, `uint32`, `uint64`
  * `[]uint`, `[]uint8`, `[]uint16`, `[]uint32`, `[]uint64`
  * `float32`, `float64`
  * `[]float32`, `[]float64`
  * `time.Duration`, `[]time.Duration`
  * `url.URL`, `[]url.URL`

## Getting Started

All you need to do for your confiuration management is defining a `struct`!

```go
package main

import (
  "fmt"
  "net/url"
  "time"

  "github.com/moorara/goto/config"
)

var Config = struct {
  Port           int
  LogLevel       string
  Tracing        bool
  RequestTimeout time.Duration
  DatabaseURL    []url.URL
} {
  Port:     3000,   // default port
  LogLevel: "info", // default logging level
}

func main() {
  config.Pick(&Config)
  fmt.Printf("Port:           %d\n", Config.Port)
  fmt.Printf("LogLevel:       %s\n", Config.LogLevel)
  fmt.Printf("Tracing:        %t\n", Config.Tracing)
  fmt.Printf("RequestTimeout: %v\n", Config.RequestTimeout)
  for _, u := range Config.DatabaseURL {
    fmt.Printf("DatabaseURL:    %s\n", u.String())
  }
}
```

### Using Default Values

Now, we compile this little piece of code using `go build -o app` command and run it!
Here is the output we see:

```
Port:           3000
LogLevel:       info
Tracing:        false
RequestTimeout: 0s
```

### Using Command-Line Arguments

We can pass a different set of configuration values throguh _command-line arguments_ by running any of the following commands:

```
./app  -port 8080  -log.level debug   -tracing  -request.timeout 60s  -database.url "mongo-1:27017,mongo-2:27017,mongo-3:27017"
./app  -port=8080  -log.level=debug   -tracing  -request.timeout=60s  -database.url="mongo-1:27017,mongo-2:27017,mongo-3:27017"
./app --port 8080 --log.level debug  --tracing --request.timeout 60s --database.url "mongo-1:27017,mongo-2:27017,mongo-3:27017"
./app --port=8080 --log.level=debug  --tracing --request.timeout=60s --database.url="mongo-1:27017,mongo-2:27017,mongo-3:27017"
```

And we will see the following output once we run the application:

```
Port:           8080
LogLevel:       debug
Tracing:        true
RequestTimeout: 1m0s
DatabaseURL:    mongo-1:27017
DatabaseURL:    mongo-2:27017
DatabaseURL:    mongo-3:27017
```

You may noticed how command-line argument names are constructed.

  - All lower-case with `.` as spearator character between words.
  - You can either use single dash (`-`) or double dash (`--`) for an argument.
  - You can use space (` `) or assignment character (`=`) for the value of an argument.

### Using Environment Variables

Now Lets try passing the same configuration values through _environment variables_:

```bash
export PORT=8080
export LOG_LEVEL=debug
export TRACING=true
export REQUEST_TIMEOUT=60s
export DATABASE_URL="mongo-1:27017,mongo-2:27017,mongo-3:27017"

./app
```

And as expected, we will see the following output:

```
Port:           8080
LogLevel:       debug
Tracing:        true
RequestTimeout: 1m0s
DatabaseURL:    mongo-1:27017
DatabaseURL:    mongo-2:27017
DatabaseURL:    mongo-3:27017
```

Similarly, here is how environment variable names are constructed.

  - All upper-case with `_` as spearator character between words.

### Using Configuration Files

Finally, you can write the configuration values in files and pass the paths to these files into your application.
This is useful when you want to pass secrets into your application (mounting Kuberentes secretes as files for example).

```bash
echo -n "8080" > port.txt
echo -n "debug" > log_level.txt
echo -n "true" > tracing.txt
echo -n "60s" > request_timeout.txt
echo -n "mongo-1:27017,mongo-2:27017,mongo-3:27017" > database_url.txt

export PORT_FILE="./port.txt"
export LOG_LEVEL_FILE="./log_level.txt"
export TRACING_FILE="./tracing.txt"
export REQUEST_TIMEOUT_FILE="./request_timeout.txt"
export DATABASE_URL_FILE="./database_url.txt"

./app
```

And we will see again the same output:

```
Port:           8080
LogLevel:       debug
Tracing:        true
RequestTimeout: 1m0s
DatabaseURL:    mongo-1:27017
DatabaseURL:    mongo-2:27017
DatabaseURL:    mongo-3:27017
```

## Precendence

If configuration values are passed via different methods, the precendence is as follows:

  1. Command-line arguments
  1. Environment variables
  1. Configuration files
  1. Default values

## Customization

### Changing Command-Line Argument Name

If you want to override the default name for a command line argument, here is how you go:

```go
package main

import (
  "fmt"

  "github.com/moorara/goto/config"
)

var Config = struct {
  LogLevel string `flag:"log_level"`
} {
  LogLevel: "info", // default logging level
}

func main() {
  config.Pick(&Config)
  fmt.Printf("LogLevel: %s\n", Config.LogLevel)
}
```

And here is how use this flag:

```bash
./app --log_level=debug
```

### Changing Environemnt Variable Name

If you want to override the default name for an environment variable, here is how you do it:

```go
package main

import (
  "fmt"

  "github.com/moorara/goto/config"
)

var Config = struct {
  LogLevel string `env:"LEVEL"`
} {
  LogLevel: "info", // default logging level
}

func main() {
  config.Pick(&Config)
  fmt.Printf("LogLevel: %s\n", Config.LogLevel)
}
```

And here is how use this flag:

```bash
export LEVEL=debug
./app
```

### Changing Environemnt Variable Name For Configuration File

If you want to override the default name for an environment variable specifying the path to a configuration file:

```go
package main

import (
  "fmt"

  "github.com/moorara/goto/config"
)

var Config = struct {
  LogLevel string `file:"LOG_LEVEL_FILE_PATH"`
} {
  LogLevel: "info", // default logging level
}

func main() {
  config.Pick(&Config)
  fmt.Printf("LogLevel: %s\n", Config.LogLevel)
}
```

And here is how use this flag:

```bash
echo -n "debug" > log_level.txt
export LOG_LEVEL_FILE_PATH="./log_level.txt"
./app
```

### Changing Separartor Character For Lists

If you want to pass a list of configuration values that the values themselves may include the default sperartor character (`,`),
here is how you can specify a different character to be considered as the separator:

```go
package main

import (
  "fmt"

  "github.com/moorara/goto/config"
)

var Config = struct {
  Rows []string `sep:"|"`
} {}

func main() {
  config.Pick(&Config)
  for _, r := range Config.Rows {
    fmt.Println(r)
  }
}
```

And here is how you pass a value for this entry using command-line argument:

```bash
./app -rows="a,b,c|1,2,3"
```
