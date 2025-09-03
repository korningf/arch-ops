
# Agile Architecture - Arch-Ops



# Contents

[TOC]



# Theory



# Arch-Ops

These days the terms CloudOps (Cloud Operations), DevOps (Development Operations), 

DevSecOps (adding Security), and FinOps (Finance) are all the buzzwords du jour.

.

At the heart of these philosophies and practices are complete automation via

Infrastructure as Code (IAC), Build Factories, and CI/CD/CT Continuous Delivery.

.

In this document we will try to cover everything by splitting this vast domain.







## Agile Architectures


An agile architecture simplifies a complex stack into a cloud-agnostic abstraction.

It is portable, predictable, prescriptive, and make suse of generic re-usable patterns.

This lowers complexity, mitigates risk, and reduces adoption and maintenance time.





#  Complexity

Cloud Managment is all about amanaging complexity and change on a massive scale.

The way we manage complexity is we break it down in smaller, modular components.

We start by specfiying an abstract ontology or taxonomy for all our cloud resources.


## Ontology


Key to this is the specification of an ontology, a standard on how we name things.

The best architectures are self-describing and cane be quickly visually grokked.

.

That is we organise our clouds, resources, services, stacks into sets of hierarchies.

These abstract taxonomies are  cloud-agnostic and will map to any cloud providers.

The hierarchies have clear tiers that group things by business or technical domain.

.

We want names that increase human readability, but at the same reduce clutter.

We want to use short monikers or symbols that are unique but remain significant.

If possible, names are chosen for alphabetical ordering to express logical flows.

Each taxon tier in our taxonomy is a composite name stringing up short symbols.

.

Now for governance, regulatory comliance, and access control we want granularity.

That is we want to be able to scope and subdivide our taxons into taxonomies.


# Ontology

Occupancy (Subscriptions and AWS member accounts) should use a composite name,

made up of 5 short monikers separated by underscore with the following pattern:

```text

Occupancy
 
​   auth _  back _ core _ dist _ envt

where

   auth   regulatory authority
   back   backend infrastructure
   core   cloud tenancy
   dist   functional domain distribution
   envt   runtime environment

```


Taxonomy

Our main concern is security, which means we need a more granular approach.

Each short symbolic moniker maps in turn to a taxon which can be subdivided,

this time using a dot-separator.


```text

  aegis.authority / base.backend / core.custody / dist.domain / env.extent / func.feature 

```

FR Paris, innovation, AI Claude sandbox
   
    Occupancy:  FR_AWS_INNO_CLAUDE_SBOX

    Taxonomy:   eu.fr/aws.paris/dsp.inno/ai.claude/sbox.alpha

IE Dublin, DSP Bomi, DB Model production


    Occupancy:  IE_AWS_BOMI_MODEL_PROD
   
    Taxonomy:   eu.ie/aws.dublin/dsp.core/bomi.model/prod
  

IE Dublin, DSP Bomi, DB Model production with sharded A|B testing

    eu.ie/aws.dublin/dsp.bomi/db.model/prod.live
    eu.ie/aws.dublin/dsp.bomi/db.model/prod.blue
    eu.ie/aws.dublin/dsp.bomi/db.model/prod.green



## Architecture Tiers

* Arch    agnostic architecture (orgs, accounts, infra, storage)
* Base    base infrastructure  (vpc, networking, relays, gateways)
* Core    core deployments (data, compute, messaging, pipelines)
* Data    data pipeline
* Elas    elastic scaling



```text

```

