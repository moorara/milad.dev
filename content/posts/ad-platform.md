---
title: "What is an Ad Platform Made of?"
date: 2020-07-06T15:00:00-04:00
draft: true
toc: true
tags:
  - ad
  - ads
  - product
  - platform
  - marketing
  - advertising
  - targeting
  - tracking
---

![Ads Marketplace](/images/ads-marketplace.png)

Ad placement is a [multi-objective optimization](https://en.wikipedia.org/wiki/Multi-objective_optimization) (MOO) problem.
There are many factors that needed to be taken into account and be optimized:

  - Relevancy
  - Advertiser Value
  - User Value
  - User Experiencce
  - Retention
  - Fairness
  - Basket Size
  - and more ...

## The Marketing Funnel

```
          ___________________________
          \        Awareness        /
           \-----------------------/
            \    Consideration    /
             \-------------------/
              \   Conversion    /
               \   Loyalty     /
                \  Advocacy   /
                 \___________/
```

## Glossary

| Term | Description |
|------|-------------|
| **Marketing** | The set of activities to attract people to products or services. |
| **Promotion** | Promotions are one kind of marketing to encourage conversion. |
| **Ads** | Advertising or Ads are another kind of marketing. |
| **Surface** | A medium or place for showing ads. |
| **Inventory** | The ad slots being offered to advertiser. |
| **Impression** | Impression is defined as the ad being in the viewport for a period of time. |
| **Conversion** | An action that is valuable to business (i.e. purchase, call). |
| **RTB** | Real-time bidding is the process of offering ad slots to advertisers through an online auction. |
| **Goal** | The goal that the ad tries to achieve. |
| **Targeting** | The group of users who are eligible for the add. |
| **Copy** | The text of the add. |
| **Creative** | The visual component of the add (i.e. image, video). |
| **Campaign** | A unit of advertising that includes a goal, targeting, budget, and the set of copies and creatives. |

## Actors

| Term | Description |
|------|-------------|
| **Advertiser** | Provides demand, may work via third-party agencies, generate revenue in the ads marketplace. |
| **Publisher** | Provides supply through surfaces for displaying ads. |
| **Exchange** | Matches ads demand with ads supply, acts as a mediator between publishers and advertisers, and provides value-added services (i.e. analytics). |
| **Demand-Side Platform (DSP)** | Bids on one or more exchanges on behalf of advertisers. Can also prevent partner advertisers from competing with each other. |
| **Supply-Side Platform (SSP)** | Offers ads inventory to one or more exchanges on behalf of publishers. |

## Ad Stack

  - Campaign Management
  - Analytics and Insights
  - Ad Exchange
  - Budget and Pacing
  - Ad Ranking/Pricing
  - Billing
  - Forecasting
  - Fraud Detection
  - Ad Rendering
  - ...

## Ad Exchange Operations

Ad Exchange will provide a marketplace for advertisers and publishers.
It matches supply with demand in real-time by maximizing ROI for advertisers and minimizing the impact on user experience.

### Auction

  - Every time an ad surface is available, a request is sent to the exchange, possibly through an SSP, to display an ad.
  - Depending on the surface and audience (viewing users), a subset of ads will be eligible for display.
  - The exchange will determine the best ad to be placed on the surface.
    - The definition of best depends on a variety of factors (bid price, relevancy, platform value, quality core, etc.).
  - The exchange may pay the publisher by specifying the conditions for compensation and price.
    - Intermediaries (DSP, SSP, exchange, etc.) will each receive a cut for their role in the marketplace.

#### Auction Theory

  - **First-Price Auction**
    - All bidders simultaneously submit sealed bids.
    - The highest bidder pays the price that was submitted.
  - **Second-Price (Vickery) Auction**
    - Bidders submit sealed bids without knowing about others' bid.
    - The highest bidder wins but the price paid is the second-highest bid (plus 1 cent).
    - This model incentivize bidders to bid their true value.

### Ad Ranking/Pricing

  - When there are multiple ad slots available, we need to decide what ad appears in each slot.
    - We assign a rank no. (position) to each ad.
  - This decision can be made based on variety of factors:
    - Bid price
    - Ad relevancy (**Relevance Score**)
    - Ad quality (**Quality Score**)
    - ...
  - The rank can be used to decide the billing price for that rank position.

### Compensation

| Method | Description |
|--------|-------------|
| **Fixed Price** | The advertiser pays a fixed amount for a certain no. of placements or over a period of time. Using this method, there may be no auction. |
| **Cost Per Thousand Impressions (CPM)** | The advertiser pays for each impression regardless of if the user takes any action or not. |
| **Cost Per Click (CPC)** | The advertiser pays each time a user clicks on the add. This is the most common method. |
| **Cost Per View (CPV)** | The advertiser pays each time a user views the ad video. Viewing can be defined as watching for 10 seconds or more for example. |
| **Cost Per Action (CPA)** | The advertiser pays each time a user performs an action of interest (purchasing, installing an app, etc.). |
| **Cost Per Engagement (CPE)** | The advertiser pays for each user engagement (like, retweet, etc.). |

## Demand-Side Platform (DSP) Operations

### Audience Targeting

Advertisers can reach out to different _segments_ of users by specifying various targeting criteria:.
Tagerting capabilities usually include the following:

  - Location Targeting
  - Demographic Targeting:
  - Behavioral Targeting
  - Contextual Targeting
  - Retargeting

### Pacing

  - We can think of pacing in various ways:
    - Pacing defines how ads should deliver over the schedule of the campaign.
    - Pacing controls how a campaign spends its budget. It helps the budget to meet the goals of **bidding strategy** and vice versa.
    - Pacing defines the goals of a campaign so that the campaign hits a desired metric over the course of its lifetime.
    - **Ad Delivery Curve** is defined by pacing and sets the goals of the campaign (hourly goals, daily goals, etc.).
  - Pacing is needed for constraints such as dayparting, blackouts periods, holidays, etc.
  - **Budget Pacing** is required to prevent campaign underdelivery and overdelivery.
    - **Campaign Underdelivery**
      - Loss of money (unused budget)
      - Loss of money (advertisers may reduce ad spend)
    - **Campaign Overdelivery**
      - Dilutes cost metrics (CPM, CPC, ...)
      - Loss of money (advertisers get free credit and may reduce ad spend)
      - Loss of money (ads that overdeliver prevent other ads from delivering)
  - Pacing (Ad Delivery Curve) can be:
    - Naive: based on an arbitrary distribution (i.e. uniform distribution).
    - **Traffic-aware**: historical traffic distribution defines the ad delivery curve.
    - Custom: advertiser defines the goals.
  - For pacing to work and staying on ad delivery curve, there are different approaches:
    - Greedy: spend the budget as fast as possible while the goal is not met.
    - ε-Greedy: optimizes greedy approach by dropping an ad with probability ε.
    - **Model-based**: _PID Controller_, _Model predictive control_, etc.
  - There are two approaches for tracking ongoing delivery and correcting it:
    - Proactively (biased for underdelivery): assign quota up front and serve ad if it has not run out of quota.
    - Reactively (biased for overdelivery): count delivery via events and throttle once threshold is met (goal is met).

## User Tracking

Advertisers want to track their customer journeys and re-engage with them.

| Method | Description |
|--------|-------------|
| **Pixel** | Ad exchanges rely on long-lived cookies to be present. Publishers can embed a snippet of code from the exchanges to track users. |
| **Session Token** | A session token stored in the session cookie can be leveraged to track users across a single session on the publisher's surface. |
| **Mobile App** | Mobile apps leverage either signed-in users or device unique identifiers. |

Marketing pixels or tracking pixels are tiny snippets of code to gather information about visitors on a website.
They can be used for targeting users, measuring a marketing campaign's performance, track conversions, and build a targeted audience base.
_Retargeting Pixels_ are used for tracking user behavior to tailor ads that they are interested in.
_Conversion Pixels_ are used for tracking sales to identify the source of conversions and measure the success or failure of ad campaigns.

## Analytics

### Performance Metrics

| Metric | Description |
|--------|-------------|
| **Ad Spend** | Amount of money spent on an ad campaign. |
| **CPM, CPC, CPV, CPA, CPE** | Described above. |
| **Click Through Rate (CTR)** | The ratio of impressions that result in a click. |
| **Return On Ad Spend (ROAS)** | The attributed value of sales over the cost of the advertising used for selling. |
| **Conversion Rate** | The ration of impressions that result in a sale. |

### Attribution

Marketing attribution is the practice of determining which marketing channels and advertisements are contributing to sales or conversions.

| Model | Description |
|--------|-------------|
| **First-Touch** | Attributes the conversion to the first ad that the user has interacted with it. |
| **Last-Touch** | Attributes the conversion to the last ad that the user has interacted with it. |
| **Multi-Touch** | Attributes the conversion equally to all ads that the user has interacted with them. |
| **Weighted Multi-Touch** | Attributes the conversion differently to the ads based on how the user has interacted with each of them. |

If multiple ads were involved in the customer journey,
each may take 100% credit for the sale which results in an attributed value greater than the value of the sale.

## Reading More

  - [Google Ads Glossary](https://support.google.com/google-ads/topic/3121777)
  - [How does online tracking actually work?](https://robertheaton.com/2017/11/20/how-does-online-tracking-actually-work)
  - [Dayparting](https://en.wikipedia.org/wiki/dayparting)
  - [Vickrey Auction](https://en.wikipedia.org/wiki/Vickrey_auction)
  - [Vickrey–Clarke–Groves Auction](https://en.wikipedia.org/wiki/Vickrey-Clarke-Groves_auction)
  - [Building Advertising Platforms (Overview)](https://cloud.google.com/solutions/infrastructure-options-for-building-advertising-platforms)
  - [How to Build a Production Ad Platform](https://medium.com/@ethanyanjiali/advertising-system-architecture-how-to-build-a-production-ad-platform-1fb3e2980e92)
  - [Prebid](http://prebid.org)
