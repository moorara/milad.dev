---
title: "Zero-Config Configuration Management"
date: 2019-06-13T03:33:33-04:00
draft: false
toc: true
tags:
  - dry
  - config
  - konfig
  - golang
  - microservices
  - backend
---

[**konfig**](https://github.com/moorara/konfig) is a minimal and unopinionated _configuration management_ library for [Go](https://golang.org) applications.
It is based on [The 12-Factor App](https://12factor.net/config).
I created this library as a response to repeating myself across almost every single service and application.

It is a very minimal and lightweight library for reading configuration values either from _command-line arguments_, _environment variables_, or _files_.
It uses reflection to automatically convert the input values to the desired types defined in golang.
It also supports `slice`, `time.Duration`, and `url.URL` types.
It does NOT use the built-in `flag` package, so you can separately define and parse your command-line flags.

These are all types supported currently:

  - `bool`, `[]bool`
  - `string`, `[]string`
  - `float32`, `float64`
  - `[]float32`, `[]float64`
  - `int`, `int8`, `int16`, `int32`, `int64`
  - `[]int`, `[]int8`, `[]int16`, `[]int32`, `[]int64`
  - `uint`, `uint8`, `uint16`, `uint32`, `uint64`
  - `[]uint`, `[]uint8`, `[]uint16`, `[]uint32`, `[]uint64`
  - `time.Duration`, `[]time.Duration`
  - `url.URL`, `[]url.URL`

## Getting Started

All you need to do for your configuration management is defining a `struct`!

```go
package main

import (
  "fmt"
  "net/url"
  "time"

  "github.com/moorara/konfig"
)

var config = struct {
  Port        int
  LogLevel    string
  Timeout     time.Duration
  DatabaseURL []url.URL
} {
  Port:     3000,   // default port
  LogLevel: "info", // default logging level
}

func main() {
  konfig.Pick(&config)
  fmt.Printf("Port:        %d\n", config.Port)
  fmt.Printf("LogLevel:    %s\n", config.LogLevel)
  fmt.Printf("Timeout:     %v\n", config.Timeout)
  for _, u := range config.DatabaseURL {
    fmt.Printf("DatabaseURL: %s\n", u.String())
  }
}
```

### Using Default Values

Now, we compile this little piece of code using `go build -o app` command and run it!
Here is the output we see:

```
Port:        3000
LogLevel:    info
Timeout:     0s
```

### Using Command-Line Arguments

We can pass a different set of configuration values throguh _command-line arguments_ by running any of the following commands:

```
./app  -port 8080  -log.level debug   -timeout 60s  -database.url "mongo-1:27017,mongo-2:27017,mongo-3:27017"
./app  -port=8080  -log.level=debug   -timeout=60s  -database.url="mongo-1:27017,mongo-2:27017,mongo-3:27017"
./app --port 8080 --log.level debug  --timeout 60s --database.url "mongo-1:27017,mongo-2:27017,mongo-3:27017"
./app --port=8080 --log.level=debug  --timeout=60s --database.url="mongo-1:27017,mongo-2:27017,mongo-3:27017"
```

And we will see the following output once we run the application:

```
Port:        8080
LogLevel:    debug
Timeout:     1m0s
DatabaseURL: mongo-1:27017
DatabaseURL: mongo-2:27017
DatabaseURL: mongo-3:27017
```

You may notice how command-line argument names are constructed.

  - All lower-case with `.` as the separator character between words.
  - You can either use a single dash (`-`) or double dash (`--`) for an argument.
  - You can use space (` `) or assignment character (`=`) for the value of an argument.

### Using Environment Variables

Now Lets try passing the same configuration values through _environment variables_:

```bash
export PORT=8080
export LOG_LEVEL=debug
export TIMEOUT=60s
export DATABASE_URL="mongo-1:27017,mongo-2:27017,mongo-3:27017"

./app
```

And as expected, we will see the following output:

```
Port:        8080
LogLevel:    debug
Timeout:     1m0s
DatabaseURL: mongo-1:27017
DatabaseURL: mongo-2:27017
DatabaseURL: mongo-3:27017
```

Similarly, here is how environment variable names are constructed.

  - All upper-case with `_` as a separator character between words.

### Using Configuration Files

Finally, you can write the configuration values in files and pass the paths to these files into your application.
This is useful when you want to pass secrets into your application (mounting Kuberentes secretes as files for example).

```bash
echo -n "8080" > port.txt
echo -n "debug" > log_level.txt
echo -n "60s" > timeout.txt
echo -n "mongo-1:27017,mongo-2:27017,mongo-3:27017" > database_url.txt

export PORT_FILE="$PWD/port.txt"
export LOG_LEVEL_FILE="$PWD/log_level.txt"
export TRACING_FILE="$PWD/tracing.txt"
export TIMEOUT_FILE="$PWD/timeout.txt"
export DATABASE_URL_FILE="$PWD/database_url.txt"

./app
```

And we will see again the same output:

```
Port:        8080
LogLevel:    debug
Timeout:     1m0s
DatabaseURL: mongo-1:27017
DatabaseURL: mongo-2:27017
DatabaseURL: mongo-3:27017
```

### Using flag Package

konfig plays nice with `flag` package since it does NOT use `flag` package for parsing command-line flags.
That means you can define, parse, and use your own flags using built-in flag package.
If you use flag package, konfig will also add the command-line flags it is expecting.

Here is an example:

```go
package main

import (
  "flag"

  "github.com/moorara/konfig"
)

var config = struct {
  Port     int
  LogLevel string
} {
  LogLevel: "info",
}

func main() {
  konfig.Pick(&config)
  flag.Parse()
}
```

Now, if you run the app with `-help` flag, you would see the following:

```
Usage of ./app:
  -log.level value
    default value:                      info
    environment variable:               LOG_LEVEL
    environment variable for file path: LOG_LEVEL_FILE
  -port value
    default value:                      0
    environment variable:               PORT
    environment variable for file path: PORT_FILE
```

## Precedence

If configuration values are passed via different methods, the precendence is as follows:

  1. Command-line arguments
  1. Environment variables
  1. Configuration files
  1. Default values

## Customization

### Changing Default Names

If you want to override the default name for the command line argument or environment variables, here is how you can do it:

```go
package main

import (
  "fmt"

  "github.com/moorara/konfig"
)

var config = struct {
  LogLevel string `flag:"loglevel" env:"LOGLEVEL" fileenv:"LOGLEVEL_FILE_PATH"`
} {
  LogLevel: "info", // default logging level
}

func main() {
  konfig.Pick(&config)
  fmt.Printf("LogLevel: %s\n", config.LogLevel)
}
```

Here is how you can use the new names:

```bash
# using flag name
./app --loglevel=debug

# using environment variable
export LOGLEVEL=debug
./app

# using configuration file
echo -n "debug" > loglevel.txt
export LOGLEVEL_FILE_PATH="./loglevel.txt"
./app
```

### Changing Separator For Lists

If you want to pass a list of configuration values that the values themselves may include the default separator character (`,`),
here is how you can specify a different character as the separator:

```go
package main

import (
  "fmt"

  "github.com/moorara/konfig"
)

var config = struct {
  Rows []string `sep:"|"`
} {}

func main() {
  konfig.Pick(&config)
  for _, r := range config.Rows {
    fmt.Println(r)
  }
}
```

And now you can pass a value for this entry using command-line argument:

```
./app -rows="a,b,c|1,2,3"
```

### Skipping A Source

If you do not want your configuration values to be read from any of the sources, you can set its name to `-`.
For example, if you want a secret only be read from a file and neither command flag nor environment variable,
you can do it as follows:

```go
package main

import (
  "fmt"

  "github.com/moorara/konfig"
)

var config = struct {
  Token string `env:"-" fileenv:"-"`
} {}

func main() {
  konfig.Pick(&config)
  fmt.Println(config.Token)
}
```

And now you can only pass the token value via a configuration file:

```bash
# Will NOT work!
./app --token=123456789

# Will NOT work!
export TOKEN=123456789
./app

# ONLY this works!
echo -n "123456789" > token.txt
export TOKEN_FILE="$PWD/token.txt"
./app
```

## Options

You can pass a list of options to `Pick` method.
These options are helpers for specific setups and situations.

You can use `konfig.Debug()` option for printing debugging information.

`konfig.WatchInterval` option can be used for overriding the default interval when using `Watch()` method.

`konfig.Telepresence()` option lets you read configuration files
when running your application in a [Telepresence](https://www.telepresence.io) environment.
You can read more about _Telepresence_ proxied volumes [here](https://www.telepresence.io/howto/volumes.html).

## Debugging

If for any reason configuration values are not read as you expected,
you can use `Debug` option to see how exactly your configuration values are read.
`Debug` accepts a `verbosity` parameter which specifies the verbosity level of logs.
Here is an example:

```go
package main

import (
  "fmt"

  "github.com/moorara/konfig"
)

var config = struct {
  Port     int
  LogLevel string
} {
  LogLevel: "info",
}

func main() {
  konfig.Pick(&config, konfig.Debug(3))
  fmt.Printf("Port:     %d\n", config.Port)
  fmt.Printf("LogLevel: %s\n", config.LogLevel)
}
```

Now, try running the app as follows:

```
./app --port=3000
```

And, you see the following output:

```
2019/07/13 13:53:58 ----------------------------------------------------------------------------------------------------
2019/07/13 13:53:58 Options: Debug<3>
2019/07/13 13:53:58 ----------------------------------------------------------------------------------------------------
2019/07/13 13:53:58 [Port] expecting flag name: port
2019/07/13 13:53:58 [Port] expecting environment variable name: PORT
2019/07/13 13:53:58 [Port] expecting file environment variable name: PORT_FILE
2019/07/13 13:53:58 [Port] expecting list separator: ,
2019/07/13 13:53:58 [Port] value read from flag port: 3000
2019/07/13 13:53:58 [Port] setting integer value: 3000
2019/07/13 13:53:58 ----------------------------------------------------------------------------------------------------
2019/07/13 13:53:58 [LogLevel] expecting flag name: log.level
2019/07/13 13:53:58 [LogLevel] expecting environment variable name: LOG_LEVEL
2019/07/13 13:53:58 [LogLevel] expecting file environment variable name: LOG_LEVEL_FILE
2019/07/13 13:53:58 [LogLevel] expecting list separator: ,
2019/07/13 13:53:58 [LogLevel] value read from flag log.level: 
2019/07/13 13:53:58 [LogLevel] value read from environment variable LOG_LEVEL: 
2019/07/13 13:53:58 [LogLevel] value read from file environment variable LOG_LEVEL_FILE: 
2019/07/13 13:53:58 [LogLevel] falling back to default value
2019/07/13 13:53:58 ----------------------------------------------------------------------------------------------------
Port:     3000
LogLevel: info
```

You can also enable debugging logs by setting the `KONFIG_DEBUG` environment variable to a verbosity level.

## Watching

You can write new values to your configuration files, while your application is running.
konfig can watch your cofiguration files and if a new value is written, it will notify a list of subscribers.
This feature allows you to implement **dynamic configuration** and **secret injection** easily.
Let's show how this feature works using an example:

```go
package main

import (
  "fmt"
  "sync"
  "time"

  "github.com/moorara/konfig"
)

var config = struct {
  sync.Mutex
  LogLevel string
} {}

func main() {
  ch := make(chan konfig.Update)
  go func() {
    for update := range ch {
      if update.Name == "LogLevel" {
        config.Lock()
        fmt.Printf("Now logging with %s level ...\n", config.LogLevel)
        config.Unlock()
      }
    }
  }()

  stop, _ := konfig.Watch(&config, []chan konfig.Update{ch}, konfig.WatchInterval(2 * time.Second))
  defer stop()

  wait := make(chan bool)
  <-wait
}
```

Next, let's create a configuration file:

```bash
echo -n "Warn" > log_level
export LOG_LEVLE_FILE="$PWD/log_level"
```

Now, we run the app and we should see the following message:

```
Now logging with Warn level ...
```

In a new terminal, we write a new value to `log_level` file:

```bash
echo -n "Debug" > log_level
```

Within a few seconds, we should see the following message:

```
Now logging with Debug level ...
```
