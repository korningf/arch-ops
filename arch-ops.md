
# Agile Architecture - Arch-Ops



## Contents

[TOC]



## Arch-Ops

These days the terms CloudOps (Cloud Operations), DevOps (Development Operations), 

DevSecOps (adding Security), and FinOps (Finance) are all the buzzwords du jour.

.

At the heart of these philosophies and practices are complete automation via

Infrastructure as Code (IAC), Build Factories, and CI/CD/CT Continuous Delivery.

.

In this document we will try to cover everything by splitting this vast domain.


* Arch-Ops    agnostic architecture (orgs, accounts, infra, storage)
* Base-Ops    base infrastructure  (vpc, networking, relays, gateways)
* Core-Ops    core deployments (database, compute, communications)
* Dev-Ops     application development



```text
   arch
      auth        account, landing zones      
      stores      static storage
      locales     regions, zones

      orgs        root organisations   
      units       org units (org groups)
      roles       users, groups, roles, policies

      projects    subscriptions          (cpi, govid, bom, bcm, rem, etc)
      spaces      business partitions    (sbx, gov, dsp, pub)  
      environs    runtime environments   (dev, int, mnt, prd)

   base
      resources   resource groups
      services    service groups

      stacks      app stacks
      racks       placement groups

      networks    vnets (vpc)
      subnets     zones (azs)

      relays      gateways
      dmzs

   core
      compute      serverless

      compute      clustered

      compute      standalone


  data
      database     backend
      database     clustered

      middleware   queues, pubsub topics
      pipelines    transformation pipeline

```


# Theory



## Agile Architectures


An agile architecture simp0lifies a complex stack into a cloud-agnostic abstraction.

It is portable, predictable, prescriptive, and make suse of generic re-usable patterns.

This lowers complexity, mitigates risk, and reduces adoption and maintenance time.



## Ontology




## IAC

The Cloud-Ops and Dev-Ops revolution is based on Infrastructure-as-Code (IaC).

The idea is to provide a predictable, prescriptive way to deploy entire systems,

starting with cloud infrastructure, to service cluster, deployment environments,

all the way to binary distributions, dependency libraries, bundled applications

and software configurations - in short everything necessary to get it all running.


  

# Practice


## Factory

In DevOps, everything happens via the build factory, which automates the whole thing.

.

Typically an automation factory will have a combination of prescriptive configurations

and automation pipelines to build, test, and deploy and provision complete systems.

.

A long time agao app builds used programmatic dark magic known only by build masters,

often consisting of 10,000 line Makefiles and custom scripting and other such arcana.

A new developer had to spend countless hours trying to learn how to build and deploy.

At every new outfit, one had to reinvent the wheel, and rewrite the same build chain.

.

Apache Maven pioneered prescriptive building, where builds followed preset patterns.

The scripted bits were abstracted away into plugins, exposing generic configurations.

Succinctly, One no longer has to tell it **how** to build, rather **what** to build.

A new Developer need only know the generic Maven plugin invocation and configuration.

.

This greatly reduces adoption time and increases build integration and portability.

Now that all builds have a generic facade, the next logical step is to chain these

together to allow automated integration testing, configuration, and even deployment.



## Access-Control

A secure-vault using a unix password-store is used for storing secrets.

the secrets-vault is backed by SSL certs, SSH keys, and a GPG keyring.

.

## Source Code

All code lives in a git repo. 

Any will do, say github private repos and public repos for open-source.

We recommend github or any other modern git with agile integrations:

a markdown wiki, a bug tracker, pull requests and CI/CD/CT tooling. 



## CI/CD/CT

Continuous Integration, Continuous Deployment/Delivery and Continuous Testing 

is done by the factory using jobs, triggers, and an agile assisted release cycle.

.

Whenever a developer commits and pushes code to a repository, the build factory 

notices and pulls the latest code and attempts to build the entire application. 

In doing so it runs automated tests to validate the build, and if successful

then tags and pushes the latest version for testing.

.

There may deep Integration-Tests to test the app against dependent applications.

If a deployment pipeline is used, the app si then automatically deployed live.

.

Finally a suite of automated tests can be started against the deployed version,

running long-terms scenario tests, performance tests, gathering telemetry data.


## Pipelines

The build factory simplified automation through a prescriptive standardised interface, 

but as it integrated more and more diverse languages and stacks it was found wanting.

.

Some stacks are exotic, all environments are boutique, and many have legacy systems.

Often there is no integration plugin for a specific framework or custom tool-chain.

.

Pipelines, in a way are a return to the past, they bring back programmatic scripting.

They complement prescription, filling the gaps where standard plugin confguration

alone cannot fully automate the process. 

.

In an ideal world, everything is generic, prescriptive, standardised, via plugins.

