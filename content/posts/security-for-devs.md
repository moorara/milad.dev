---
title: "Security For Developers"
date: 2020-03-12T20:00:00-04:00
draft: false
toc: true
tags:
  - dev
  - security
  - owasp
---

Recently during an interview, I was asked a question about how much I know about security.
At first, I paused for a few seconds because honestly, I didn't know how to answer the question.
Eventually, I answered as a developer I am making sure I am doing this, doing that, and following these best practices!
After my interview, I was telling myself that I should know about the security best practices for developers and engineers.
When I am working on something, I should have a set of principles, guidelines, and considerations on my mind and follow them.
As a result, I decided to do a little bit of research and prepare a cheatsheet!

## Security by Design Principles

### Minimize Attack Surface Area

Every new feature added to an application increases the overall risk to the application by providing more opportunities for attackers.

Make sure you:

  - Build the minimum required set of features.
  - Expose the minimum amount of data needed.
  - Restrict access to the minimum number of users.

### Establish Secure Defaults

An application must be _secure_ and _safe_ by default.
For delivering an _out of the box_ experience, the default settings should be secure.
Users may be allowed to turn off some of the security requirements, but by default, a high-level security level is enabled.

### Principle of Least Privilege

The Principle of Least Privilege (POLP) requires a user to have the minimum required permissions to perform a given task.
This includes every aspect from application-specific permissions to processor, memory, network, and other permissions.

### Principle of Defend in Depth

The principle of defense in depth states layered security mechanisms improve the security of the system as a whole.
If one layer fails to defend against an attack, hopefully, other layers will protect the system or at least mitigate the consequences.

### Fail Securely

An application must securely handle errors and unexpected issues.

There are three possible outcomes from a security measure:

  - Allowing the operation
  - Disallowing the operation
  - Error/Exception/Failure

In case of an _error, exception, or failure_ the security measure should follow the same execution path as _disallowing the operation_.
An error, exception, or failure should not leave the system in an unsecured state or enable an operation that is not supposed to be allowed.

Errors or exceptions related to application and business logic should follow a secure execution path.
For example, they should not cause a security check not to be performed or be performed with bad values.

Last but not least, Failures should not provide users with additional privileges or sensitive information.

### Do NOT Trust Services

Never trust external services from a security perspective.
Validate, verify, and secure all data and information returned from a service provider.

### Separation of Duties

Separation of duties of segregation of duties is about have more than one entity to complete a task.
Separation of duties increases protection from fraud and errors.
The entity that approves a task should be separate from the entity that performs the task and they should be both different from the entity that verifies the task.

### Avoid Security by Obscurity

Security through obscurity is relying on _secrecy_ in design and implementation for achieving security.
NEVER rely upon _security by obscurity_ as a means for securing a system.
There should be enough security controls in place to keep an application safe without needing to hide the architecture, functionality, or source code.

### Keep Security Simple

Avoid using complicated security controls and sophisticated architectures for securing applications.
Complex mechanisms can increase the _attack surface area_ and the security risk.

### Fix Security Issues Correctly

Once a security vulnerability is found, it is important to develop tests for it and understand the _root cause_ of it properly.
It is also very important to make sure that all instances of a given security issue is fixed across the entire application.

## Common Security Vulnerabilities

### Buffer Overflow

Buffer overflow is a class of exploit in which a program writes some data to a buffer more than it can hold.
A buffer is a continuous block of memory and when overflowed, the excessive data will be written into other parts of memory.
The attacker can cause the program to crash or execute malicious code.

Buffer overflow attacks come in different forms. **Stack-based** and **Heap-based** buffer overflows are the most well-known.
C and C++ are more vulnerable to this exploit as they don't have any built-in protection against accessing or overwriting out-of-bound data in memory.

You can read more about this vulnerability here:

  - https://owasp.org/www-community/vulnerabilities/Buffer_Overflow
  - https://www.cloudflare.com/learning/security/threats/buffer-overflow

## Common Security Attacks

### Query Injection

Query injection is a code injection attack and the most common type of it is _SQL injection_.
The attacker crafts a special query and sends it to the server through an entry field.
The user-provided input changes the behavior of the query being executed on the server-side.
The attacker can retrieve, manipulate, or destroy unauthorized data as well as execute admin operations on the database.

You can protect your application against this attack by:

  - **Sanitizing** and **validating** any user input.
  - Using **prepared statements** for parameterized queries.
  - **Escaping** all user-provided data.
  - Enforce the principle of **least privilege** for executing the queries.

You can read more about this attack here:

  - https://owasp.org/www-community/attacks/SQL_Injection
  - https://www.cloudflare.com/learning/security/threats/sql-injection

### Cross-Site Scripting (XSS)

Cross-Site Scripting (XSS) attacks belong to _code injection_ category of attacks.

  1. The attacker uses an _exploit_ in a trust web application and embed malicious code into it.
  1. The victim runs the malicious code in her browser by visiting the trusted website.
  1. The malicious code steals sensitive information such as _cookies_ and send them to a destination controlled by the attacker.

This attack usually comes in a few different forms

  - **Persistent XSS**
    - The malicious code/script gets stored permanently in the trusted website's database.
  - **Reflected XSS**
    - The malicious code/script comes from the request that the victim sent.

To prevent from XSS attack:

  - **Sanitize**, **validates**, and **verifies** every user input both on server-side and client-side.

You can read more about this attack here:

  - https://excess-xss.com
  - https://owasp.org/www-community/attacks/xss
  - https://www.cloudflare.com/learning/security/threats/cross-site-scripting

### Cross-Site Request Forgery (CSRF)

Cross-Site Request Forgery (CSRF) works by tricking a user into invoking a request from a web application that the user is already authenticated with.
This request is usually a **state-changing request** as opposed to stealing data.
The attacker cannot see the response to the forged request.
An example of this attack could be tricking a user into making a request from her bank's website to transfer some funds to the attacker with the help of some **social engineering**.

Here are the steps:

  1. The attacker forges a request.
  1. The attacker embeds the forged request on a website, email, etc.
  1. The victim unwittingly triggers the forged request.
  1. The target web application receives the request and fulfill it as a legitimate request made by the authenticated user.

CSRF attacks are hard to be completely prevented due to their nature.
Different HTTP verbs are handled differently by browsers, thus they have different levels of vulnerabilities to CSRF attacks.
As a result, each HTTP verb requires a different kind of protection strategy against the CSRF attack.

You can read more about this attack and its mitigation solutions here:

  - https://owasp.org/www-community/attacks/csrf
  - https://www.cloudflare.com/learning/security/threats/cross-site-request-forgery

## Read More

  - [Security by Design Principles](https://www.owasp.org/index.php/Security_by_Design_Principles)
  - [Vulnerabilities](https://owasp.org/www-community/vulnerabilities)
  - [Attacks](https://owasp.org/www-community/attacks)
  - [Web Application Security](https://www.cloudflare.com/learning/security/what-is-web-application-security)
  - [Identity and Access Management (IAM)](https://www.cloudflare.com/learning/access-management/what-is-identity-and-access-management)
