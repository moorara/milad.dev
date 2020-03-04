---
title: "Dynamic Configuration Management and Secret Injection with konfig"
date: 2020-03-04T15:00:00-04:00
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
  1. Initially, the microservices are configured to only show `warn` level logs, so we won't see any log.
  1. Then, we will update the `log-level` key in _ConfigMaps_ for server and client to `debug`.
  1. Without restarting the pods, we will see logs from server and client pods in `debug` level after a little while.

### Source Codes

You can find all the required source codes [here](https://github.com/moorara/konfig/tree/master/examples/3-kubernetes).

### Demo

First, we build and push Docker images for the server and client microservices.
Second, we deploy them to the Kubernetes cluster.

```bash
# current directory: examples/3-kubernetes
cd server
make docker k8s-deploy
cd ../client
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

The initial logs in _info_ level are logged before the _warn_ is read from the mounted configuration file and then the logger is updated with _warn_ level.
While the client pods are making requests to server pods, we see no other logs from any of the pods.

Now, it is time to see dynamic configuration management in action!
Using the `kubectl edit cm app-server` we change the `log-level` to `info`.
Similarly, using the `kubectl edit cm app-client` we change the `log-level` to `info`.

After a few seconds, Kubernetes will update the mounted files with the new values, and we will see logs from _server_ and _client_ pods.
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
With containerization technologies like Docker and Kubernetes, it is easy to inject new configurations and secrets into your application environment (container).
[konfig](https://github.com/moorara/konfig) is a very minimal and unopinionated library
that makes dynamic configuration management and secret injection very easy to implement and use for Go application.