Alas the world is messy, and we need them (as much as possible rely on prescription).

In the end, pipelines are code, thus they are IaC and should be checked-in as well.




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


## Spaces

Spaces are sub-categorisation of Environments, splitting up the business domain.

These are specialisations, that is a DEV environment may have multiple variant spaces.

These Workspaces deploy variant distributions, supra branches of code and configuration.

Spaces typically ship as distributions and use qualifiers.  Here are 2 sample spaces:

    data-api-access-1.0.0-survey-dev-latest

    data-api-access-1.0.0-census-dev-latest



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


## Environments and Maturity

BLD or Build is a mock environment used for local developer machines.

.

The DEV environment is for continuous Development build snapshots.

Code pushed to the Trunk is continuously built and pushed to DEV.

DEV is unstable, it is in flux and can break, features may be stubbed.

DEV makes no promise on module feature-set completion or consistency.

.

By contrast, INT or Integration holds functional feature milestones.

Those bits that are not stubbed should be integrated and functional.

This is where we run integration fitting-tests and deeper scenarios.

.

MNT or maintenance is what we call our UAT or our Staging environment.

.

It deploys staging candidate versions for pre-prod acceptance tests.

Maintenance should be nigh iso-prod, save that it will not autoscale.

.

It can also be used as a standby or Disaster and Recovery environment, 

for migration testing, for functional A|B testing or canary testing.

.

PRD or Production is our final live production release environment.

Production in normal situations mirrors MNT, but with autoscaling.

.

TMP is an optional ad-hoc Temporary or Ephemeral volatile environment,

.

which can be used for to handlle burst load, to isolate specific shards

in the business domain, for example to resolve bugs, record and replay,

or for canary testing, aka A|B testing, red|black, or green|blue testing.



 
# Change Management


The key to Agility is to have a coherent Change Management or Change-Set Strategy.

We want to track Change across Spaces, Environments, Versions, Branches and Tags.

The following patterns have evolved empirically over many years as Build-Master.

They have been adopted because they reduce delta risk errors and facilitate merges.

 
## Branching

We try to avoid convoluted feature-branches and back-porting changes.

The idea is everyone develops on the trunk, with all features present.

Where we need to, we use API stubs and just include a feature skeleton.

This lets developers get an idea of the API and speeds up integration. 

We want to allow different features to be in various states of readiness.

Crucially, we want to standardise that notion of readiness, ie maturity.

.

Our strategy uses 5 maturity branches to mirror our deploment environments.

The Factory' automation only acknowledges these 5 standard maturity branches.

Note developers are still free to use feature-set branches if they desire, 

*but Feature Branches must be regularly merged to these maturity branches*, 

*and all eventually merge to Trunk. This is critical to reduce merge risk*. 



## Branches:

    (bld)  - build-local (local copy of trunk)
     dev   - development trunk
     int   - integration
     mnt   - maintenance
     prd   - production


```text

    Branch Tree:

    api-1.0             api-1-1             api-2               fix-1               
    libcom-1                                libcom-2                                libcom-2.1          
    v1, v1.0, v1.0.0    v1-1, v1-1.0        v2, v2.0, v2.0.0    v2.0.1              v2.1, v2.1.0
    |                   |                   |                   |                   |
    +-------------------+-------------------+-------------------+-------------------+-------------------+
        \                        \                          \                           \
         +---v1.0.0-dev----+      +---v1-1.0-dev------+      +---v2.0.0-dev------+       +---v2-1.0-dev------+
            \                         \                          \                           v2-1-dev, v2-dev 
             +---v1.0.0-int------+     +---v1-1.0-int------+      +---v2.0.0-int------+
                \                           \                         v2.0-int, v2-int
                 +---v1.0.0-mnt------+       +---v1-1.0-mnt------+
                    \                            v1-1-mnt, v1-mnt
                     +---v1.0.0-prd-------+
                         v1.0-prd, v-1-prd

```
 
## Features

We still develop in features, but we try to fit them within maturity branches.

The way we do this is we use internal labels and tags for feature maturities.

In addition, we use features and tags for the maturity of the entire branch.

Recall modern SCM / VCS allow the use of multiple concurrent tags or labels.

For example all these tags can be set at the same point on the trunk:

    base-comms-api
    v-1-base-comms-api
    v-1.2-base-comms-api
    v-1.2.0-base-comms-api

    dev-latest
    v-1-dev-latest
    v-1.2-dev-latest
    v-1.2.0-dev-latest


## Tagging

Modern SCM supports both branching and tagging (labels in time in a branch).

We make use much tagging, notably where branches fork out and merge back-in.

We also use tagging for functional feature-sets, and finally for maturities.

