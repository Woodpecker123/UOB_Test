---
category: cas
tocprty: 13
---

# State Transfer for CAS Server for SAS Viya

## Overview

This directory contains files to Kustomize your SAS Viya deployment to enable state transfers.
Enabling state transfers allows the sessions, tables, and state of a running CAS server to be preserved
between a running CAS server and a new CAS server instance which will be started as part of the CAS server upgrade.

## Instructions

### Edit the kustomization.yaml File

To add the new CAS server to your deployment:

1. Add a reference to the `state-transfer` overlay to the resources block of the base
kustomization.yaml file (`$deploy/kustomization.yaml`).  This overlay adds a PVC to the deployment
to store the temporary state data during a state transfer.  If you need to increase the size of the
transfer PVC, consider using the `cas-modify-pvc-storage.yaml` example file.

   ```yaml
   resources:
   ...
   - sas-bases/overlays/cas-server/state-transfer
   ```

2. Add the state-transfer transformer to enable the state transfer feature to the deployment

   ```yaml
   transformers:
   ...
   - sas-bases/overlays/cas-server/state-transfer/support-state-transfer.yaml
   ```

## Build

After you configure Kustomize, continue your SAS Viya deployment as documented.
