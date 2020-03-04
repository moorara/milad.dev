---
title: "Developing Go Services For Kubernetes with Telepresence and konfig"
date: 2020-03-04T16:00:00-04:00
draft: false
toc: true
tags:
  - dry
  - config
  - konfig
  - golang
  - secret
  - docker
  - kubernetes
  - microservices
  - telepresence
---

## The Problem

As a developer when you are working on a Kubernetes application on your local machine,
if you want to test or debug something, you have the following options:

  - A full environment running using [docker-compose](https://docs.docker.com/compose).
  - A full environment running in a local Kubernetes cluster
  ([Minikube](https://kubernetes.io/docs/setup/learning-environment/minikube) or [Docker-for-Desktop](https://www.docker.com/products/docker-desktop))
  - Pushing instrumented code, building, testing, and deploying to a _dev_ Kubernetes cluster through CI/CD pipeline.

The problem with the first two options is the environment you get is not close by any means to your actual final environment (_staging_ and _production_).
And, the last option is very time-consuming for developers to make a small change and go through the full CI/CD pipeline each time.

## What is Telepresence?

[Telepresence](https://www.telepresence.io) is a [CNCF](https://www.cncf.io) project created by [Datawire](https://www.datawire.io).
It is such a great tool for developers to debug and test their codes locally without going through the full deployment process to a Kubernetes cluster.

Telepresence creates a two-way network proxy between a _Pod_ and a process running locally on your machine.
_TCP connections_, _environment variables_, _volumes_, etc. are proxied from your pod to the local process.
The networking for the local process is also transparently changed,
so _DNS_ calls and _TCP connections_ from your local process will be proxied to the remote Kubernetes cluster.

After [installing](https://www.telepresence.io/reference/install) Telepresence, you can try out the following:

```
telepresence --swap-deployment <name> --run-shell
```

This will run a _shell_ locally while all _TCP connections_, _environment variables_, _volumes_ from the pod `<name>` are available.

## What is konfig?

[konfig](https://github.com/moorara/konfig) is a minimal and unopinionated library for reading configuration values in Go applications.
You can read more about it and how to use it [here](https://milad.dev/projects/konfig).
Using `konfig`, reading and parsing configuration values is as easy as defining a struct! Here is an example:

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
  // ...
}
```

## How does konfig Help?

When working with Kubernetes [Secrets](https://kubernetes.io/docs/concepts/configuration/secret), you want to access them as mounted volumes and files.
This way you can set file permissions for mounted secrets and they are updated automatically when you make a change to your secrets.

In a Telepresence session, the file system of pod including all volumes is mounted from a path specified in `TELEPRESENCE_ROOT` environment variable.
If you want to run your application in a Telepresence session the same way you run it in your pod,
you need to build some logic in your application to take `TELEPRESENCE_ROOT` into account.

`konfig` is an out-of-the-box solution for transparently reading your configuration values either in a real Pod environment or in a Telepresence session.

## An Example

You can find the source code for this example [here](https://github.com/moorara/konfig/tree/master/examples/4-telepresence).

Let's build and push the Docker image and then deploy the resources to Kubernetes.

```bash
# current directory: examples/4-telepresence
make docker k8s-deploy
```

If we get the logs for our pod (`kubectl logs <pod_name>`), we should see something similar to the following line:

```log
2019/07/14 23:45:54 making service-to-service calls using this token: super-strong-secret
```

Now, we are going to see how we can use _Telepresence_ and `konfig`.
First, let's see how Telepresence works.
Run the following commands:

```
go build -o app
telepresence --swap-deployment example --run ./app
```

If you run `ls` command, you would see your local files.
If you run `env` command, you would see the `AUTH_TOKEN_FILE` environment variable is present.
Next, try running `echo $TELEPRESENCE_ROOT` and then `cd $TELEPRESENCE_ROOT`. This is where the file system of your pod is mounted.
In a Telepresence session, you need to prepend `$TELEPRESENCE_ROOT` to the paths of mounted volumes.
We will see how `konfig` can automatically detect a Telepresence session and read your secrets the same way as they are in your pod.

Now, let's make a change to our code as follows:

```go
konfig.Pick(&Config, konfig.Telepresence(), konfig.Debug(5))
log.Printf("auth token: %s", Config.AuthToken)
```

Without building a new Docker image and pushing it, we just compile our application and run it using `telepresence` command.

```
go build -o app
telepresence --swap-deployment example --run ./app
```

You will see our app is running locally and the `AuthToken` is successfully read from the Telepresence environment.

```log
2019/07/14 19:58:24 ----------------------------------------------------------------------------------------------------
2019/07/14 19:58:24 Options: Debug<5> + Telepresence
2019/07/14 19:58:24 ----------------------------------------------------------------------------------------------------
2019/07/14 19:58:24 [AuthToken] expecting flag name: auth.token
2019/07/14 19:58:24 [AuthToken] expecting environment variable name: AUTH_TOKEN
2019/07/14 19:58:24 [AuthToken] expecting file environment variable name: AUTH_TOKEN_FILE
2019/07/14 19:58:24 [AuthToken] expecting list separator: ,
2019/07/14 19:58:24 [AuthToken] value read from flag auth.token:
2019/07/14 19:58:24 [AuthToken] value read from environment variable AUTH_TOKEN:
2019/07/14 19:58:24 [AuthToken] value read from file environment variable AUTH_TOKEN_FILE: /secrets/myappsecret/auth-token
2019/07/14 19:58:24 [AuthToken] telepresence root path: /tmp/tel-deewv8wa/fs
2019/07/14 19:58:24 [AuthToken] value read from file /tmp/tel-deewv8wa/fs/secrets/myappsecret/auth-token: super-strong-secret
2019/07/14 19:58:24 [AuthToken] setting string value: super-strong-secret
2019/07/14 19:58:24 ----------------------------------------------------------------------------------------------------
2019/07/14 19:58:24 auth token: super-strong-secret
```

## Conclusion

[Telepresence](https://www.telepresence.io) is a great tool for developing applications for Kubernetes.
[konfig](https://github.com/moorara/konfig) makes reading and parsing of configuration values for Go applications extremely easy.
It can also read configuration values in a Telepresence session transparently.
