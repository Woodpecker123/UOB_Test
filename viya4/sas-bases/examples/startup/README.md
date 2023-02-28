---
category: SAS Startup Sequencer
tocprty: 1
---

# Controlling SAS Viya Start-Up Sequence

## Overview

Although SAS Viya comprises components that are designed to start in any order, in some scenarios it is more efficient for the components to start in an ordered sequence.

The transformers within the ordered-startup-transformer.yaml file insert an Init Container into the pods within the Deployments and StatefulSets within SAS Viya.  The Init Container ensures that a predetermined, ordered start-up sequence is respected by forcing a pod's start-up to wait until that particular pod can be efficiently started relative to the other pods.  The Init Container gracefully exits when it detects the appropriate time to start its accompanying pod, which allows the pod to start.

This design ensures that certain components start before others and allows Kubernetes to pull container Images in a priority-based sequence.  This design also provides a degree of resource optimization, in that resources are more efficiently spent during SAS Viya start-up with a priority given to starting essential components first.

## Installation

Add `sas-bases/overlays/startup/ordered-startup-transformer.yaml` to the transformers block in your base kustomization.yaml (`$deploy/kustomization.yaml`) file.  Ensure that ordered-startup-transformer.yaml is listed before `sas-bases/overlays/required/transformers.yaml`.

Here is an example:

```yaml
...
transformers:
...
- sas-bases/overlays/startup/ordered-startup-transformer.yaml
- sas-bases/overlays/required/transformers.yaml
```

To apply the change, perform the appropriate steps at [Deploy the Software](https://go.documentation.sas.com/doc/en/itopscdc/v_018/dplyml0phy0dkr/p127f6y30iimr6n17x2xe9vlt54q.htm).
