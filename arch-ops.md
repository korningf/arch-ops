
# Agile Architecture



## Contents

[TOC]



# Theory


## DevOps

These days the terms CloudOps (Cloud Operations), DevOps (Development Operations), 

DevSecOps (adding Security), and FinOps (Finance) are all the buzzwords du jour.

.

At the heart of these philosophies and practices are complete automation via

Infrastructure as Code (IAC), Build Factories, and CI/CD/CT Continuous Delivery.

.

In this document we will try to cover everything by splitting this vast domain:

Let us call Cloud-Ops the automation of cloud infrastructure, and let Cluster-Ops

be the automation of micro-services on orchestrated clusters, where as Dev-Ops

shall be the automation of building and packaging applications via build tools.




## Agility

Agile development manages risk through frequent short iterative release cycles.

We want to avoid huge monolithic modes that generate lots of deltas or diffs.

Breaking things is virtuous: we want to break things early rather than late.

Breakage forces us to communicate and resolve design, specifications, APIs.

This reduces surprises and allows us to rapidly prototype and evolve code.



## Pitfalls

### Waterfall Development

Monolithic waterfall development means long development cycles in isolation.

Releases happen seldom, are massive, and implement a monstrous set of changes.

This makes it hard isolate new specifications, refinements, additions, and fixes.

This is what we must avoid.  We want parallelised development and short cycles.


### Technical Debt

Technical Debt consist of being stuck with dependencies on archaic old systems.

This can happen for a host of reasons, sometimes through no fault of one's own.

Bugs happen, APIs change, trends fall out of fad, we cut corners for expediency.

We may be stuck with a 20 year old CMS, on an unpatched OS, and archaic database.

Every bit of software that locks us in to old code increases risks exponentially.

Agile Development helps prevent that, by encouraging us to keep up and step up.


 
## Principles

We adhere to Agile Development, Extreme Programming (XP), Lean development, etc.


* Expect Failure

    The first principle in agility is to expect things to break, often, all the time.

    We design systems that are decentralised, decoupled, and resilient to breakage.

* Small Steps

    The way to manage change is to do it in small increments with frequent iterations.

    This reduces Delta-Risk, the risk of massive and nebulous complex code changes.

* Failure is Good

    We thus favour to break things early, rather than late, and to do so gradually.

    Breakage becomes a locus by which developers get together and resolve the deisgn.

* Commit Everything

    We need to be able to roll-back in order to break things and recover with grace.

    Every micro-change must be saved in SCM and have a clear lifecycle maturity tag.

* Reproducible Builds

    All the above combine to give us a framework where everything is predictable.

    Every build that goes to production should be clearly tracked and reproducible.

* Track Everything

    Every deployment to Production or any other environment should be accounted for.

    We need to know who did it, when, why, and the path to revert to older versions.

* Decouple Dependencies

    As we plan to break things a lot, we must reduce dependencies to prevent Failure Cascades.

    We aim for generic, prescriptive solutions that are easily containerised and scriptable.
    
    This goes for code, libraries, configurations, environments, runtimes, services, etc.

* Share Nothing

    The default architecture is Share-Nothing, ie try to isolate things in micro-services.

    Services and data must be split up in modes which allow isolated single-responsibility.

    Typically this is achieved through micro-services and sharding business domain data.

* Portable Containers

    Shared-Nothing isolation allows for portable, resilient, and scalable systems.

    Containerisation supports high availabiity modes where we can scale with demand.

    Ideally non-critical services can be scaled down to zero during lulls in demand.


## IAC

The Cloud-Ops and Dev-Ops revolution is based on Infrastructure-as-Code (IaC).

The idea is to provide a predictable, prescriptive way to deploy entire systems,

starting with cloud infrastructure, to service cluster, deployment environments,

all the way to binary distributions, dependency libraries, bundled applications

and software configurations - in short everything necessary to get it all running.

  


## Source

To the maximum possible, everything is source code.  We commit not just actual

application code, but the entire gamut of tools needed to get it on production.



This includes configuration and scripts needed to build the clusters and clouds,

