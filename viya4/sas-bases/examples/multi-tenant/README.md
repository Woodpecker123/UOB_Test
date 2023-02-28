---
category: multiTenant
tocprty: 2
---

# Multi-tenant Deployment

## Overview

SAS Viya supports multiple tenants on a single deployment by enabling multi-tenancy. This README describes the steps 
required to enable multi-tenancy in your SAS Viya deployment.

## Instructions


To set up a multi-tenant deployment, perform the following steps. 

1. Copy `$deploy/sas-bases/examples/multi-tenant/sasdefault.yaml` to a new directory named 'multi-tenant' under your siteconfig directory. 
   For example:`$deploy/site-config/multi-tenant/`. Note the '{INGRESS_HOST}' value used in the zones.internal.hostnames 
   property of the sasdefault.yaml file should not be modified because it will be replaced automatically during deployment. 
 
2. SAS Viya supports two modes of data isolation (schemaPerApplicationTenant and databasePerTenant) for tenant data. 
schemaPerApplicationTenant specifies that a single database is shared by all tenants, but each tenant is partitioned 
into separate schemas based on the application or service. databasePerTenant specifies that a separate database 
instance is used for each tenant. The default mode is schemaPerApplicationTenant. 

   To use databasePerTenant mode, uncomment the line containing 'sas.multi.tenancy.db.mode' in your `$deploy/site-config/multi-tenant/sasdefault.yaml` file.

3. In the transformers block of the base kustomization.yaml file, add a reference to the 
sas-shared-configmap-transformer.yaml overlay:

```yaml
transformers:
...
- sas-bases/overlays/multi-tenant/sas-shared-configmap-transformer.yaml
...
```

4. In the secretGenerator block of the base kustomization.yaml file, include the sasdefault.yaml file in 
the sas-consul-config secret. Create the secretGenerator block if it does not already exist.
Here is an example:
   
```yaml
secretGenerator:
...
- name: sas-consul-config
  behavior: merge
  files:
  - SASDEFAULT_CONF=site-config/multi-tenant/sasdefault.yaml
...
```
