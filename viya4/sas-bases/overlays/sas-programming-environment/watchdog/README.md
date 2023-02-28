---
category: sasProgrammingEnvironment
tocprty: 8
---

# Configuring SAS Compute Server to Use SAS Watchdog

## Overview

The SAS Compute Server provides the ability to execute SAS Watchdog, which
monitors spawned processes to ensure that they comply with the terms of LOCKDOWN system option.

SAS Watchdog emulates the restrictions imposed by LOCKDOWN by restricting access only to
files that exist in folders that are allowed by LOCKDOWN.

**Note:** For more information about the LOCKDOWN system option, see [LOCKDOWN System Option](http://documentation.sas.com/?cdcId=sasadmincdc&cdcVersion=default&docsetId=calsrvpgm&docsetTarget=p04d9diqt9cjqnn1auxc3yl1ifef.htm&docsetTargetAnchor=p0sshm6ekdjiafn1jm5o0as6dsdr&locale=en)

This README file describes how to customize your SAS Viya deployment to allow
SAS Compute Server to run SAS Watchdog.

**Note:** The README for SAS Watchdog is located at `$deploy/sas-bases/examples/sas-programming-environment/watchdog/README.md` (for Markdown format) or `$deploy/sas-bases/doc/configuring_sas_compute_server_to_use_watchdog.htm` (for HTML format).

## Installation

Enable the ability for the pod where the SAS Compute
Server is running to run SAS Watchdog. SAS Watchdog starts when the SAS
Compute Server is started, and exists for the life of
the SAS Compute Server.

### Enable SAS Watchdog in the SAS Compute Server

SAS has provided an overlay to enable SAS Watchdog in your environment.

To use the overlay:

1. Add a reference to the `sas-programming-environment/watchdog` overlay to the transformers block of the base kustomization.yaml file (`$deploy/kustomization.yaml`).

   Here is an example:

   ```yaml
   ...
   transformers:
   ...
   - sas-bases/overlays/sas-programming-environment/watchdog
   - sas-bases/overlays/required/transformers.yaml
   ...
   ```

   **NOTE:** The reference to the `sas-programming-environment/watchdog` overlay **MUST** come before the required transformers.yaml, as seen in the example above.

2. Deploy the software using the commands in
[SAS Viya: Deployment Guide](http://documentation.sas.com/?cdcId=itopscdc&cdcVersion=default&docsetId=dplyml0phy0dkr&docsetTarget=titlepage.htm).

### Disabling SAS Watchdog in the SAS Compute Server

To disable SAS Watchdog:

1. Remove `sas-bases/overlays/sas-programming-environment/watchdog`
from the transformers block of the base kustomization.yaml file (`$deploy/kustomization.yaml`).

2. Deploy the software using the commands in
[SAS Viya: Deployment Guide](http://documentation.sas.com/?cdcId=itopscdc&cdcVersion=default&docsetId=dplyml0phy0dkr&docsetTarget=titlepage.htm).

## Additional Instructions for an OpenShift Environment

### Apply Security Context Constraint (SCC)

As a Kubernetes cluster administrator of the OpenShift cluster, use one of the following commands to apply the Security Context Constraint. An example of the yaml may be found in `sas-bases/examples/sas-programming-environment/watchdog/sas-watchdog-scc.yaml`.

```console
kubectl apply -f sas-watchdog-scc.yaml
```

```console
oc apply -f sas-watchdog-scc.yaml
```

### Grant the Service Account Use of the SCC

```console
oc -n <namespace> adm policy add-scc-to-user sas-watchdog -z sas-programming-environment
```

### Remove the Service Account from the SCC

Run the following command to remove the service account from the SCC:

```console
oc -n <namespace> adm policy remove-scc-from-user sas-watchdog -z sas-programming-environment
```

### Delete the SCC

Run one of the following commands to delete the SCC after it has been removed:

```console
kubectl delete scc sas-watchdog
```

```console
oc delete scc sas-watchdog
```

**NOTE:** Do not delete the SCC if there are other SAS Viya deployments in the cluster.  Only delete the SCC after all namespaces running SAS Viya in the cluster have been removed.