to define its environments and namespaces, to provision accounts and user roles,

access control lists, tool chains, configurations to build and test applications,

any build and test automation settings, and any deployment and monitoring tools.



Everything should be accessible in an SCM / VCS.



Not all SCM are equal: modern hash-based ones produce nigh-perfect auto-merges.

As agile code relies on frequent fast iterative changes, we need to merge a lot. 

Thus the modern factory uses Git as SCM (though Mercurial/HG would do as well).



There is a steep learning curve to Git, but we can stick to vanilla patterns.

Strategies are necessary as we plan to refactor and break things constantly.


 
## Style

The days of 80-char consoles are long-gone; modern IDEs have wide displays and 

have tools to visually grok code, ex via syntax highlighting to method roll-ups.


We no longer have to accomodate saving vertical and horizontal space, and modern

code is so complex that what is needed is to maximize not the number of lines,

but rather the structure of code, and quickly locate key areas of interest.


Code Agility is all about clarity, facilitating refactors, and reducing errors.

We need a way to visually grok parameters, expressions, and easily grok deltas.



## Refactoring

Code that is quickly grokked produces fewer bugs and is easier to maintain.

The structure and order of the code should be a form of self-documentation.


Refactoring should be encouraged to achieve well-recognised design patterns.

Where possible use Interfaces and Abstract Classes that self-describe the API.

One key strategy is to push Stub and Mock implementations as early as possible.

This then becomes a locus by which developers collaborate to refine the design.


## Standards

In order to reduce refactoring delta-risk, we clarify standards and orderings.

Orderings are particularly important, as are naming standards for everything.


### Naming

_Ask the developers to formalise and document their current naming practices_

    packages, libraries, classes, objects, variables, constants, methods, statics.

_TODO_


### Ordering 

_Ask the developers to formalise and document orderings and any other standards._

    packages, libraries, classes, objects, variables, constants, methods, statics.

_TODO_


### Formatting

Where possible we use IDE hooks to autoformat code and standardise code order.



Firstly this strips away petty cosmetic diffs, allowing coders to focus on logic.

Secondly some styles reduce merge errors, notably on merged nested expressions.



For this reason, we favour the GNU style, failing this the Allman style (BSD).

Any style will do, so long as all developers agree on a standard and stick to it.

_Ask the developers to pick a style (we recommend GNU)_

    https://en.wikipedia.org/wiki/Indentation_style#GNU

    https://en.wikipedia.org/wiki/Indentation_style#Allman

_TODO_


## Dynamic Code


### Code Configuration 

Inversion of Control (IOC) or Dependency Injection, allows Dynamic Code Path Configuration, 

A necessity when selecting and integrating partial feature-sets, Stubs, Skeletons, and Mocks.


_TODO_

_Talk with the .NET developers to identify Inversion of Control and Dependency Injection use_



### Code Generation

Aspect-Oriented Programming (AOP) or Annotation-Processing, uses Code Generators or Processors,

generating implementation behaviours based on known specification tags embedded in the source code. 

in java these tags are called Annotations, in .NET these are called Aspects.

_TODO_

_Talk with the .NET developers to identify any Annotation processor and Code generator use_



### Code Coverage

Modern frameworks combine these techniques for maximum Agility, but the trade-off, a partial code-path,

needs to be managed, typically via tools to ensure Code Test Coverage at different lifecycle scopes.

_TODO_

_Talk with the .NET developers to identify Code Coverage and Deependency Enforcement use_


## Documentation

Ask the AP.NET and .NET developers on how they auto-document their code and APIs.

I believe this is done through XML Documentation and perhaps DocFX or Sandcastle ?

XmlDoc

    https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/xmldoc/

DocFX

    https://dotnet.github.io/docfx/docs/dotnet-api-docs.html

SandCastle

    https://www.microsoft.com/en-us/download/details.aspx?id=10526

    https://github.com/EWSoftware/SHFB




### REST API 

