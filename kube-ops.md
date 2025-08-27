# Kubernetes-Operations

## Tenets of Kubernetes



```text

0. Neutrality:    Kubernetes is a neutral abstract Meta-Cloud used to unify different vendor-specific Cloud Infrastructures.

1. Heterogenity:  It uses a modular plugin architecture, with vendor-specific implementation wired as standard plugins.

2. Homogeneity:   The Implementation uses plugins, but they all speak a unified Specification based on an abstract Model.

3. Flexibility:   The model is based on a Configuration and grammar in which are Injected runtime environment values.

4. Security:      The model describes abstract RBAC based roles and manages unified secrets to be injected in components.

5. Isolation:     It forces us to identify, isolate, and break down complex systems into single-responsibility components.

4. Discovery:    This in turn forces us to identify and expose the intriticate dependencies between these components.

6. Containers:    Once decoupled, isolated applications become ideal candidates for virtualisation, aka containerisation.

7. Portability:   Containers are catalogued into services, configurations, and dependencies which can be deployed anywhere.

8. Virtualisation:  This means we can decouple apps from machines, resources, services and run them on separate nodes.

9. Automation:     With isolated, portable modular components, we can automate their runtime configuration and deployment.

10. Sequencing:    This forces us to expose dependency sequence rules, which are also expressed in neutral config and code.

11. Replication:   We can then run pools of apps, all implementing the same service, replicated over availability zones.

12. Efficicency:   with virtual containers we can reallocate resources as needed and unburden loads to other idle machines.

13. Clustering:    Now With sequencing rules, we can now run pool of replicated inter-dependent services, in clusters.

14. Provision:     This gives us a grammar to Provision systems, to express desired topology, deployment, scale, resources.

15. Orchestration:  We use this grammar to express state changes, to manage complex systems including their dependencies.

16. Predicability:  Tracking a predictable state means we can try things out, and rollback, recover gracefully of needed.

17. Monitoring:    The common model forces us to implement a standard for health checks, metrics, logging, and tracing.

18. Resiliency:   Monitored Health Checks means the system is now self-healing, it can restart unresponsive containers.

19. Reliability:  Monitored Apps can then be restarted, replicated, and load-balanced for fault-tolerance and reliability.

20. Scalability:  This allows to scale to a given topology, to scale on demand, or can define policies to auto-scale.

21. Observability:  This also means that the entire stack conforms to well-instrumented observability and telemetry.

22. Migration:    This model allows to plan any migration or transition with full support for rollback and recovery.

23. Federation:   As other vendors also speak Kubernetes, it is easy to federate Hybrid-Cloud and Multi-Cloud systems.

24. Separation:   We can spin up new Environments and split shards for processing for Canary Testing or Capacity overflow.

25. Ecosystem:   	it is ubiquitous and has a vast ecosystem including all major cloud provides and open-source developers.

```