```text
   arch
      auth        root accounts, landing zones
      locales     regions, zones
      storage     (static storage)

      orgs        root organisations   
      units       org units (org groups)
      roles       users, groups, roles, policies

      distros     subscriptions (member accounts)
      projects    business lines  (cpi, govid, bom, bcm, rem, etc)
      spaces      business partitions    (sbx, gov, dsp, pub)  
      environs    runtime environments   (dev, int, mnt, prd)


   base
      storage     distributed storage
      networks    vnets (vpc, vnet)
      subnets     zones (az)   

      wan-link    AWS Direct-Connect, AZR Express-Route
      vpn-link    AWS Private-Link, AZR Private Link            

      relays      links, gateways, vpns
      routes      routes, ingresses,
      dmzs        dmzs, nats, bastions

      peers       VPC peering
      endpoints   cross-vpc seviecs

      dns          forwarders and resolvers
      directories  AD forests
      domains      AD domains

      resources   resource groups
      services    service groups

      stacks      app stacks
      racks       placement groups

   core

      compute      serverless  (lambda functions)
      compute      clusters    (kubernetes - eks, aks)
      compute      container   (docker - ecs, aci/aca)
      compute      machines    (vms)


      tasks       workloads

  data
      database     backend      (on-premise endpoitn
      database     clustered

      middleware   queues, pubsub topics
      pipelines    transformation pipeline

   elbs
      balancers     load-balancers
      scalers       auto-scalers  

```



# Ontology

# Abstraction

IaC is all about Abstraction, generalising and grouping similar constructs together.

This reduces complexity, increases visibility and makes systems easier to understand.

It enforces homogeneity: reduces differences and give us a common model and interface.

Once we have standardised and modelled things, this in turn allows us to automate them.


# Virtualisation

Abstraction, when pushed to its limits, and applied to Computing, begets Virtualisation.

Given an abstract common model, we can virtualise Machines, Containers, Clusters, Clouds.

This is what drives IaC.


# IAC

Infrastructure-as-Code is really a misnomer - it should be infrastructure as Config.

IaC is supported by a coding language, but it is underpinned by an abstraction Model.

.

The idea is to provide a predictable, prescriptive way to deploy entire systems,

starting with cloud infrastructure, to service cluster, deployment environments,

all the way to binary distributions, dependency libraries, bundled applications

and software configurations - in short everything necessary to get it all running.



## Docker

## Kubernetes



## Stacks


Topology:

auth
- certificates
- secrets vault
- iam admins  
- rbac roles

arch
- az regions
- az topology
- hybrid dmz
- vpc endpoints

base
- dns names
- ad domains
- firewalls
- ingress rules
- egress rules

backend
- backend db
- b2c userbase

middleware
- middleware bus
- event processors
- workflow processors

core services
- stateless web app
- stateful web app

- coded functions
- container apps
- cluster apps

- data pipelines
- external services

frontend
- web frontend
- admin portal

telemetry
- metrics
- logging
- tracing



# Practice


## Factory

## Access-Control

A secure-vault using a unix password-store is used for storing secrets.

the secrets-vault is backed by SSL certs, SSH keys, and a GPG keyring.

.

## Source Code

All code lives in a git repo. 

Any will do, say github private repos and public repos for open-source.

We recommend github or any other modern git with agile integrations:

a markdown wiki, a bug tracker, pull requests and CI/CD/CT tooling. 



## CI/CD/CT Factory

A CI Factory automated Continuous Integration, Deployment or Delivery, and Testing. 


## Pipelines

The build factory simplified automation through a prescriptive standardised interface.

In an ideal world, everything is generic, prescriptive, standardised, via plugins.

.

Pipelines, in a way are a return to the past, they bring back programmatic scripting.

They complement prescription, filling the gaps where standard plugin confguration

alone cannot fully automate the process. 



# Environments and Spaces

There are different theories on what constitutes a Deployment Environment.

We have chosen a pattern that works for fast agile CI/CD/CT deployments.

.

In our system, an Environment represents a product life-cyle **maturity**.

That is, it represents a well-known stage for a particular feature-set.

This is where the Agile Factory differs from more traditional modes.

.

Whereas some people use Environments for sharded business domains, we do not.

We use **Spaces** to segregate those. Production is still Production no matter

the business domain or Space.  Integration is still Integation notwithstanding.



## Environments

The environment nomenclature has been chosen as it sorts alphabetically.

It has been our experience that human error is a major cause of failures.

This allows a quick visual grok of the maturity of deployed environments.

Crucially always sorting these helps to avoid confusion and reduces risk.