Investigate how to generate REST API documentation - ie OpenAPI /  Swagger apidocs.

    https://swagger.io/specification/v3/

    https://learn.microsoft.com/en-us/aspnet/core/fundamentals/openapi/aspnetcore-openapi?view=aspnetcore-9.0&tabs=visual-studio%2Cvisual-studio-code



### Markdown Wiki

Where longer documents are needed, a Markdown wiki like this doc is preferred.

Unless one needs custom graphics, this is generally adequate for most purposes.

Wikis allow one to focus on content, rather than ponder layout and presentation.

Also, a text-based wiki is indexed and facilitates elastic multi-document searching.

    Sharepoint supports Markdown text web-parts.

    https://support.microsoft.com/en-US/office/use-the-markdown-web-part-6d73c06d-2877-4bc9-988b-f2896016c50b

    Apparently it uses 'Marked', so there may be a way to a CSS stylesheet.

    _TODO_ invetsigate how to set a custom CSS stylesheet and change the skin.

    https://marked.js.org/




 
# Practice


## Factory

In DevOps, everything happens via the build factory, which automates the whole thing.


Typically an automation factory will have a combination of prescriptive configurations

and automation pipelines to build, test, and deploy and provision complete systems.



A long time agao app builds used programmatic dark magic known only by build masters,

often consisting of 10,000 line Makefiles and custom scripting and other such arcana.

A new developer had to spend countless hours trying to learn how to build and deploy.

At every new outfit, one had to reinvent the wheel, and rewrite the same build chain.



Apache Maven pioneered prescriptive building, where builds followed preset patterns.

The scripted bits were abstracted away into plugins, exposing generic configurations.

Succinctly, One no longer has to tell it **how** to build, rather **what** to build.

A new Developer need only know the generic Maven plugin invocation and configuration.



This greatly reduces adoption time and increases build integration and portability.

Now that all builds have a generic facade, the next logical step is to chain these

together to allow automated integration testing, configuration, and even deployment.



## Access-Control

a secure-vault using a unix password-store is used for storing secrets.

the secrets-vault is backed by SSL certs, SSH keys, and a GPG keyring.


## Source Code

All code lives in a git repo. 

Any will do, say github private repos and public repos for open-source.

We recommend github or any other modern git with agile integrations:

a markdown wiki, a bug tracker, pull requests and CI/CD/CT tooling. 



## CI/CD/CT

Continuous Integration, Continuous Deployment/Delivery and Continuous Testing 

is done by the factory using jobs, triggers, and an agile assisted release cycle.



Whenever a developer commits and pushes code to a repository, the build factory 

notices and pulls the latest code and attempts to build the entire application. 

In doing so it runs automated tests to validate the build, and if successful

then tags and pushes the latest version for testing.



There may deep Integration-Tests to test the app against dependent applications.

If a deployment pipeline is used, the app si then automatically deployed live.



Finally a suite of automated tests can be started against the deployed version,

running long-terms scenario tests, performance tests, gathering telemetry data.


## Pipelines

The build factory simplified automation through a prescriptive standardised interface, 

but as it integrated more and more diverse languages and stacks it was found wanting.



Some stacks are exotic, all environments are boutique, and many have legacy systems.

Often there is no integration plugin for a specific framework or custom tool-chain.



Pipelines, in a way are a return to the past, they bring back programmatic scripting.

They complement prescription, filling the gaps where standard plugin confguration

alone cannot fully automate the process. 



In an ideal world, everything is generic, prescriptive, standardised, via plugins.

Alas the world is messy, and we need them (as much as possible rely on prescription).

In the end, pipelines are code, thus they are IaC and should be checked-in as well.




# Environments and Spaces

There are different theories on what constitutes a Deployment Environment.

We have chosen a pattern that works for fast agile CI/CD/CT deployments.


In our system, an Environment represents a product life-cyle **maturity**.

That is, it represents a well-known stage for a particular feature-set.

This is where the Agile Factory differs from more traditional modes.



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


The DEV environment is for continuous Development build snapshots.

Code pushed to the Trunk is continuously built and pushed to DEV.

DEV is unstable, it is in flux and can break, features may be stubbed.

DEV makes no promise on module feature-set completion or consistency.



