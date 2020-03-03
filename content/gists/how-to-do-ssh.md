---
title: "How Uber, Facebook, and Netflix Do SSH"
date: 2019-08-08T16:00:00-04:00
draft: false
toc: false
tags:
  - ssh
  - security
  - google
  - uber
  - netflix
  - facebook
---

## TL;DR

  - A study shows there is a cybersecurity attack every _39_ seconds.
  - In a typical SSH protocol:
  - the server trusts the client if the client's public key is listed as authorized,
  - and the client trusts the server's public key on first use (TOFU).
  - The _trust on first use_ (TOFU) approach delegates the trust to the clients and leave them _vulnerable to man-in-the-middle attacks_.
  - One solution to fix this is using SSH certificates and SSH certificate authorities (CA).
  - Many companies take _Zero-Trust_ approach.
  - [BeyondCorp](https://cloud.google.com/beyondcorp) is Google's Zero-Trust model that does NOT use a VPN.
  - Uber uses the _Uber SSH Certificate Authority_ (USSHCA) along with a _pam module_ for continued validity of a user.
  - Facebook has implemented its own SSH servers to trust based on certificate authorities (CA).
  - Certificates issued by CA includes all permissions and privileges for each user.
  - Netflix uses _Bastion’s Lambda Ephemeral SSH Service_ (BLESS) certificate authority.
  - BLESS runs on AWS Lambda and uses _AWS Key Management Service_ (KMS).
  - Netflix’s SSH bastion uses SSO to authenticate users and issuing short-lived certificates.
  - [Teleport](https://gravitational.com/teleport) provides _role-based access control_ using existing SSH protocol.

## READ MORE

  - [How Uber, Facebook, and Netflix Do SSH](https://gravitational.com/blog/how_uber_netflix_facebook_do_ssh)
  - [Introducing the Uber SSH Certificate Authority](https://medium.com/uber-security-privacy/introducing-the-uber-ssh-certificate-authority-4f840839c5cc)
  - [Hackers Attack Every 39 Seconds](https://www.securitymagazine.com/articles/87787-hackers-attack-every-39-seconds)
