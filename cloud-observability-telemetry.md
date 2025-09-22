# Cloud Observability and Telemetry

# 1.0.  Background

As Cloud Infrastructure grows in scope and complexity according to the demands of connecting External-Tenancy Cloud-Subscriptions, On-Premise networks, and more On-Demand custom Cloud-Services, we slowly move into a federated Multi-Cloud environment. To make heads or tails of this we need a unified Cloud-Agnostic way of managing complex multi-cloud infrastructures.  

Observability is a recent concept. The idea is to provide a unified central Dashboard that observes cloud infrastructure and shows an overview of Telemetry, provides system Health Monitoring and Alerts, and runs Analytics based on usage, trends, and historical comparisons. The tools harvest events, compile results, render graphs, build reports, and in more sophisticated frameworks offer more intelligent inferences, say for audits, capacity planning, cost reporting, or security and compliance.  

It would be preferrable to select industry-standard, cloud-agnostic, open-source tools that will allow us to visualise and manage our different cloud components with a common interface. Second best would be the nativeCloud tools from Azure and AWS. A primary reason for this is the Landing Zone budget has already been allocated and these tools are priced-in.

*OpenTelemetry* (aka OTel) is the name of the game. There are no alternatives here - this is a Cloud-Neutral abstraction backed by 95 percent of the major cloud providers, Observability dashboards and suites, telemetry engines, and unified logging frameworks and facades.


# 1.1. Definition

* Observability

  The dashboards and tools to provide a universal view of cloud health and performance through the entire stack, from front-end apps up to cloud infrastructure.
  
* Telemetry
  
All Observability suites rely principally on Telemetry and Events, specifically on the 3 pillars of Metrics, Logging, and Tracing.

* Metrics are quantitative events sampled periodically, Logs are qualitative application events, and Traces are contextual correlations of such events over a User Session. 

* Vitals and Signals

In addition to quantitative merics, observability relies on programmatuic signals and alerts, often derived from health checks compared to a baseline.

* Dashboards

Monitoring applications and graphing and analytics tools. 

The term dashboards here is deceptive: behind these like a complex stack of tools and frameworks that overlap and variously compete and collaborate to give a big picture. Big cloud providers like AWS are quick to offer new unified services to do this, but again we would like something a bit more neutral and cloud-agnostic, if possible.





# 1.2.  History 

## A Brief History of Time-Series
  
Perhaps the best way to understand Observability is to pick a narrative explaining its evolution. Though history is a complex weave of trends, perspectives, and patterns, it may be useful to pick one thread and follow its perspective. The following history is a synthetic overview of how observability came about and where it might be heading.


### 1.2.1.  Metrics, Time-Series, Telemetry

This all started a long time ago during the infancy of internet with MRTG, a specialised time-series database used by ISPs to track network traffic by sampling and harvesting usage over discrete and granular time periods, and then render graphs and reports. The tool was generalised into RRDTool and things exploded from on there.

Telemetry already existed, notably for specialised engineering applications like flight control avionics, but with the birth of the network came the birth of a holistic application-neutral, network-wide systems telemetry: the idea to formalise generic abstract events from all sources however different and divergent, that metrics could be sampled and harvested over varying time-scales, and then results aggregated, compiled, interpreted, analysed, and graphed.

### 1.2.2.  Healthchecks, Monitoring, Alerts

In tandem, the notion of tracking not just numeric Quantitative metrics like traffic and usage, but also Qualitative indicators of System Health came about. Categorising faults, outages, and health by severity and deployment is now the norm, with extra bells and whistles attaching Weather icons for sunny-all-clear or stormy-system-fault. In addition, functional business domain notions could be defined, and events organised by some business model.

Modern well-behaved instrumented systems usually have a management side-channel where they report on their own health. But because not all systems do this, and since faults do happen that take a system down leaving it unable to report, additional signals are needed. This often take the form of a periodic service ping or a smoke test driven by CI/CD/CT. 

In short, we went from a Passive model harvesting event metrics to a more Proactive one with Polling and Probing.  In addition, we started adding alerts and alarms, either from instrumented systems with their own healthchecks, or externally driven through a central probing Monitoring Dashboard, often driven by CI/CD/CT automation.

### 1.2.3.  Logging and Tracing 

A long time ago, Appliance Logging followed no set standards and was a chaotic cacophony, except for Unix SysLog.

