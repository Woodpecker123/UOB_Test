---
category: backupRestore
tocprty: 13
---

# Configuration Settings for SAS Viya Restore

## Overview

This readme describes how to revise and apply the settings available for configuring restore jobs.

## Change Restore Job Timeout

To change the restore job timeout value, edit the `$deploy/kustomization.yaml` file by adding an entry for the sas-restore-job-parameters configMap in the configMapGenerator block. The entry uses the following format, where {{ TIMEOUT-IN-MINUTES }} is an integer.

```yaml
configMapGenerator:
- name: sas-restore-job-parameters
  behavior: merge
  literals:
  - JOB_TIME_OUT={{ TIMEOUT-IN-MINUTES }}
```

If the sas-restore-job-parameters configMap is already present in the base kustomization.yaml file, you should add the last line only. If the configMap is not present, add the entire example.

## Filtering Configuration Definition Properties

To skip the restore of the configuration definition properties, edit the `$deploy/kustomization.yaml` file by adding an entry for the sas-restore-job-parameters configMap in the configMapGenerator block. The entry uses the following format. 

```yaml
configMapGenerator:
- name: sas-restore-job-parameters
  behavior: merge
  literals:
  - RESTORE_DEFINITION_FILTER={{ RESTORE-DEFINITION-FILTER-CSV }}
```

The {{ RESTORE-DEFINITION-FILTER-CSV }} is a json string containing the comma-separated list of 'key:value' pairs where key is in the form 'serviceName.definitionName.version' and value itself can be a comma-separated list of properties to be filtered. If entire definition is to be excluded, then set the value to '*'. If service name is not present in the definition then only provide 'definitionName'. Each key and value must be enclosed in double quotes ("). Here is an example

 ```yaml
configMapGenerator:
- name: sas-restore-job-parameters
  behavior: merge
  literals:
  - RESTORE_DEFINITION_FILTER='{"sas.dataserver.common.1":"*","deploymentBackup.sas.deploymentbackup.1":"*","deploymentBackup.sas.deploymentbackup.2":"*","deploymentBackup.sas.deploymentbackup.3":"*","sas.security.1":"*","vault.sas.vault.1":"*","vault.sas.vault.2":"*","SASDataExplorer.sas.dataexplorer.1":"*","SASLogon.sas.logon.sas9.1":"*","sas.cache.1":"*","sas.cache.2":"*","sas.cache.3":"*","sas.cache.4":"*","identities-SASLogon.sas.identities.providers.ldap.user.1":"accountId,address.country","SASLogon.sas.logon.saml.providers.external_saml.1":"assertionConsumerIndex,idpMetadata"}'
```

If the sas-restore-job-parameters configMap is already present in the base kustomization.yaml file, you should add the last line only. If the configMap is not present, add the entire example.

## Filtering Configuration Properties

To skip the restore of the configuration properties, edit the `$deploy/kustomization.yaml` file by adding an entry for the sas-restore-job-parameters configMap in the configMapGenerator block. The entry uses the following format.

```yaml
configMapGenerator:
- name: sas-restore-job-parameters
  behavior: merge
  literals:
  - RESTORE_CONFIGURATION_FILTER={{ RESTORE-CONFIGURATION-FILTER-CSV }}
```

The {{ RESTORE-CONFIGURATION-FILTER-CSV }} is a json string containing the comma-separated list of 'key:value' pairs where key is in the form 'serviceName.configurationMediaType' and value itself can be a comma-separated list of properties to be filtered. If the entire configuration is to be excluded, then set the value to '*'. If service name is not present in the configuration, then use the media type. Each key and value must be enclosed in double quotes ("). Here is an example

 ```yaml
configMapGenerator:
- name: sas-restore-job-parameters
  behavior: merge
  literals:
  - RESTORE_CONFIGURATION_FILTER='{"postgres.application/vnd.sas.configuration.config.sas.dataserver.conf+json;version=1":"*","maps-reportPackages-webDataAccess.application/vnd.sas.configuration.config.sas.maps+json;version=2":"useArcGISOnlineMaps,localEsriServicesUrl"}'
```

If the sas-restore-job-parameters configMap is already present in the base kustomization.yaml file, you should add the last line only. If the configMap is not present, add the entire example.

## Disable Restore Job Failure Notification

By default, you are notified if the restore job fails. To disable restore job failure notification, add an entry to the sas-restore-job-parameters configMap in the configMapGenerator block of the base kustomization.yaml file. Replace {{ ENABLE-NOTIFICATIONS }} with the string "false".

```yaml
configMapGenerator:
- name: sas-restore-job-parameters
  behavior: merge
  literals:
  - ENABLE_NOTIFICATIONS={{ ENABLE-NOTIFICATIONS }}
```
If the sas-restore-job-parameters configMap is already present in the base kustomization.yaml file, add the last line only. If the configMap is not present, add the entire example.

To restore the default, change the value of {{ ENABLE-NOTIFICATIONS }} from "false" to "true".

## Modify the Resources of the Restore Job

In multi-tenant scenario, the default resources may not be sufficient for completion or successful execution of the restore job,
resulting in the pod status being marked as OOMKilled. In this case, modify the resources to the values you desire.

1. Copy the file `$deploy/sas-bases/examples/restore/configure/sas-restore-job-modify-resources-transformer.yaml`
to a location of your choice under `$deploy/site-config`, such as `$deploy/site-config/restore`.

2. In the copied file, replace {{ CPU-LIMIT }} with the desired value of CPU.
{{ CPU-LIMIT }} must be a non-zero and non-negative numeric value, such as "3" or "5".
You can specify fractional values for the CPUs by using decimals, such as "1.5" or "0.5".

3. In the same file, replace {{ MEMORY-LIMIT }} with the desired value of memory.
{{ MEMORY-LIMIT }} must be a non-zero and non-negative numeric value followed by "Gi". For example, "8Gi" for 8 gigabytes.

4. Add the full path of the copied file to the transformers block of the base
kustomization.yaml file (`$deploy/kustomization.yaml`). For example, if you
moved the file to `$deploy/site-config/restore`, you would modify the
base kustomization.yaml file like this:

   ```
   ...
   transformers:
   ...
   - site-config/restore/sas-restore-job-modify-resources-transformer.yaml
   ...
   ```
5. Build the manifest:
kustomize build -o site.yaml

6. Apply the manifest:
kubectl apply -f site.yaml