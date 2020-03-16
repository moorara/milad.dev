---
title: "Stream Processing"
date: 2020-03-15T20:00:00-04:00
draft: false
toc: false
tags:
  - big-data
  - stream-processing
  - microservices
  - kafka
  - ksql
---

## TL;DR

  - Stream Processing is a big data paradigm.
  - In Batch Processing,
    - We need to have all data stored ahead of time.
    - We process data in batches.
    - We aggregate the results across all batches at the end.
    - Batch processing tries to process all the data at once.
  - In Stream Processing,
    - Data come as a never-ending continuous stream of **events**.
    - Stream processing naturally fits with **time series** data.
    - Data are processed in **real-time** and we can respond to the events faster.
    - Stream processing distributes the processing over time.
  - You can use stream processing when:
    - When the data is huge and cannot be stored, stream processing is the only solution.
    - Stream processing works when processing can be done with a single pass over the data or has temporal locality.
    - Stream processing fits into use-cases where approximate results are sufficient.
  - You should not use stream processing when:
    - Processing needs multiple passes through full data.
    - Processing needs to have random access to data.
    - Examples: _training machine learning models_, etc.
  - When doing stream processing using a _message broker_:
    - We use a message broker system (_Kafka_, _NATS_, _RabbitMQ_, etc.).
    - We create applications and write code to receive messages, do some calculations, and publish back results (_actors_).
  - When using a _stream processing_ framework (_Flink_, _Kafka Streams_, etc.):
    - We only write the logic for actors.
    - We connect the actors and data streams.
  - A stream processor will take care of the hard work (_collecting data_, _running actors in the right order_, _collecting results_, _scaling_, and so on).
  - **Streaming SQL** allows users to write SQL-like statements to query streaming data.
  - We can define **windows** for streams. A window is a _working memory_ on top of a stream.
  - The most common types of streaming windows:
    - **Sliding Length Window** Keeps last N events and triggers for each new event.
    - **Batch Length Window** Keeps last N events and triggers once for every N event.
    - **Sliding Time Window** Keeps events triggered at last N time units and triggers for each new event.
    - **Batch Time Window** Keeps events triggered at last N time units and triggers once for the time period in the end.

## Read More

  - [A Gentle Introduction to Stream Processing](https://medium.com/stream-processing/what-is-stream-processing-1eadfca11b97)
  - [Stream Processing 101: A Deep Look at Operators](https://medium.com/stream-processing/stream-processing-101-from-sql-to-streaming-sql-44d299cf38aa)
  - [The Data Dichotomy: Rethinking the Way We Treat Data and Services](https://www.confluent.io/blog/data-dichotomy-rethinking-the-way-we-treat-data-and-services)
  - [Build Services on a Backbone of Events](https://www.confluent.io/blog/build-services-backbone-events)
  - [Using Apache Kafka as a Scalable, Event-Driven Backbone for Service Architectures](https://www.confluent.io/blog/apache-kafka-for-service-architectures)
  - [Chain Services with Exactly-Once Guarantees](https://www.confluent.io/blog/chain-services-exactly-guarantees)
  - [Messaging as the Single Source of Truth](https://www.confluent.io/blog/messaging-single-source-truth)
  - [Leveraging the Power of a Database Unbundled](https://www.confluent.io/blog/leveraging-power-database-unbundled)
  - [Building a Microservices Ecosystem with Kafka Streams and KSQL](https://www.confluent.io/blog/building-a-microservices-ecosystem-with-kafka-streams-and-ksql)
  - [Toward a Functional Programming Analogy for Microservices](https://www.confluent.io/blog/toward-functional-programming-analogy-microservices)