Then came the revolution of Unified Logging-Frameworks, like Log4J or Log4Net, which allowed to classify events, to attach Contextual Meta-Data, and facilitate logical filtering by narrowing specific dimensions or slices of interest. 

At the same time as Json and other convenient neutral data formats became ubiquitous, someone had the clever epiphany that log events were just … events … and that if one could get them to be written in a common format like Json, every single log trace could now potentially be instrumented as a quantitative or qualitative metric to be harvested by an analytics dashboard. This idea is called Structured Logging.

Now not all log formats use structured logging, but we can at least attach meta-data to other plain-text logs, labelling these with context.  Log Context is key.

Now modern apps rely on a complex stack including linking with 3rd party APIs, libraries, and tools, over which we often have very little control. Even within an ecosystem, say Java, there are a number of competing logging frameworks (Java native logging, WebLogic logging, Log4J, etc).   That is when app is running, different layers up its stack may be writing logs in different formats over which one has zero control.  For example the web application part could be writing log4J logs, its web app framework using weblogic logging, but its hibernate database layer writing java native logging instead...  

The next revolution, Unified Logging Facades like SLF4J / SLF4NET, now abstract all these different frameworks in a common facade, which means all of these different layers can now be intercepted, filtered, enriched with the same context, and basically the entire stack is available for log analysis and telemetry.  Rinse and repeat.

The Log Diagnostic Context meant events could now be tagged and scoped into a particular service tier, technical library, or business domain, even when that function was provided by an embedded cross-linked third-party library or API - from low-level technical drivers like database connection pools to high-level functional filters for a specific region or user cohort.

But if we can attach context throughout the stack from frontend, application, database, all the way to infrastructure, why not add the same context for all bits of a user's journey trough the stack?  

This idea is called Tracing, and it relies on a universal Diagnostic Trace Context, basically tracking the stack, ie tagging upstream components that called our layer.

Pretty soon ETL Pipelines evolved to ingest, parse, format, and transform logs and events with scope and state. This gave the ability to enrich, store, and track events with contextual meta-data. From this arose Tracing, using a unified Tracing Context to follow a user Session on its end-to-end journey through partial service-layer Spans or through the full Vertical Service Stack.





### 1.2.4.  Ad-Hoc Query Engine

Previously, aggregating and tabulating and was costly and this was only done for pre-compiled graphs and reports. Advances in computing, analytics, and integration eventually meant one could do ad-hoc queries with graphs and reports generated on the fly. Accordingly, heterogenous databases, be they SQL, NoSQL, time-series metrics, log events, or stack traces, needed to be linked and integrated. This led to Data Lakes, Data Warehouses, and log and metrics Pipelines, and the emergence of new abstract Query Expression Language family for telemetry and led to the creation of specialised Analytics Engines.

### 1.2.5.  The Analytics Dashboard

The Data Science revolution now allowed new Observability Dashboards to render sophisticated graphs, like directed graphs, edge diagrams, and to run analytics including clustering, regression, prediction and inference. The advent of AI / ML has great potential in identifying base patterns and isolating anomalies, quite useful for security, for example in intrusion detection, as well as for operations budgeting, for example in peak, trough, normal and surge capacity planning.

This is where we are, the attempted synergy to bind these ideas, stacks, and suites into a Unified Dashboard to monitor and manage cloud health. 

Note describing this as a Unified Dashboard is a bit of a unicorn: there is considerable overlap between competing frameworks and their components, and collaborating sub-components are often competing tools or frameworks in their own right. Rather than dashboards, these are frameworks with complex Tool Stacks, with some components open-source and some commercial, and most sub-components can be mixed-and matched.

For example, alongside the canonical Elastic ELK stack with ElasticSearch, LogStash, and Kibana, there is an EFK stack substituting Fluentd for LogStash. Prometheus can be wired pretty much everywhere, as can Fluentd or Statsd, almost all vendors speak OpenTelemetry, and most integrated dashboards like Grafana have adapters to ingest data from just about all the other ones. Integration is the name of the game, with the trade-off of using a Custom Stack instead of a vanilla Vendor Stack being more customer Systems Integration work. 

## 1.3.  Hosting and Pricing Models

Many different Hosting and Pricing models have emerged to host and monetise these heterogenous frameworks. Some are completely free and self-hosted. Others offer a dual model with a self-hosted community edition and a vendor-hosted cloud commercial edition. Some are mixed with sampling, storage, and harvesting components sitting on the local customer cloud while aggregation is hosted on the remote vendor cloud. Some use a simple subscription model with varying levels of support, while others use a pay-as-you-go model with usage prices per hundred-thousand log events or million metric samples.