Our Factory formalises both branching and tagging with strict versioning rules.



## Versioning


Over the years many config management gurus have proposed standardisations.

Our experience has been to champion a simplified process based on lifecycle.

.

Modern versionining uses version triplets and an optional text qualifier.

Qualifiers are often a source of great confusion as there is no standard.

.

A cursory look at OSGI versioning quickly shows how chaotic it can be.

Some use them for artifact type, others for OS, machine, and platform.

 
### Version Chaos

OSGI has added to the confusion by endorsing a medley of maturity types.

These are long or short and follow no clear maturity lifecycle sort order.


Sample OSGI versions:

    1.0.0     
    1.0.0-stable
    1.0.1-alpha-2
    1.0.1-beta

    2.0
    2.0-latest
    2.0.0-rc.1 
    2.0.0-rc.2 
    1.0.1-alpha-2

    3.2.1-win-x86-pre-prod
    3.2.1-linux-x64-ga-final


Let us rationalise this a bit.

Succinctly, these should sort naturally with latest unnstable versions last.

.

The artifact file name and type should describe the type of the artifact.

Platform-specific variants go with the name as a prefix to the qualifier.

.

We want to standardise these maturities in order to automate CI/CD/CT.

The qualifier must always end with the maturity and the version triplet.

.

The reasoning is this: we want to select the version numbers on a fuzzy basis.

That is, we want a V2 to be a shorthand for say, v2.0, v2.0.0, and v2-latest.

.

When we do a quick version rollout, we won't be changing the os platform.

What we will want to do is quickly switchfrom the old to the new version.

.

We want to put the maturity and version number in a predictable known place.

Now note we don't know if we have other classifiers (for arch platform etc).

So we standardise and always put the maturity and version number at the end.




 
### Semantic Versioning

We follow the main Semantic Versioning rules and use a version triplet.

The triplet is followed by a classifier for the maturity tag or label.

  https://semver.org/

Unlike many SemVer implementations we stay away from OSGI nomenclature,

the reason being that OSGI qualifiers liek rc-1, final, beta, alpha etc

do not sort alphabetically by maturity and so increase complexity risk.

.

We simplify our versions by prefixing them with the environment-moniker.

Let us call this formalism Symbolic Versioning.


### Symbolic Versions:

    (1.2.0-bld-snapshot)

     1.1.1-dev-latest

     1.1.0-int-recipe
    
     1.0.1-mnt-staging

     1.0.0-prd-release


### Symbolic Tagging

Tagging is the way changes are propagated and promoted in the factory.

Trunk has untagged versions. Those passing tests are tagged -dev-latest.

Features milestones ready for integration are then tagged -int-recipe.

Versions ready for maintenant or staging are tagged with -mnt-staging.

Finally live production release versions are tagged with -prd-release.

Symbolic Tag Qualifiers:

    (*-bld-snapshot)

     *-dev-latest

     *-int-recipe
    
     *-mnt-staging

     *-prd-release





## Symbolic Versioning

The key rule is partial names resolve to the most current matching version.

.

A major version number (v-1, v-2) represents a major product release.

This will have new APIs, new SDKs, new dependenceis, new feature-sets.

A change in major version number will definitely break older versions.

.

A minor version couplet (v-1.2) represents an API upgrade or extension.

this means one or a few feature-sets may include new functionalities. 

crucially, other older features should remain backward-compatible.

Bar the new APIs, a v1.3 version should be compatible with a v1.2.

.

A patch version triplet (v-1.2.3) represents a punctual patch or a fix.

It should never break a feature or API and is always backward-compatible.

That is a v-1.2.3 should always be fully compatible with a v-1.2.2.

.

The tull version number triplets, ie v-1.2.3 are explicit version numbers.

Fuzzy partial version numbers select for the latest implicit sub-version.

A version without a version triplet number refers to the latest maturity.

```text

    v3-dev-latest         -> current latest development 

    v-3-dev-latest        -> implicit v-3 dev-latest

    v-3.2-dev-latest      -> implicit v-3.2dev-latest

    v-3.2.1-dev-latest    -> explicit version v-3.2.1

    v-2-int-recipe        -> latest v-2 integration recipe

    v-2.4-int-recipe      -> implicit v-2.4 
 
    v-2.4.6-int-recipe    -> explicit v-2.4.6

    v-2.4.5-mnt-staging   -> latest v-2.4.5 laboratory staging

    v-1.6.10-prd-release  -> canonical production release

```

 
## Feature-Sets

We try to synchronise Feature-Sets and their library dependencies together.

That is to say a V2 Feature-Set, would have a v2 database and a v2 server.

This is not alway possible, as some models are shared by many applications.

We will address strategies for these cases later on.


## Dependencies