By contrast, INT or Integration holds functional feature milestones.

Those bits that are not stubbed should be integrated and functional.

This is where we run integration fitting-tests and deeper scenarios.



MNT or maintenance is what we call our UAT or our Staging environment.


It deploys staging candidate versions for pre-prod acceptance tests.

Maintenance should be nigh iso-prod, save that it will not autoscale.


It can also be used as a standby or Disaster and Recovery environment, 

for migration testing, for functional A|B testing or canary testing.


PRD or Production is our final live production release environment.

Production in normal situations mirrors MNT, but with autoscaling.


TMP is an optional ad-hoc Temporary or Ephemeral volatile environment,

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


Modern versionining uses version triplets and an optional text qualifier.

Qualifiers are often a source of great confusion as there is no standard.



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

The artifact file name and type should describe the type of the artifact.

Platform-specific variants go with the name as a prefix to the qualifier.


We want to standardise these maturities in order to automate CI/CD/CT.

The qualifier must always end with the maturity and the version triplet.


The reasoning is this: we want to select the version numbers on a fuzzy basis.

That is, we want a V2 to be a shorthand for say, v2.0, v2.0.0, and v2-latest.


When we do a quick version rollout, we won't be changing the os platform.

What we will want to do is quickly switchfrom the old to the new version.


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


Crucially, in CI/CD/CT, we want automated Continuous Testing and validation.

Different test gamuts are triggered automatically in different environments.



Local and developer tests use mocks and pretend they are connected to services.

Development unit tests should be short, non-blocking, triggered every check-in.

Integration tests connect to real dockerised services and cover entire features.

These are triggered less frequently, at feature integration, ie daily or weekly.

Scenario Tests test complete workflows and trace use-cases in the vertical stack.

Performance Tests and Regression Tests run in Maintenance or Staging Laboratory.

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



 
# Telemetry

## Logging

We use a Logging framework and a tracing framework, like SLF4J or SLF4Net.

This allows us to define log categories for selective filtering and tracing.

As much as possible, apps should support a vertical Diagnostic Trace Context.

In CI/CD/CT, we want log category names to group tests by default environment.


SLF4J and SLF4Net are not only Logging Frameworks but also unified Logging Facades,

That is they have wrappers which cover and impersonate all the mainstream loggers.

Linking with these wrappers or bridges means we can unify and intercept all logs.

That is, even logs and traces written by 3rd party APIs can now be intercepted.


We strongly recommend SLF4J (and logback) and SLF4Net

    https://www.slf4j.org/manual.html

    https://github.com/ef-labs/slf4net

One could also use Log4J anbd Log4Net standalone

    https://logging.apache.org/log4j/2.x/index.html

    https://logging.apache.org/log4net/



## Tracing

Unified logging frammeworks like Log4J/SLF4J or Log4Net/SLF4Net changed everything.

It is now possible to attach contextual medta-data to all distributed systems.

Provided we are using instrumented apps, for example REST micro-services, etc,

we can now enrich the entire flows across not just a single application call stack,

but all the apps involved, eg to a client, server, cache, database and middleware.

Tracing tracks a single user session on its end-to-end journey through the system.

Modern Telemetry and Tracing implements the W3C Tarcing Context, including IIS.

    https://www.w3.org/TR/trace-context/

    https://learn.microsoft.com/en-us/dotnet/core/diagnostics/distributed-tracing-concepts

    https://medium.com/cloud-native-daily/distributed-tracing-a-guide-for-2023-a40a1ee218b5

    https://www.jimmybogard.com/building-end-to-end-diagnostics-and-tracing-a-primer-trace-context
 

## Metrics

The third part of Observability and Telemetry is Quantitiative Metrics and signals. 

All of our apps should have hooks into standard OpenMetrics or OpenTelemetry APIs.

These should expose the standard Profiler values, Memory, IO, and system health.


_TODO_ 
_Select the appropriate telemetry / Observability suites (OpenTelemetry, Grafana ?)_


Instrumentation
Finally we should have sandbox Debug versions of apps that expose Headers and Symbols.
We should also expose standard admin or management interfaces, secured in production.