```text

    (BLD) - (local development)

     DEV  - development trunk - ongoing snapshots - in flux

     INT  - integration - feature milestone testing recipes

     MNT  - maintenance - maintenance and staging candidates

     PRD  - production - live production releases (locked)

    (TMP) - ephemeral temporary domain splitting (testing, etc)

```



## Spaces

Spaces or workspaces are functional and/or logical partitions of the business domain.

These are specialisations, that is a DEV environment may have multiple variant spaces.

These Workspaces deploy variant distributions, supra branches of code and configuration.

Spaces typically ship as distributions and use qualifiers.  Here are 2 sample spaces:


    data-api-access-1.0.0-gov-dev-latest

    data-api-access-1.0.0-dsp-dev-latest



 
## Dependencies

We want to Decouple dependencies and have clarity as to their relative maturity.

We use static analysis and a dependency management and enforcement tool chain.

This tool must be able to calculate and selectively forbid transitive dependencies.


    Dependency Enforcement:

    version             allowed transitive dependencies (may depend on)
    ================    =================================================
    foo-prd-release     *-prd-release*
    foo-mnt-staging     *-prd-release*, *-mnt-staging
    foo-int-recipe      *-prd-release*, *-mnt-staging, *-int-recipe
    foo-dev-latest      *-prd-release*, *-mnt-staging, *-int-recipe, *-dev-latest
    foo-bld-snapshot    *-prd-release*, *-mnt-staging, *-int-recipe, *-dev-latest, *-bld-snapshot (anything)



# Databases



## Data Presence

Let us use Presence (Scope) to classify databases in terms of Longevity, Velocity, Volatility.

    - static referential data  (golden-source) very slow, structural data [ex countries, currencies] 

    - stable aggregate data    (historical-data), slow, long-term permanent data [ex census, survey]

    - dynamic solicited data - (session-data)  moderate, query-based data [ex session events, queries]

    - volatile streaming data - (time-series-data) very-fast subscription-based data [ex streams, telemetry]

    - ephemeral cache data - (transient data) locally cached data for performance [ex redis, memcached]


Depending on this Presence, the choice of data pipeline and tech stack will vary.

Presence helps us determine the sort of Database population and migration tooling.

For example:

    - static "Golden-Source" referential data may only need initial population.

    - stable aggregate data may require yearly, semesterly, quartlerly, or monthly updates.

    - Dynamic user-data may require weekly updates or only be populated via a user-session.

    - volatile streaming data may require asynchronous updates, maybe via a Middleware Bus.




# Middleware

The same principles apply to any middleware, Queues or Publish / Subscribe buses.

We use pipelines to manage and evolve ETL transformations and their data sets.



 
# Cloud Infrastructure

Orchestration Cluster

    - azure cloud 
    - aws cloud
    - NET (on-premise) 

Environment Spaces

    - (bld)
    - dev
    - int
    - mnt
    - prd 
    - (tmp)

Service Layers 

    - backend layer: databases, data sources, transformation, caches

    - core layer: micro-services, communications, orchestration, logic 

    - frontend layer: ingress, redirects, clients, presentation

Service Slices

    - stateful data services  (persist session state)

    - stateless services


Container Pods



 
# Implementation





 
# Appendix


## AWS Cloud Ops

    - setup the Landing Zone (accounts, vault, certs, secrets, roles, billing)

    - setup formation templates (s3 base buckets, cloud formation, terraform, kops)

    - deploy core network infrastructure (VPCs, zones, spaces, gateways, routes)

    - connect on-premise systems (network, storage gateways, peering, VPNs, DMZs)

    - deploy core storage, data pipelines, observability and management stacks

    - deploy build repositories, registries, and build factory and pipelines

    - deploy specific project compute and application stacks incrementally

### Serverless Ops

    - lambda functions

    - fargate ecs / eks


### Container Ops

    - Docker Containers (or ECS)

_TODO_


### Cluster Ops

    - Kubernetes Clusters (or EKS)

_TODO_


### Java Dev Ops

_TODO_

.NET Dev Ops


_TODO_


## Test Containers


  https://testcontainers.com/

