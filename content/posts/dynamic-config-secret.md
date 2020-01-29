---
title: "Dynamic Configuration Management and Secret Injection with konfig"
date: 2019-09-02T18:00:00-04:00
draft: false
toc: true
tags:
  - dry
  - konfig
  - golang
  - config
  - secret
  - docker
  - kubernetes
  - microservices
---

## TL;DR

  - Dynamic configuration management and secret injection refer to updating an application with new configurations and secrets in a non-disruptive way.
  - Kubernetes _ConfigMaps_ and _Secrets_ mounted as files into containers will be updated with new values automatically.
  - [konfig](https://github.com/moorara/konfig) makes dynamic configuration management and secret injection very easy to implement and use for Go applications.

## The Problem

Dynamic configuration management and secret injection refer to a situation that your application can update its configurations and secrets without needing a restart.

**Example 1:** Let's imagine you have a microservice deployed to Kubernetes. This microservice serves an API and consumers constantly make requests to it.
The verbosity level of logging for this microservice is a configurable parameter that is passed to the container through a _ConfigMap_.
As a best practice (ex. cost-saving), you only want _warning_ or _error_ logs in production.
Now, let's consider a case that your microservice is handling a long-lived background job and you want to see logs for this job at _debug_ level.
Normally, you go change the verbosity level in your ConfigMap and restart your pods. But, in this case, restarting pods also means killing the background job!
How do you change the logging verbosity level while your job continues running and without restarting any pod?

**Example 2:** In another scenario, you have a microservices application in which you have an _auth_ microservice responsible for signing JSON web tokens ([jwt](https://jwt.io)).
Other microservices need to authenticate and authorize API requests with the tokens issued by _auth_ microservice.
For this purpose, they need to verify a _JWT_ token using the same key that _auth_ microservice signed the token with it.
All of these microservices, including _auth_, read the signing key from a Kubernetes _Secret_.
Now, let's say your signing key is comprised and you want to rotate your secret. How would you do this without restarting all of your microservices?

## Solution

Both examples described in the previous section can be addressed by dynamic configuration management and secret injection.
For achieving this, two things need to be done:

  1. Injecting the new configuration/secret into your environment (container).
  1. Picking up the new configuration/secret in your application.

If you are using a container orchestration platform like Kubernetes, the first problem is taken care of automatically.
In Kubernetes, Mounted _ConfigMaps_ and _Secrets_ are updated automatically.
This means if you mount a _ConfigMap_ or _Secret_ as a volume into your container,
whenever you make a change to your _ConfigMap_ or _Secret_, the mounted files in your container will eventually be updated with new values.

For addressing the second problem, you need to watch for changes to mounted files in a parallel thread in your application.
As soon as you detect a change, you need to update your application to reflect the change in a thread-safe way (without data race or deadlock!).

## DRY!

You don't have to repeat yourself across all different applications and microservices.
More importantly, you also don't have to be trapped in concurrency issues (data races, deadlock, etc.).

[konfig](https://github.com/moorara/konfig) is a very minimal and unopinionated utility
for reading configurations in Go applications based on [The 12-Factor App](https://12factor.net/config).
konfig can also watch for changes to configuration files and notify a list of subscribers on a _channel_.
konfig makes dynamic configuration management and secret injection very easy to implement and use.
As a consumer of this library, you don't have to deal with parsing different data types and concurrency issues such as data races.
You can find examples of using konfig [here](https://github.com/moorara/konfig/tree/master/examples).

## A Real-World Example

In this section, we want to demonstrate a real-world example of dynamic configuration management using konfig.
Here is an overview of what we are going to do:

  1. We will deploy two microservices to a Kubernetes cluster.
  1. The _servers_ provide a simple HTTP endpoint and the clients call this endpoint every second.
  1. The server pods log on every request in _info_ level.
  1. The client pods log on every response in _info_ level as well.
  1. Initially, the microservices are configured to only show _warn_ level logs, so we won't see any log.
  1. Then, we will update the _ConfigMaps_ for server and client.
  1. Without restarting the pods, we will see logs from server and client pods after a little while.

### Server Part

Here is the source code of our server in Go:

```go
package main

import (
  "net/http"
  "sync"
  "time"

  "github.com/moorara/konfig"
  "github.com/moorara/observe/log"
)

var config = struct {
  sync.Mutex
  LogLevel string
}{
  // default value
  LogLevel: "Info",
}

func main() {
  // Create the logger
  lo := log.Options{Name: "server"}
  logger := log.NewLogger(lo)

  // Listening for any update to configurations
  ch := make(chan konfig.Update)
  go func() {
    for update := range ch {
      if update.Name == "LogLevel" {
        config.Lock()
        lo.Level = config.LogLevel
        config.Unlock()
        logger.SetOptions(lo)
      }
    }
  }()

  // Watching for configurations
  konfig.Watch(
    &config,
    []chan konfig.Update{ch},
    konfig.WatchInterval(5*time.Second),
  )

  // HTTP handler
  http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
    logger.InfoKV("message", "new request received")
    w.WriteHeader(http.StatusOK)
  })

  // Starting the HTTP server
  logger.InfoKV("message", "starting http server ...")
  http.ListenAndServe(":8080", nil)
}
```

This is the `Dockerfile` we use for containerizing our server application:

```dockerfile
FROM golang:1.13-alpine as builder
RUN apk add --no-cache git
WORKDIR /repo
COPY . .
RUN go build

FROM alpine:3.11
EXPOSE 8080
COPY --from=builder /repo/server /usr/local/bin/
RUN chown -R nobody:nogroup /usr/local/bin/server
USER nobody
CMD [ "server" ]
```

And, these are the resources that we deploy to our Kubernetes cluster:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-server
  labels:
    name: app-server
data:
  log-level: "warn"
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-server
  labels:
    name: app-server
spec:
  replicas: 2
  selector:
    matchLabels:
      name: app-server
  template:
    metadata:
      labels:
        name: app-server
    spec:
      restartPolicy: Always
      containers:
        - name: server
          image: moorara/app-server:latest
          imagePullPolicy: Always
          command: [ "server" ]
          ports:
            - name: http
              containerPort: 8080
              protocol: TCP
          env:
            - name: LOG_LEVEL_FILE
              value: /configs/server/log-level
          volumeMounts:
            - name: app-server
              mountPath: /configs/server
              readOnly: true
      volumes:
        - name: app-server
          configMap:
            name: app-server
            defaultMode: 420
---
apiVersion: v1
kind: Service
metadata:
  name: app-server
  labels:
    name: app-server
spec:
  type: ClusterIP
  selector:
    name: app-server
  ports:
    - name: http
      protocol: TCP
      port: 8080
      targetPort: http
```

Finally, we use this `Makefile` for running our commands in an easier way:

```makefile
build:
  go build

docker:
  docker image build --tag moorara/app-server:latest .
  docker image push moorara/app-server:latest

k8s-deploy:
  kubectl create -f kubernetes.yaml

k8s-delete:
  kubectl delete service app-server
  kubectl delete deployment app-server
  kubectl delete configmap app-server

.PHONY: build docker k8s-deploy k8s-delete
```

### Client Part

Here is the source code of our client in Go:

```go
package main

import (
  "fmt"
  "net/http"
  "sync"
  "time"

  "github.com/moorara/konfig"
  "github.com/moorara/observe/log"
)

var config = struct {
  sync.Mutex
  LogLevel      string
  ServerAddress string
}{
  // default values
  LogLevel:      "Info",
  ServerAddress: "http://localhost:8080",
}

func main() {
  // Create the logger
  lo := log.Options{Name: "client"}
  logger := log.NewLogger(lo)

  // Server address
  endpoint := "/"
  url := fmt.Sprintf("%s%s", config.ServerAddress, endpoint)

  // Listening for any update to configurations
  ch := make(chan konfig.Update)
  go func() {
    for update := range ch {
      switch update.Name {
      case "LogLevel":
        config.Lock()
        lo.Level = config.LogLevel
        config.Unlock()
        logger.SetOptions(lo)
      case "ServerAddress":
        config.Lock()
        url = fmt.Sprintf("%s%s", config.ServerAddress, endpoint)
        config.Unlock()
      }
    }
  }()

  // Watching for configurations
  konfig.Watch(
    &config,
    []chan konfig.Update{ch},
    konfig.WatchInterval(2*time.Second),
  )

  // Sending requests to server
  logger.InfoKV("message", "start sending requests ...")

  client := &http.Client{
    Timeout:   5 * time.Second,
    Transport: &http.Transport{},
  }

  ticker := time.NewTicker(time.Second)
  defer ticker.Stop()

  for range ticker.C {
    req, err := http.NewRequest("GET", url, nil)
    if err != nil {
      logger.ErrorKV("error", err)
      continue
    }

    resp, err := client.Do(req)
    if err != nil {
      logger.ErrorKV("error", err)
      continue
    }

    logger.InfoKV("message", "response received from server", "http.statusCode", resp.StatusCode)
  }
}
```

This is the `Dockerfile` we use for containerizing our server application:

```dockerfile
FROM golang:1.13-alpine as builder
RUN apk add --no-cache git
WORKDIR /repo
COPY . .
RUN go build

FROM alpine:3.11
COPY --from=builder /repo/client /usr/local/bin/
RUN chown -R nobody:nogroup /usr/local/bin/client
USER nobody
CMD [ "client" ]
```

And, these are the resources that we deploy to our Kubernetes cluster:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-client
  labels:
    name: app-client
data:
  log-level: "warn"
  server-address: "http://app-server:8080"
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-client
  labels:
    name: app-client
spec:
  replicas: 2
  selector:
    matchLabels:
      name: app-client
  template:
    metadata:
      labels:
        name: app-client
    spec:
      restartPolicy: Always
      containers:
        - name: client
          image: moorara/app-client:latest
          imagePullPolicy: Always
          command: [ "client" ]
          env:
            - name: LOG_LEVEL_FILE
              value: /configs/client/log-level
            - name: SERVER_ADDRESS_FILE
              value: /configs/client/server-address
          volumeMounts:
            - name: app-client
              mountPath: /configs/client
              readOnly: true
      volumes:
        - name: app-client
          configMap:
            name: app-client
            defaultMode: 420
```

Finally, we use this `Makefile` for easily running our commands:

```makefile
build:
  go build

docker:
  docker image build --tag moorara/app-client:latest .
  docker image push moorara/app-client:latest

k8s-deploy:
  kubectl create -f kubernetes.yaml

k8s-delete:
  kubectl delete deployment app-client
  kubectl delete configmap app-client

.PHONY: build docker k8s-deploy k8s-delete
```

### Demo

We first Dockerize our _server_ microservice and deploy it to Kubernetes:

```bash
cd server
make docker k8s-deploy
```

We then Dockerize our _client_ microservice and deploy it to Kubernetes:

```bash
cd client
make docker k8s-deploy
```

Now, we should have 2 pods up and running for each microservice (server and client).
Using a handly tool called [Stern](https://github.com/wercker/stern), we tail all logs from _server_ pods.

```bash
stern app-server
app-server-588c8db995-kgwgh server {"level":"info","logger":"server","message":"starting http server ...","timestamp":"2019-09-02T20:42:03.0653369Z"}
app-server-588c8db995-t7mw4 server {"level":"info","logger":"server","message":"starting http server ...","timestamp":"2019-09-02T20:42:03.8942075Z"}
```

Similarly, we tail all logs from _client_ pods.

```bash
stern app-client
app-client-599ff8bf8f-7mtlr client {"level":"info","logger":"client","message":"start sending requests ...","timestamp":"2019-09-02T20:46:37.8604542Z"}
app-client-599ff8bf8f-cvsss client {"level":"info","logger":"client","message":"start sending requests ...","timestamp":"2019-09-02T20:46:38.6870928Z"}
```

The initial logs in _info_ level are logged before the _warn_ is read from mounted configuration file and the logger is updated with _warn_ level.
While the client pods are making requests to server pods, we see no other logs from any of the pod.

Now, it is time to see dynamic configuration management in action!
Using the `kubectl edit cm app-server` we change the `log-level` to `info`.
Similarly, using the `kubectl edit cm app-client` we change the `log-level` to `info`.

After a few seconds, Kubernetes will update the mounted files with new values,
and we should start seeing logs from _server_ and _client_ pods.
Logs from _server_ pods are similar to these ones:

```bash
app-server-588c8db995-t7mw4 server {"level":"info","logger":"server","message":"new request received","timestamp":"2019-09-02T20:59:20.793411Z"}
app-server-588c8db995-kgwgh server {"level":"info","logger":"server","message":"new request received","timestamp":"2019-09-02T20:59:20.967802Z"}
app-server-588c8db995-t7mw4 server {"level":"info","logger":"server","message":"new request received","timestamp":"2019-09-02T20:59:21.7932503Z"}
app-server-588c8db995-kgwgh server {"level":"info","logger":"server","message":"new request received","timestamp":"2019-09-02T20:59:21.9667149Z"}
```

And logs from _client_ pods are similar to these ones:

```bash
app-client-599ff8bf8f-cvsss client {"level":"info","logger":"client","message":"response received from server","http.statusCode":200,"timestamp":"2019-09-02T20:59:50.7583619Z"}
app-client-599ff8bf8f-7mtlr client {"level":"info","logger":"client","message":"response received from server","http.statusCode":200,"timestamp":"2019-09-02T20:59:50.9315373Z"}
app-client-599ff8bf8f-cvsss client {"level":"info","logger":"client","message":"response received from server","http.statusCode":200,"timestamp":"2019-09-02T20:59:51.7572924Z"}
app-client-599ff8bf8f-7mtlr client {"level":"info","logger":"client","message":"response received from server","http.statusCode":200,"timestamp":"2019-09-02T20:59:51.9335878Z"}
```

## Conclusion

Dynamic configuration management and secret injection refer to updating an application with new configurations and secrets without disrupting (restarting) it.
This is an important quality for building a non-disruptive and autonomous application.
With containerization technologies like Docker and Kubernetes, it is easy to inject new configurations and secret into your application environment (container).
[konfig](https://github.com/moorara/konfig) is a very minimal and unopinionated library
that makes dynamic configuration management and secret injection very easy to implement and use for Go application.