We want to Decouple dependencies and have clarity as to their relative maturity.

We use static analysis and a dependency management and enforcement tool chain.

This tool must be able to calculate and selectively forbid transitive dependencies.

.

The number 1 rule is that a stable production release is static and never in flux.

That is, the dependencies for a prd-release must alll be -prd-releases themselves.

Similarly, a maintenance staging can only depend on -prd-release and -mnt-staging.

Integration versions can depend on the above plus any other int-recipe versions.

Similarly, Development snapshots can depend on all above plus other -dev-latests

Finally, Local builds can rely on absolutely anything (even uncommitted local code)

    Dependency Enforcement:

    version             allowed transitive dependencies (may depend on)
    ================    =================================================
    foo-prd-release     *-prd-release*
    foo-mnt-staging     *-prd-release*, *-mnt-staging
    foo-int-recipe      *-prd-release*, *-mnt-staging, *-int-recipe
    foo-dev-latest      *-prd-release*, *-mnt-staging, *-int-recipe, *-dev-latest
    foo-bld-snapshot    *-prd-release*, *-mnt-staging, *-int-recipe, *-dev-latest, *-bld-snapshot (anything)




# Testing

We use a Testing Framework integrated with the build chain and test groups.

The framework should allow for Mocking, REST automation, possibly TDD/BDD.

In java this is provided via Maven, Mockito, Junit, RestAssured / HamCRest.

 _in .Net: perhaps a combination of MsBuild, Moq, NUnit, ResAssureDotNet ?_

.

Crucially, in CI/CD/CT, we want automated Continuous Testing and validation.

Different test gamuts are triggered automatically in different environments.

.

Local and developer tests use mocks and pretend they are connected to services.

Development unit tests should be short, non-blocking, triggered every check-in.

.

Integration tests connect to real dockerised services and cover entire features.

These are triggered less frequently, at feature integration, ie daily or weekly.

.

Scenario Tests test complete workflows and trace use-cases in the vertical stack.

Performance Tests and Regression Tests run in Maintenance or Staging Laboratory.

.

Finally Production Smoke Tests are instant, non-invasive monitoring healthchecks.


```text
   
    Test Group prefixes:

        (bld) - local trunk developer tests

        dev   - development unit tests, mock tests 
        int   - integration tests, feature-set tests, and coverage
        mnt   - scenario tests, performance tests, regression tests 
        prd   - smoke tests (non-invasive production health checks)

        (tmp) - temporary tests for A|B testing (canary testing)


    Sample Test Groups:

        DevLibTest     low-level library utility tests (infrequent)
        DevMockTest    light mock tests (mock services / resources)
        DevUnitTest    functional unit test

        IntMockTest    full feature integration test (with mock stub services)
        IntDockTest    full feature integration test (with dockerized services)
        IntCaseTest    specific challenging workflow case test
        IntCoverTest   wider coverage test

        MntScenTest    Full session scenario-test
        MntEdgeTest    Exotic edge-Case test
        MntPatchTest   Patch regression test 
        MntLoadTest    Load and performance test

        PrdSmokeTest   Production smoke test

        UseCaseTest    Deep user session use-case trace test (manual launch only)
    
```





# Testing


## Test Containers

    Modern build frameworks support full integration tests connecting real services.
    Typically this is done through docker test-containers, lightweight webapp servers, 
    database migration engines, and a host of similar test engines for all services. 

    The test driver spins up any required databases, middleware, and creating schemas
    and populating initial data.  It then spins up and connects the application and
    runs integration tests against the test services, after which it tears them down.

    TestContainers.Org is an industry led project implementing this for Java and DotNet.
    For Java, this is embedded within Maven and Frameworks like Dropwizard, SpringBoot.
    For Dotnet, I presume this is integrated into donet build (_TODO ask developers ?_)

    For this to work, our factory and dev boxes need a docker engine (docker-desktop).





# Databases

## Data Migration

We favour modern Liquid Database migration engines like Liquibase, FlyWay, or MyBatis.

This allows us to apply IaC principles to the schema, metadata, and the data itself.

We can thus iteratively create populate, and update our databases as they evolve.

.

An alternative is to use proprietary tools, such as Oracle DataGuard (aka RMan).

Where possible we want to use agnostic non-vendor-specific tools like LiquiBase.

```text

    Liquibase

        Liquibase is prescriptive, it is based on generic xml configurations.

        We favour Liquibase as it uses XML schemas, is ubiquitous, elegant, simple.

        _TODO_  investigate Liquibase for .NET

    FlyWay

        Flyway is programmatic, it does a lot of its stuff through dynamic code.
        
        Flyway has .NET integraions including EF Core but it's a lot more complex.

        _TODO_  investigate Flyway for .NET

```


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

