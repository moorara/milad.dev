[![Build Status][netlify-image]][netlify-url]

# milad.dev

This is a [Hugo](https://gohugo.io) site for my personal tech and dev blog.

## Getting Started

You can run Hugo server locally as follows:

```
hugo server -D
```

Or, you can run it using Docker:

```
make docker
docker-compose up -d
```

## Netlify

This static site is deployed using [Netlify](https://www.netlify.com).

### Configure Custom Domain

For getting a Netlify site working with a custom domain, there are two options.
For an in-depth explanation of these options, you can read this [guide](https://www.netlify.com/docs/custom-domains).

#### Using Netlify DNS Provider

  1. Add your domain to Netlify DNS.
  1. Change the **nameservers** of your domain in your custom DNS provider to the ones assigned by Netlify to your new DNS zone.
  1. You can also add other DNS records such as **MX** to your DNS records.

#### Using Custom DNS Provider

If you add a **root domain** and a **www domain**, you need to add two records to your DNS provider.
If you add a **non-www subdomain**, then you only need to add one record to your DNS provider.

  * For **non-www subdomain**:
    - Add a **CNAME** record pointing to Netlify site.
  * For **root domain** and **www subdomain**:
    - Add a **CNAME** record for **www subdomain** pointing to Netlify site.
    - For **root domain**:
       - If your DNS provider supports **CNAME flattening**, **ANAME** or **ALIAS** records, add such a record pointing to Netlify site.
       - If your DNS provider does not support any of *CNAME flattening*, *ANAME* or *ALIAS* records, add an **A record** pointing to Netlify load balancer IP address (`104.198.14.52`).

### Guides

  - https://www.netlify.com/docs/custom-domains
  - https://www.netlify.com/docs/ssl
  - https://www.netlify.com/docs/redirects
  - https://www.netlify.com/docs/functions
  - https://www.netlify.com/blog/2017/02/28/to-www-or-not-www


[netlify-url]: https://app.netlify.com/sites/milad-dev/deploys
[netlify-image]: https://api.netlify.com/api/v1/badges/0f187c64-3e52-4927-9cb0-d210bdc9368a/deploy-status