_TODO_ 
_Select the appropriate instrumentation suites_




# Virtualisation

Developing software requires a panoply of frameworks, SDKS, IDEs, and build tools.

In engineering parlance this is knonw as a toolchain, and its choice is crucial.

Builds are a messy affair, and reliable builds require a consistent build toolchain.

It can be a herculean nigh-impossible task to try to build on a different toolchain.

.

Consequently we will benefit from having all developers stick to the same platform.

One way to do this is to build development-specific virtual-machines - ie dev boxes.

_TODO_ investigate provisionning dev boxes using Vagrant (or Chef, Puppet, etc).




 
# Building

## Tool Chain

In the past Building software and configuration management was a black-art.

Build systems required a level of mastery usually relying on a build-master

who knew the intricacaies of the dependencies and wrote the build scripts,

that is all the arcane incantations required to produce consistent builds. 



This is what we aim to avoid. We want to rule out any artisanal custom builds.

Rather we want to use a prescriptive build, where we tell it *what* to build,

not *how* to build, and the build system rely on a dependency management engine

to resolve dependencies and compile and link the code.



In the java world, this prescriptive build framework is built around Maven.



We want a similar framework for .NET.


## Dependency Manager

Now modern software is all about modularity, portability, re-use, and not re-inventing the wheel;

A typical application might only consist of 10 original code, the rest being dependent libraries,

Third party code, and boilerplate code integrated from APIs, SDKs, frameworks, and generated code.

A large part of application development, configuration management, build and development operations 

consists in the art of specifying, resolviong, and including these additional transitive dependencies.

In the modern toolchains, this is the role of the build dependecy resolver and package manager.

This component is typically handled by Maven for the world java, or by NuGet for DotNET builds. 



## Compiling

if we can, we want to use the build toolchain to build distros and even to deploy them.

Building and testing in a .NET tool chain uses Msbuild, Nuget, and NUnit (is NMake dead?)

Investigate what the equivalent is in modern .NET  (Consider Nuke, Cake, NMake options ).

    Nuke

        https://nuke.build/
    
        https://nuke.build/faq/ 

        https://nuke.build/docs/introduction/

    Cake

        https://cakebuild.net/

        https://www.nuget.org/packages/Cake.Tool


    We've gone ahead with selecting Nuke for now  _(ask experienced .NET people?)_





We expose everything through the command line with the use of tools and scripts.

We need to be able to do the following:

    - automate and configure
    - build or compile locally
    - commit code, pull and push
    - test various test categories
    - tag features and versions

    - package binaries and distros
    - provision environment resources
    - deploy distros to environments
    - rollback from a deployment
    - run validations in a deployment



## Artifacts

As modularity and code reuse is a guiding principle we rarely publish monolithic systems.

Rather we bundle code into reusable libraries, and package these together into artifacts.

Containers are Collections of these artifacts running on a single machine environment.

Finally Sets of containers comprising a complete system are called Distributions.


    libraries:

        mxstat-api-model.dll
        mxstat-api-core.dll
        mxstat-client.dll

    artifacts:

        mxstat-api-model-1.2.3-dev-latest.dll
        mxstat-api-core-1.2.1-dev-latest.dll
        mxstat-client-1.2-dev-latest.dll


## Bundles

Typically we develop services as web REST services, bunbdled into binary archives.

These bundles are also artifacts, often stored in the same binary artifact repository.

    java:    

        mxstat-java-client.war   

    .net:    

        mxstat-dotnet-svc.zip 


## Containers

The first thing to do is to shed IIS and replace it with Kestrel, a linux .NET webapp.

This will allow us to containerise our applications, notably on Docker or Containerd.

For each tagged bundle to be deployed, a corresponding Docker image can be generated.

Docker images are published in a central private container Registry (Nexus or AWS ECR).

.

We use docker tags to mirror our labelling strategy with version triplet and maturity.

