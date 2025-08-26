# Kubernetes-Operations

## Tenets of Kubernetes

```text

0. Neutrality:    Kubernetes is a neutral abstract Meta-Cloud used to unify different vendor-specific Cloud Infrastructures.

1. Heterogenity:  It uses a modular plugin architecture, with all vendor-specific implementation wired as custom plugins.

2. Homogeneity:   The Implementation uses plugins, but they all speak a unified Specification based on an abstract Model.

3. Isolation:     It forces us to identify, isolate, and break down complex systems into single-responsibility components.

4. Visibility:    This in turn forces us to identify and expose the intriticate dependencies between these components.

5. Containers:    Once decoupled, isolated applications become ideal candidates for virtualisation, aka containerisation.

6. Portability:   Containers are catalogued into services, configurations, and dependencies which can be deployed anywhere.

7. Automation:    With isolated, portable modular components, we can automate their runtime configuration and deployment.

8. Provision:     This gives us a grammar to Provision systems, to express desired topology, deployment, scale, resources.

9. Sequencing:    This forces us to expose dependency sequence rules, which are also expressed in neutral config and code.

10. Orchestration:  We use this grammar to express state changes, to manage distributed systems including their dependencies.

11. Monitoring:    The common model forces us to expose application health checks and telemetry, metrics, logging, tracing.

12. Reliability:   Apps abstracted in services which can be replicated and load-balanced for fault-tolerance and reliability.

13. Scalability:  This allows to scale to a given topology, to scale the topology on demand, or define policies to autoscale.

11. Migration:    This model allows to plan any migration or transition with full support for rollback and recovery.

11. Federation:   This model allows to plan any migration or transition with full support for rollback and recovery.

13. Ecosystem:   	it is ubiquitous and has a vast ecosystem including all major cloud provides and open-source developers.

```
