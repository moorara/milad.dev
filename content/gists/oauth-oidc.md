---
title: "OAuth 2.0 and OpenID Connect"
date: 2020-03-26T20:00:00-04:00
draft: false
toc: false
tags:
  - web
  - security
  - authentication
  - authorization
  - oauth
  - oidc
  - jwt
  - pkce
---

## TL;DR

  - **OAuth 2.0**
    - OAuth 2.0 is used for **authorization**.
    - Terminology:
      - Roles:
        - **Client**: the application that wants to access the data.
          - _Confidential Clients_: the clients with the ability to maintain the confidentiality of the _client_secret_.
          - _Public Clients_: the clients that cannot maintain the confidentiality of the _client_secret_.
        - **Resource Owner**: the user who owns the data.
        - **Resource Server**: the system that authorizes access to the data.
        - **Authorization Server**: the system which has the data that the client wants to access.
      - Configurations:
        - **Redirect URI**
        - **Response Type**
        - **Scope**
      - Endpoints:
        - **Authorization Endpoint**
        - **Token Endpoint**
        - *Resource Endpoint*
      - Tokens:
        - **Access Token**: the token that is used when making authenticated API requests.
        - **Refresh Token**: the token that is used to get a new _access token_ when the access token expires.
      - Channels:
        - **Back Channel** (highly secure communication channel)
        - **Front Channel** (less secure communication channel)
    - **Authorization Grant** Flows:
      - **Authorization Code** (front channel + back channel)
        - Use-Case: applications with back-end and front-end
      - **Implicit** (front channel only)
        - Use-Case: _Sinlge-Page App_ (no backend)
      - **Resource Owner Password Credentials** (back channel only)
        - Use-Case: _Legacy_
      - **Client Credentials** (back channel only)
        - Use-Case: _Service to Service_ Communication (backend-only)
  - **OpenID Connect**
    - OpenID Connect (OIDC) is used for **authentication**.
    - _OIDC_ is an extension on top of _OAuth_ for authentication use-caes.
    - Additions:
      - **ID Token**: a token that has some of the user's information.
      - **User Endpoint**: the endpoint for getting more information about the user.
      - *Standard Scopes*
      - *etc.*
  - **JWT**
    - _JSON Web Token_ (JWT) is an open standard for encoding and transmitting information.
    - JWT is a common format for OAuth 2.0 and OIDC tokens.
    - Anatomy:
      - `base64(header).base64(payload).<signature>`
        - **Header**
          - *Type*: `JWT`
          - *Signing Algorithm*: `HS256`, `RSA`
        - **Payload**
          - *Registered Claims*
          - *Public Claims*
          - *Private Claims*
        - **Signature**
          - `signing_algorithm(base64(header) + "." + base64(payload), secret)`
    - Extensions:
      - **JWK** (JSON Web Key): a JSON object that represents a cryptographic key.
      - **JWKS** (JSON Web Key Set): a set of keys which contains the public keys for verifying an issued JWT.
  - **PKCE**
    - _Proof Key for Code Exchange_ is an extension to _authorization code flow_ for mobile apps to mitigate the risk of having the authorization code intercepted.
  - Tools:
    - https://jwt.io
    - https://oauthdebugger.com
    - https://oidcdebugger.com

## Read More

  - [OAuth 2.0 and OpenID Connect in Plain English](https://www.youtube.com/watch?v=996OiexHze0)
  - [An Illustrated Guide to OAuth and OpenID Connect](https://developer.okta.com/blog/2019/10/21/illustrated-guide-to-oauth-and-oidc)
  - [The OAuth 2.0 Authorization Framework](https://tools.ietf.org/html/rfc6749)
  - [OpenID Connect Core 1.0](https://openid.net/specs/openid-connect-core-1_0.html)
  - [OpenID Connect Discovery 1.0](https://openid.net/specs/openid-connect-discovery-1_0.html)
  - [OpenID Connect Dynamic Client Registration 1.0](https://openid.net/specs/openid-connect-registration-1_0.html)
  - [JSON Web Token (JWT)](https://tools.ietf.org/html/rfc7519)
  - [JSON Web Key (JWK)](https://tools.ietf.org/html/rfc7517)