The tag is the mechanism by which continuous deployment will automate rolling updates.

    windows:

        mxstat-windows-svc/1.2.3-release
        mxstat-windows-svc/1.2-release
        mxstat-windows-svc/1-release
        mxstat-windows-svc/release

    kestrel:

        mxstat-kestrel-svc-/1.2.4-latest
        mxstat-kestrel-svc-/1.2-latest
        mxstat-kestrel-svc-/1-latest
        mxstat-kestrel-svc-/latest

Note, in the docker world the term "latest" is cognate with the our maven "snapshot".

Selecting for "latest" will select the latest untsable image from adev-latest.

        DEV => mxstat-kestrel-svc-/latest  ->   mxstat-kestrel-svc-/1.2.4-latest

For maintenance (MNT) or production (PRD), we typically select a specific release.

        PRD => mxstat-windows-svc/1.2.3-release

    

## Distributions

A distribution is a collection of Docker images and configurations with the same tag.

   dev-latest
    v-3-dev-latest

    int-recipe
    v-2-int-recipe

    mnt-staging
    v-2-mnt-staging

    prd-release
    v1-prd-release
    v1.2-prd-release
    v1.2.3-prd-release



# Alternate Production

Occasionally we want MNT to be an alternate production deployment environment.

The MNT staging environment already built, this reduces complexity and costs.

This may useful for migration, for slitting up load spikes, for deep debugging.

We can tag distros for ad-hoc Red|Black, Blue|Green, A|B and Canary Testing.

    mnt-testing     -> alternate prod used for red|black deployment, migration, testing

If budget allows another strategy is to spin up a new ephemeral environment.

A TMP environment for example could be usedc for testing or peak offloading.

    tmp-testing
    tmp-offload


Jenkins Factory

We use a Jenkins factory configured with pipelines, folders, views, and agents.

We may need Windows agents to automate the DotNET tool chain (ask .NET developers).

_TODO_

    oldschool job with msbuild:

    https://dzone.com/articles/cicd-in-aspnet-mvc-using-jenkins

    
    pipline job with dotnet build:

    https://dotnetfullstackdev.medium.com/continuous-integration-continuous-deployment-ci-cd-with-jenkins-in-net-6eb634dfa3f2

    nuke: ?

    _TODO_






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
    - cso 

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




## Components

We have a hybrid cloud infrastructure (Amazon AWS, Azure AD, on-premise).

We have a suite of applications, namely REST services (in .NET C# code).

These depend on libraries (.NET .dll), scripts (.vbs), and configs (.json).

There is also a fair bit of OS-level scripting (.sh, .bat, .ps1, and others)

We have sqlserver databases, with code (raw .sql) and schema data (.xml).



# source code

    a separate git for CSO technical development 
    (separate from CSO functional statistics git)

        AD (pull org units / users)

        Secrets vault (not sure yet?)

        aws configs (cloud-formation)

        kubernetes configs

        docker configs

        scripts in sh, bash, bat, ps1

        sql schemas and operations

        vscode c# and .NET code

        terraform configs

        kubernetes configs

        docker configs

        scripts in sh, bash, bat, ps1

        sql schemas and operations

        vscode c# and .NET code


## build system

    GitBash, MingW, Python, Ruby, Go
    
    Docker-Desktop

    VisualStudio and VSCode IDE

    MS build tools: .NET, msbuild, nuget.

    Cake, numake, or some cmdline tool chain



## use-case

_TODO_

```text

    Branch Tree:

    api-1.0             api-1-1             api-2               fix-1               
    model-1                                 model-2             model-2.1  
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


1 library change

    in trunk we are developing and integrating on a V2 release, whereas production is still on V1.

    a developer commits changes to the communcations library to add support for JWT token refresh.

    he has a local feature branch tagged libcom-2.1


_TODO_

    he makes changes to

        libcom.cs

    it compiles and passes unit tests

        libcom-2.1.0-bld-snapshot.dll

    he checks it in trunk and it builds

    the factory tags it as snapshot

        libcom-2.1.0-bld-snapshot.dll

    the factory pulls to DEV and runs its own tests
    
    tests pass, the factory tags is as latest

        libcom-2.1.0-dev-latest.dll

    

_TODO_


 
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

