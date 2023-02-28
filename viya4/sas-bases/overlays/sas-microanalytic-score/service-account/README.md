---
category: SAS Micro Analytic Service
tocprty: 5
---

# Configure SAS Micro Analytic Service to Add Service Account

## Overview

This README describes how a service account with defined privileges may be added to sas-microanalytic-score pod. A service account is required in an OpenShift cluster if it needs to mount NFS. If the Python environment is made available through an NFS mount, the service account requires NFS volume mounting privilege.

**Note:** For information about using NFS to make Python available, see the README file at `/$deploy/sas-bases/examples/sas-open-source-config/python/README.md` (for Markdown format) or `/$deploy/sas-bases/docs/configure_python_for_sas_viya.htm` (for HTML format).

## Prerequisites

### Granting Security Context Constraints on an OpenShift Cluster

The `/$deploy/sas-bases/overlays/sas-microanalytic-score/service-account` directory contains a file to grant Security Context Constraints for using NFS on an OpenShift cluster.

A Kubernetes cluster administrator should add these Security Context Constraints 
to their OpenShift cluster prior to deploying SAS Viya 4. Use one of the 
following commands:

```yaml
kubectl apply -f sas-microanalytic-score-scc.yaml
```

or

```yaml
oc create -f sas-microanalytic-score-scc.yaml
```

### Bind the SCC to a ServiceAccount

After the SCC has been applied, you must link the SCC to the appropriate ServiceAccount that will use it. Perform the following command:

```yaml
oc -n {{ NAME-OF-NAMESPACE }} adm policy add-scc-to-user sas-microanalytic-score -z sas-microanalytic-score
```

## Installation

1. Make the following changes to the kustomization.yaml file in the $deploy directory:

   * Add sas-bases/overlays/sas-microanalytic-score/service-account/sa.yaml to the resources block.
   * Add sas-bases/overlays/sas-microanalytic-score/service-account/sa-transformer.yaml to the transformers block.
 
   Here is an example:

   ```yaml
   resources:
   - sas-bases/overlays/sas-microanalytic-score/service-account/sa.yaml

   transformers:
   - sas-bases/overlays/sas-microanalytic-score/service-account/sa-transformer.yaml
   ```

2. Complete the deployment steps to apply the new settings. See [Deploy the Software](http://documentation.sas.com/?cdcId=itopscdc&cdcVersion=default&docsetId=dplyml0phy0dkr&docsetTarget=p127f6y30iimr6n17x2xe9vlt54q.htm) in _SAS Viya: Deployment Guide_.

   **Note:** This overlay can be applied during the initial deployment of SAS Viya or after the deployment of SAS Viya.
   
   * If you are applying the overlay during the initial deployment of SAS Viya, complete all the tasks in the README files that you want to use, then run `kustomize build` to create and apply the manifests.
   * If the overlay is applied after the initial deployment of SAS Viya, run `kustomize build` to create and apply the manifests.
           
## Post-Installation Tasks

### Verify the service account configuration

1. Run the following command to verify whether the overlay has been applied:

   ```sh
   kubectl get pod  <sas-microanalyticscore-pod-name> -o yaml  -n <name-of-namespace>
   ```
   
2. Verify that the output contains the service account sas-microanalytic-score in the spec section.

   ```yaml
   spec:
     serviceAccountName: sas-microanalytic-score

   ```