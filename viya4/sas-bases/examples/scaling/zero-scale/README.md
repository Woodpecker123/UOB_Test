---
category: haAndScaling
tocprty: 7
---

# Zero Scaling SAS Viya

## Overview

SAS Viya has the capability to scale to zero the following processes. Scaling
down a process also shuts it down.

- microservices
- cron jobs
- daemonsets
- stateful services
  - RabbitMQ
  - Consul
  - CAS
  - internal instances of PostgreSQL
  - Redis

When scaling down is complete, any storage provisioned by Kubernetes for SAS
Viya will still be active so the system can be scaled back up again.
Additionally, scaling down does not stop active compute jobs.

## Scale Down Process

### Initial Phase (Phase 0)

A series of kustomize transformers will scale the SAS Viya deployment to zero
and back again. Note that even though SAS performs an ordered shutdown, this
test ensures the operators are available to shut down the resources they own.

Add `sas-bases/overlays/scaling/zero-scale/phase-0-transformer.yaml` to the
transformers block in your base kustomization.yaml file. Here is an example:

```yaml
...
transformers:
...
- sas-bases/overlays/scaling/zero-scale/phase-0-transformer.yaml
```

To apply the change, run `kustomize build -o site.yaml`, then apply the updated
`site.yaml` file to your deployment by running `kubectl apply --selector="sas.com/admin!=cluster-api" -f site.yaml`.

After the deployment update has been applied, make sure that all CAS pods have
terminated by running the following command as an administrator with namespace
permissions:

```sh
kubectl -n <name-of-namespace> get pods --selector='app.kubernetes.io/managed-by=sas-cas-operator'
```

If the command's output is
`No resources found in <name-of-namespace> namespace.` then all CAS pods have
terminated, and you may continue to the next phase. Run the command until you
receive the expected output before continuing to the next phase.

SAS Event Stream Processing projects are dynamically created via the ESP
Operator using a custom resource named ESPServer. ESPServer allows users to
control the number of replicas of a ESP project by overriding the default value
specified in the custom resource ESPConfig. To scale it down, delete the
ESPServer:

```sh
kubectl delete espserver -n <name-of-namespace> --all
```

If you have internal instance of PostgreSQL, ensure all PostgreSQL pods have
terminated by running the following command as an administrator with namespace
permissions:

```sh
kubectl -n <name-of-namespace> wait --for=delete --selector="postgres-operator.crunchydata.com/data" pods
```

### Phase 1

Add the `sas-bases/overlays/scaling/zero-scale/phase-1-transformer.yaml` to the
transformers block in your base kustomization.yaml file.

```yaml
...
transformers:
...
- sas-bases/overlays/scaling/zero-scale/phase-0-transformer.yaml
- sas-bases/overlays/scaling/zero-scale/phase-1-transformer.yaml
```

To apply the change, run `kustomize build -o site.yaml`, then apply the updated
`site.yaml` to your deployment by running `kubectl apply --selector="sas.com/admin!=cluster-api" -f site.yaml`.

## Scale Up Process

Run the following command as an administrator with namespace permissions:

```sh
kubectl -n <name-of-namespace> scale deployment --selector=sas.com/zero-scale-phase=1 --replicas=1
```

Check and wait until operators are running and ready with the following command:

```sh
kubectl -n <name-of-namespace> get deployment --selector=sas.com/zero-scale-phase=1
```

Remove the two transformers you added in the scale-down phase 1 steps. Run
`kustomize build -o site.yaml`, then apply the updated `site.yaml` file to your
deployment by running `kubectl apply --selector="sas.com/admin!=cluster-api" -f site.yaml`.
