---
title: "A Comparison of GitHub Marketplace Apps"
date: 2019-06-02T11:13:06-04:00
draft: false
toc: true
images:
tags:
  - dev
  - coding
  - github
  - automation
  - monitoring
  - microservices
  - continuous-integration
  - continuous-delivery
  - code-coverage
  - code-testing
  - documentation
---

I have been using and evaluating dozens of [GitHub Marketplace Apps](https://github.com/marketplace) for a few months now
for a real-world microservices application built in [Go](https://golang.org).
So, I decided to share what I liked and what I didn't like about these integrations.

The nice thing about using GitHub Marketplace is that your integrations and billing are all consolidated in one place.
As an organization or a billing manager, it is much easier to manage all these different services from a single hub.

## CI/CD

### GitHub Actions https://github.com/features/actions

  * **Features:**
    - Built-in automation solution for GitHub repositories
    - **HCL**-based configuration
  * **Pros:**
    - Very **simple**, highly **flexible** and so powerful
    - **Caching** Docker images based on image digests
    - **Sharing** and **reusing** actions by referencing them directly from GitHub repositories
  * **Cons:**
    - Currently, it is in *beta* mode
    - UI/UX is very basic
    - Needs more work to build a full automation
    - Sharing files between actions does not have built-in support

### CircleCI https://circleci.com

  * **Features:**
    - Managed/SaaS platform for continuous integration and continuous delivery
    - **YAML**-based configuration
  * **Pros:**
    - Very easy-to-use documentation
    - High **performance**, **availability** and **reliability**
    - Very flexible and powerful (**caching**, remote docker engines, etc.)
    - **Workflows** with **parallel jobs**, **fan-in**, and **fan-out**
    - Powerful and fast debugging through **ssh** to build jobs
    - **Exporting artifacts** for each build job
    - **Sharing artifacts** between build jobs very efficiently and fast
    - Provides build environments using containers and/or machines (VMs)
    - Provides build environment for **OS X** applications
    - **Reusing** and **sharing** code fragments through *Orbs*
    - Slack integration for alerting on failed builds
  * **Cons:**
    - **Mono repo** builds do not have built-in support
    - External Orbs need to be packaged and published (they cannot be directly referenced from their code bases)
    - Pipelines are triggered on push to *branches* and *tags* (cannot work with other GitHub events such as *release*)

### Codefresh https://codefresh.io

  * **Features:**
    - Managed/SaaS platform for continuous integration and continuous delivery
    - **YAML**-based configuration
  * **Pros:**
    - Good documentation with examples
    - Native support for **Docker**, **Kubernetes**, and **Helm** workflows
    - Provides managed private **Docker registry** and **Helm repository**
    - Extremely **flexible** pipelines that work with all GitHub events
    - **Workflows** with **parallel steps**, **fan-in**, and **fan-out**
    - Built-in Selenium/Protractor for **automated end-to-end testing**
    - **Reusing** and **sharing** code fragments through *Steps*
    - Slack integration for alerting on failed builds
  * **Cons:**
    - No built-in environment for *OS X* applications
    - Steps/plugins need to be submitted (they cannot be directly referenced from their code bases)

### Docker Automated Builds https://cloud.docker.com

  * **Features:**
    - Managed/SaaS build and push automation for Docker images
  * **Pros:**
    - Simple and easy setup
    - Does not require any code
  * **Cons:**
    - Very **inflexible**
    - Extremely **slow**
    - Cannot do *semantic versioning*
    - Configuration is manual and through web interface

## Monitoring

### Rollbar https://rollbar.com

  * **Features:**
    - Monitoring application errors
    - **Automated alerting** on errors
    - **Real-time** insights and analytics
  * **Pros:**
    - Supports a wide range of programming languages and technologies
    - Tracks **code versions** and **deployments**
    - Improves **observability** and **visibility**
    - Helps with improving **stability**
    - Powerful configurations and features
    - **Integrations** with popular tools (**GitHub**, **Slack**, PagerDuty, Asana, etc.)
  * **Cons:**
    - Requires configuration per repo
    - Programming API is fairly *complex*
    - User management and access control need to be done separately on web UI

### Airbrake https://airbrake.io

  * **Features:**
    - Monitoring application errors
    - **Automated alerting** on errors
    - **Real-time** insights and analytics
  * **Pros:**
    - Supports a wide range of programming languages and technologies
    - Tracks **deployments**
    - Improves **observability** and **visibility**
    - Helps with improving **stability**
    - **Simple** UI, simple configuration, and simple programming API
    - Submits onboarding issues on GitHub
    - **Integrations** with other tools (**GitHub**, **Slack**, PagerDuty, Asana, etc.)
  * **Cons:**
    - Requires configuration per repo
    - User management and access control?

## Code Review

### WIP https://github.com/marketplace/wip

  * **Features:**
    - Blocks *work-in-progress* pull requests, so you cannot merge them!
  * **Pros:**
    - very simple and **zero configuration**
    - Configurable terms, title, body, labels, or commit message

### Code Climate https://codeclimate.com

  * **Features:**
    - Code coverage reports
    - Automated code review for code quality
    - Managed/SaaS
  * **Pros:**
    - Supports a wide range of programming languages
    - GitHub status for *code coverage* and *diff coverage*
    - GitHub PR checks are very clear and informative
    - Automated pull request comments for better **code quality** and readability
    - Shows covered and uncovered new lines of code in pull requests through a browser extension
    - Quantifies and measures code quality and promotes reducing **technical debt** through analytics
    - Provides code coverage and code quality **badges**
  * **Cons:**
    - **Expensive**
    - Has its own user access management
    - Most code quality comments are very basic and static, so developers may start to ignore them

### Codecov https://codecov.io

  * **Features:**
    - Code coverage reports
    - Managed/SaaS
  * **Pros:**
    - Pricing is per user
    - Provides code coverage **badge**
    - Supports organization-wide configurations for all repos
    - Supports **configuration-as-code** through a `yml` file in repo
    - Can post coverage reports as comments on pull requests
    - Reuses GitHub user permissions for user access management
  * **Cons:**
    - No code quality feature

### Coveralls https://coveralls.io

  * **Features:**
    - Code coverage reports
    - Managed/SaaS
  * **Pros:**
    - Pricing is fixed (not per repo)
    - GitHub status for *code coverage*
    - Provides code coverage **badge**
  * **Cons:**
    - Bad UI/UX
    - No code quality feature
    - *diff coverage* GitHub status is combined with *total coverage* GitHub status
    - Shows a check on `master` causing `master` branch goes red in repos with not enough coverage

### GolangCI https://golangci.com

  * **Features:**
    - Automated code review comments on pull requests
    - Pricing is per user
  * **Pros:**
    - Accurate and useful comments for Golang
    - Configuration as code
  * **Cons:**
    - Only works for Golang
    - Cannot detect bot users
    - Very basic control panel
    - Some comments can become very noisy

## Dependency Management

### Renovate https://renovatebot.com

  * **Features:**
    - Automated dependency updates
  * **Pros:**
    - Supports a wide range of programming languages and technologies
    - Almost an **out-of-box** solution (submits an onboarding pull request)
    - Highly configurable through a configuration file in the repo
    - Supports **private npm** repositories and packages
  * **Cons:**
    - Currently, cannot work with *private Go modules*
    - Can become very noisy with *mono repos*
    - For disabling the bot with GitHub *all repositories** permission approach, the configuration file needs to be kept in repo

### Dependabot https://dependabot.com

  * **Features:**
    - Automated dependency updates
  * **Pros:**
    - Configurable either via a separate web UI or a configuration file in the repo
    - Supports **security** updates
    - Supports **private Go modules**
    - Labels pull requests
  * **Cons:**
    - Requires configuration for each repo
    - Security updates are not available for *Go*
    - *Mono repos* require a fairly large deal of *manual configuration*

## Finding Vulnerabilities

### Snyk https://snyk.io

  * **Features:**
    - Finding and fixing vulnerabilities in your dependencies
  * **Pros:**
    - Free
    - Automates the process of finding **common vulnerabilities and exposures (CVE)**
  * **Cons:**
    - Currently, does not support *Go modules*
    - Supports Go only through command-line interface (not integrated with GitHub)

### WhiteSource Bolt https://bolt.whitesourcesoftware.com/github

  * **Features:**
    - Finding and fixing open source vulnerabilities
  * **Pros:**
    - Free
    - Automates the process of finding **common vulnerabilities and exposures (CVE)**
    - Supports configuration through a configuration file in the repo
  * **Cons:**
    - Currently, does not support *Go modules*

## Communication

### Slack + GitHub https://slack.github.com

  * **Features:**
    - Updates for *pull requests*, *issues*, *build checks*, etc.
    - Shows details of pull requests and issues directly on Slack
  * **Pros:**
    - FREE
    - Centralize pull requests and issues and make them visible
    - Easy configuration through `/github` command on Slack
  * **Cons:**
    - Could become very *noisy*

### Pull Reminders https://pullreminders.com

  * **Features:**
    - Sends periodic reminders for pull requests to reviewers
  * **Pros:**
    - Helps with prioritizing pull requests and reduce **lead time**
    - Flexible configurations for GitHub repos, GitHub teams, and Slack channels
  * **Cons:**
    - Needs configuration on its own website
    - Can become chatty and cause people to ignore the reminders

## Documentation

### GitBook https://www.gitbook.com

  * **Features:**
    - Managed/SaaS
    - Centralized documentation
  * **Pros:**
    - Simple and **responsive** UI
    - Supports bi-directional integration with **GitHub**
    - Non-technical people can use the **WYSIWYG** interface
    - Documentation can be searched from **Slack**
  * **Cons:**
    - Billing is not through GitHub

## Work Management

### ZenHub https://www.zenhub.com

  * **Features:**
    - Kanban-style project management
    - **Customizable** workflows
  * **Pros:**
    - Automated workflow with GitHub **pull requests** and **issues**
    - The UI can be viewed on GitHub via a **browser extension**
    - Provides **analytics and metrics** (velocity, burndown, etc.)
    - Can have workspace per repo or a workspace with multiple repos
    - Integration with **Slack**
  * **Cons:**
    - Cannot delete a workspace once created
    - Modifies the GitHub interface and experience

### Zube https://zube.io

  * **Features:**
    - Kanban-style project management
    - **Customizable** workflows
  * **Pros:**
    - Automated workflow with GitHub **pull requests** and **issues**
    - Provides **analytics and metrics** (velocity, burndown, etc.)
    - Integration with **Slack**
  * **Cons:**
    - The UI is not accessible on GitHub

## Analytics
