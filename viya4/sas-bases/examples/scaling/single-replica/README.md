---
category: haAndScaling
tocprty: 7
---

# Single Replica Scaling SAS Viya


## Overview

SAS Viya deploys stateful components in a High Availability configuration by
default. This feature requires additional resources to run and if it is not 
needed can be disabled. Do not apply this to an already configured environment.

It will trigger outages during updates as the single replica components update. 

- RabbitMQ
- Consul
- internal instances of PostgreSQL


## Installation


A series of kustomize transformers will modify the appropriate SAS Viya deployment 
components to a single replica mode.

Add `sas-bases/overlays/scaling/single-replica/transformer.yaml` to the
transformers block in your base kustomization.yaml file. Here is an example:

```yaml
...
transformers:
...
- sas-bases/overlays/scaling/single-replica/transformer.yaml
```

To apply the change, run `kustomize build -o site.yaml`

