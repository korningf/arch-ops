# Kubernetes-Operations

## Tenets of Kubernetes

```text

0. Homogeneity:   Abstracts vendor specific components into a neutral Model based on generic services, containers, resources.

1. Visibility:    This forces us to identify and expose Dependencies, to decouple systems in single-responsibility components.

2.Portability:    This allows containerisation, focused isolated apps serving well-catalogued services and their dependencies.

3. Automation:     With isolated, portable modular components, we can nautomate their runtime configuration and deployment.

4. Provision:      This gives us a grammar to Provision systems, to express desired topology, deployment, scale, resources.

5. Sequencing:     This forces us to expose dependency sequence rules, which are also expressed in neutral config and code.

6. Orchestration:  We use this grammar to express state changes, to manage distributed systems including their dependencies.

7. Monitoring:     The common model forces us to expose application health checks and telemetry, metrics, logging, tracing.

8. Reliability:    Apps abstracted in services which can be replicated and load-balanced for fault-tolerance and reliability.

9. Scalability:   This allows to scale to a given topology, to scale the topology on demand, or define policies to autoscale.

10. Migration:    This model allows to plan any migration or transition with full support for rollback and recovery.

11. Ecosystem:   	it is ubiquitous and has a vast ecosystem including all major cloud provides and open-source developers.

```