Where the framework and long-term data are hosted will determine the scope, structure, and pricing of the observability suite. A self-hosted one may only have visibility on a single tenant, a single VPC, a single cluster, a single environment, or a namespace. A full vendor cloud-hosted offering might support multi-cloud, multi-tenancy, federated clouds with many customer clouds. This also depends on the nature of the components in the stack. Not all stacks have the same scope and depth of coverage.
When costing these offerings, always bear in mind that vendor prices may present an incomplete picture, notably that local customer-cloud storage, compute, and transit costs may need to be applied, data egress costs can be especially expensive.


## 1.5.  Cloud Operations console

Now each Cloud provider has its own native Management Console and toolkits, but they all provide a similar gamut of services. As cloud-neutral Observability Dashboards acquire the ability to do not just monitoring, but also to react to cloud event triggers and to proactively manage the cloud, the line between Observability and Operations is blurring. Indeed, many Observability platforms are branded and marketed as Operations platforms (ex Google Cloud Operations, HPE OpsRamp).

Obvious Cloud Operations features include costing and budgeting, capacity planning, auto-scaling, and even emergency routing to ephemeral environments. Neutral Cloud Operations are facilitated with abstract container and cluster orchestrators like Kubernetes. Since most Observability platforms provide a Kubernetes dashboard, we now have a cloud-neutral interface to manage cloud, cluster, and container operations, in a generic, infrastructure-as-code way.
Some of the more high-tech applications to Cloud Operations include AI / ML based analytics, anomaly detection, and inference engines.  



# Implementation


# Telemetry


No matter which observability suite or combined stack we choose to use, it will work if we plug-in Otel-compliant collectors and harvesters.  We currently use a combination of Cisco Splunk, Grafana / Prometheus, and cloud-native suites from Azure and AWS.  These are all OTel-compliant.

On top of the dashboard, we can wire-in more sophisticated analytics, for example with Power-BI and maybe some AI driven Big-Data analytics one day.

    https://opentelemetry.io



## Logging

We use a Logging framework and a tracing framework, like SLF4J or SLF4Net.

This allows us to define log categories for selective filtering and tracing.

As much as possible, apps should support a vertical Diagnostic Trace Context.

In CI/CD/CT, we want log category names to group tests by default environment.

.

SLF4J and SLF4Net are not only Logging Frameworks but also unified Logging Facades,

That is they have wrappers which cover and impersonate all the mainstream loggers.

Linking with these wrappers or bridges means we can unify and intercept all runtime logs.

That is, even logs and traces bundled in linked 3rd party libraries can be intercepted.

.

We strongly recommend SLF4J (and logback) and SLF4Net

    https://www.slf4j.org/manual.html

    https://github.com/ef-labs/slf4net

One could also use Log4J and Log4Net standalone

    https://logging.apache.org/log4j/2.x/index.html

    https://logging.apache.org/log4net/


## Tracing

Unified logging frammeworks like Log4J/SLF4J or Log4Net/SLF4Net changed everything.

It is now possible to attach contextual medta-data to all distributed systems.

Provided we are using instrumented apps, for example REST micro-services, etc,

we can now enrich the entire flows across not just a single application call stack,

but all the apps involved, eg to a client, server, cache, database and middleware.

Tracing tracks a single user session on its end-to-end journey through the system.

Modern Telemetry and Tracing implements the W3C Tracing Context, including IIS.

    https://www.w3.org/TR/trace-context/

    https://learn.microsoft.com/en-us/dotnet/core/diagnostics/distributed-tracing-concepts

    https://medium.com/cloud-native-daily/distributed-tracing-a-guide-for-2023-a40a1ee218b5

    https://www.jimmybogard.com/building-end-to-end-diagnostics-and-tracing-a-primer-trace-context


## Metrics

The third part of Observability and Telemetry is Quantitiative Metrics and signals.

All of our apps should have hooks into standard OpenMetrics or OpenTelemetry APIs.

These should expose the standard Profiler values, Memory, IO, and system health.

TODO Select the appropriate telemetry / Observability suites (OpenTelemetry + Signoz, Grafana ?)


## Instrumentation 

Finally we should have sandbox Debug versions of apps that expose Headers and Symbols. 

We should also expose standard admin or management interfaces, secured in production.



_TODO Select the appropriate instrumentation suites_


# Appendix

