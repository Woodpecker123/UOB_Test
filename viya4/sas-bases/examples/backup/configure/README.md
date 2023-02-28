---
category: backupRestore
tocprty: 2
---

# Configuration Settings for SAS Viya Backup

## Overview

This readme describes how to revise and apply the settings available for
configuring backup jobs.

## Change the StorageClass for PersistentVolumeClaims Used for Storing Backups

If you want to retain the PersistentVolumeClaim (PVC) used for backup when the namespace is deleted,
then use a StorageClass with a ReclaimPolicy of'Retain' as the backup PVC.

1.  Copy the file `$deploy/sas-bases/examples/backup/configure/sas-common-backup-data-storage-class-transformer.yaml`
to a location of your choice under `$deploy/site-config`, such as `$deploy/site-config/backup`.

2. Follow the instructions in the copied sas-common-backup-data-storage-class-transformer.yaml
file to change the values in that file as necessary.

3. Add the full path of the copied file to the transformers block of the base
kustomization.yaml file (`$deploy/kustomization.yaml`). For example, if you
moved the file to `$deploy/site-config/backup`, you would modify the
base kustomization.yaml file like this:

   ```
   ...
   transformers:
   ...
   - site-config/backup/sas-common-backup-data-storage-class-transformer.yaml
   ...
   ```

## Change the Storage Size for the `sas-common-backup-data` PersistentVolumeClaim

1.  Copy the file `$deploy/sas-bases/examples/backup/configure/sas-common-backup-data-storage-size-transformer.yaml`
to a location of your choice under `$deploy/site-config`, such as `$deploy/site-config/backup`.

2. Follow the instructions in the copied sas-common-backup-data-storage-size-transformer.yaml
file to change the values in that file as necessary.

3. Add the full path of the copied file to the transformers block of the base
kustomization.yaml file (`$deploy/kustomization.yaml`). For example, if you
moved the file to `$deploy/site-config/backup`, you would modify the
base kustomization.yaml file like this:

   ```
   ...
   transformers:
   ...
   - site-config/backup/sas-common-backup-data-storage-size-transformer.yaml
   ...
   ```

## Change the Default Backup Schedule to a Custom Schedule

By default, the backup is run once per week on Sundays at 1:00 a.m. Use 
the following instructions to schedule a backup more suited to your resources.

1. Copy the file `$deploy/sas-bases/examples/backup/configure/sas-scheduled-backup-job-change-default-backup-transformer.yaml`
to a location of your choice under `$deploy/site-config`, such as `$deploy/site-config/backup`.

2. Replace {{ SCHEDULE-BACKUP-CRON-EXPRESSION }} with the cron expression for the desired schedule in the copied sas-scheduled-backup-job-change-default-backup-transformer.yaml.

3. Add the full path of the copied file to the transformers block of the base
kustomization.yaml file (`$deploy/kustomization.yaml`). For example, if you
moved the file to `$deploy/site-config/backup`, you would modify the
base kustomization.yaml file like this:

   ```
   ...
   transformers:
   ...
   - site-config/backup/sas-scheduled-backup-job-change-default-backup-transformer.yaml
   ...
   ```
4. Build the manifest:
kustomize build -o site.yaml

5. Apply the manifest:
kubectl apply -f site.yaml

## Modify the Resources for the Backup Job

If the default resources are not sufficient for the completion or successful execution of the backup job, modify the resources to the values you desire.

1. Copy the file `$deploy/sas-bases/examples/backup/configure/sas-backup-job-modify-resources-transformer.yaml`
to a location of your choice under `$deploy/site-config`, such as `$deploy/site-config/backup`.

2. In the copied file, replace {{ CPU-LIMIT }} with the desired value of CPU.
{{ CPU-LIMIT }} must be a non-zero and non-negative numeric value, such as "3" or "5".
You can specify fractional values for the CPUs by using decimals, such as "1.5" or "0.5".

3. In the same file, replace {{ MEMORY-LIMIT }} with the desired value of memory.
{{ MEMORY-LIMIT }} must be a non-zero and non-negative numeric value followed by "Gi". For example, "8Gi" for 8 gigabytes.

4. Add the full path of the copied file to the transformers block of the base
kustomization.yaml file (`$deploy/kustomization.yaml`). For example, if you
moved the file to `$deploy/site-config/backup`, you would modify the
base kustomization.yaml file like this:

   ```
   ...
   transformers:
   ...
   - site-config/backup/sas-backup-job-modify-resources-transformer.yaml
   ...
   ```
5. Build the manifest:
kustomize build -o site.yaml

6. Apply the manifest:
kubectl apply -f site.yaml

## Modify the Resources of the Scan Job

If the default resources are not sufficient for the completion or successful execution of the scan job, modify the resources to the values you desire.

1. Copy the file `$deploy/sas-bases/examples/backup/configure/sas-scan-job-modify-resources-transformer.yaml`
to a location of your choice under `$deploy/site-config`, such as `$deploy/site-config/backup`.

2. In the copied file, replace {{ CPU-LIMIT }} with the desired value of CPU.
{{ CPU-LIMIT }} must be a non-zero and non-negative numeric value, such as "3" or "5".
You can specify fractional values for the CPUs by using decimals, such as "1.5" or "0.5".

3. In the same file, replace {{ MEMORY-LIMIT }} with the desired value of memory.
{{ MEMORY-LIMIT }} must be a non-zero and non-negative numeric value followed by "Gi". For example, "8Gi" for 8 gigabytes.

4. Add the full path of the copied file to the transformers block of the base
kustomization.yaml file (`$deploy/kustomization.yaml`). For example, if you
moved the file to `$deploy/site-config/backup`, you would modify the
base kustomization.yaml file like this:

   ```
   ...
   transformers:
   ...
   - site-config/backup/sas-scan-job-modify-resources-transformer.yaml
   ...
   ```
5. Build the manifest:
kustomize build -o site.yaml

6. Apply the manifest:
kubectl apply -f site.yaml

## Modify the Resources of the Backup Copy Job

If the default resources are not sufficient for the completion or successful execution of the backup copy job, modify the resources to the values you desire.

1. Copy the file `$deploy/sas-bases/examples/backup/configure/sas-backup-copy-job-modify-resources-transformer.yaml`
to a location of your choice under `$deploy/site-config`, such as `$deploy/site-config/backup`.

2. In the copied file, replace {{ CPU-LIMIT }} with the desired value of CPU.
{{ CPU-LIMIT }} must be a non-zero and non-negative numeric value, such as "3" or "5".
You can specify fractional values for the CPUs by using decimals, such as "1.5" or "0.5".

3. In the same file, replace {{ MEMORY-LIMIT }} with the desired value of memory.
{{ MEMORY-LIMIT }} must be a non-zero and non-negative numeric value followed by "Gi". For example, "8Gi" for 8 gigabytes.

4. Add the full path of the copied file to the transformers block of the base
kustomization.yaml file (`$deploy/kustomization.yaml`). For example, if you
moved the file to `$deploy/site-config/backup`, you would modify the
base kustomization.yaml file like this:

   ```
   ...
   transformers:
   ...
   - site-config/backup/sas-backup-copy-job-modify-resources-transformer.yaml
   ...
   ```
5. Build the manifest:
kustomize build -o site.yaml

6. Apply the manifest:
kubectl apply -f site.yaml

## Modify the Resources of the Backup Agent Container in the CAS Controller Pod

If the default resources are not sufficient for the completion or successful execution of the CAS controller pod, modify the resources of backup agent container of CAS controller pod to the values you desire.

1. Copy the file `$deploy/sas-bases/examples/backup/configure/sas-cas-server-backup-agent-modify-resources-transformer.yaml`
to a location of your choice under `$deploy/site-config`, such as `$deploy/site-config/backup`.

2. In the copied file, replace {{ CPU-LIMIT }} with the desired value of CPU.
{{ CPU-LIMIT }} must be a non-zero and non-negative numeric value, such as "3" or "5".
You can specify fractional values for the CPUs by using decimals, such as "1.5" or "0.5".

3. In the same file, replace {{ MEMORY-LIMIT }} with the desired value of memory.
{{ MEMORY-LIMIT }} must be a non-zero and non-negative numeric value followed by "Gi". For example, "8Gi" for 8 gigabytes.

4. By default the patch will be applied to all the CAS servers. If the patch transformer is being applied to a single CAS server, replace {{ NAME-OF-CAS-SERVER }} with the named CAS server in the same file and comment out the lines 'name: .*' and 'labelSelector: "sas.com/cas-server-default"' with a hashtag (#).

5. Add the full path of the copied file to the transformers block of the base
kustomization.yaml file (`$deploy/kustomization.yaml`). For example, if you
moved the file to `$deploy/site-config/backup`, you would modify the
base kustomization.yaml file like this:

   ```
   ...
   transformers:
   ...
   - site-config/backup/sas-cas-server-backup-agent-modify-resources-transformer.yaml
   ...
   ```
6. Build the manifest:
kustomize build -o site.yaml

7. Apply the manifest:
kubectl apply -f site.yaml

## Change Backup/Scan Job Timeout

If you need to change the backup job timeout value, add an entry to the sas-backup-job-parameters configMap in the configMapGenerator block of the base kustomization.yaml file. The entry uses the following format, where {{ TIMEOUT-IN-MINUTES }} is an integer

```yaml
configMapGenerator:
- name: sas-backup-job-parameters
  behavior: merge
  literals:
  - JOB_TIME_OUT={{ TIMEOUT-IN-MINUTES }}
```

If the sas-backup-job-parameters configMap is already present in the base kustomization.yaml file, you should add the last line only. If the configMap is not present, add the entire example.

## Change Backup Retention Period

If you need to change the backup retention period, add an entry to the sas-backup-job-parameters configMap in the configMapGenerator block of the base kustomization.yaml file. The entry uses the following format, where {{ RETENTION-PERIOD-IN-DAYS }} is an integer.

```yaml
configMapGenerator:
- name: sas-backup-job-parameters
  behavior: merge
  literals:
  - RETENTION_PERIOD={{ RETENTION-PERIOD-IN-DAYS }}
```
If the sas-backup-job-parameters configMap is already present in the base kustomization.yaml file, you should add the last line only. If the configMap is not present, add the entire example.

## Back Up Additional Consul Properties

If you want to back up additional consul properties, keys can be added to the sas-backup-agent-parameters configMap in the base kustomization.yaml file. To add keys, add a data block to the configMap. If the sas-backup-agent-parameters configMap is already included in your base kustomization.yaml file, you should add the last line only. If the configMap isn't included, add the entire block.

```yaml
configMapGenerator:
- name: sas-backup-agent-parameters
  behavior: merge
  literals:
  - BACKUP_ADDITIONAL_GENERIC_PROPERTIES="{{ CONSUL-KEY-LIST }}"
```

 The {{ CONSUL-KEY-LIST }} should be a comma-separated list of properties to be backed up. Here is an example: 

```yaml
configMapGenerator:
- name: sas-backup-agent-parameters
  behavior: merge
  literals:
  - BACKUP_ADDITIONAL_GENERIC_PROPERTIES="config/files/sas.files/maxFileSize,config/files/sas.files/blockedTypes"
```
## Back Up Additional Consul Properties For Tenants

If you want to back up additional consul properties for tenants, keys can be added to the sas-backup-agent-parameters configMap in the base kustomization.yaml file. To add keys, add a data block to the configMap. If the sas-backup-agent-parameters configMap is already included in your base kustomization.yaml file, you should add the last line only. If the configMap isn't included, add the entire block.

```yaml
configMapGenerator:
- name: sas-backup-agent-parameters
  behavior: merge
  literals:
  - BACKUP_ADDITIONAL_TENANT_PROPERTIES="{{ CONSUL-KEY-LIST }}"
```

 The {{ CONSUL-KEY-LIST }} should be a comma-separated list of properties to be backed up for each tenant. Each property must include the '&lt;tenantID&gt;' as a placeholder for tenantID. Here is an example:

```yaml
configMapGenerator:
- name: sas-backup-agent-parameters
  behavior: merge
  literals:
  - BACKUP_ADDITIONAL_TENANT_PROPERTIES="config/files/sas.files/tenants.<tenantID>.maxFileSize,config/files/sas.files/<tenantID>.blockedTypes"
```
## Exclude Specific Folders and Files During file system Backup

To exclude specific folders and files during file system backup, add an entry to the sas-backup-job-parameters configMap in the configMapGenerator block of the base kustomization.yaml file. If the sas-backup-job-parameters configMap is already included in your base kustomization.yaml file, you should add the last line only. If the configMap isn't included, add the entire block.

```yaml
configMapGenerator:
- name: sas-backup-job-parameters
  behavior: merge
  literals:
  - FILESYSTEM_BACKUP_EXCLUDELIST="{{ EXCLUDE_PATTERN }}"
```

The {{ EXCLUDE_PATTERN }} should be a comma-separated list of patterns for files or folders to be excluded from the backup.
Here is an example that excludes all the files with extensions ".tmp" or ".log":


```yaml
configMapGenerator:
- name: sas-backup-job-parameters
  behavior: merge
  literals:
  - FILESYSTEM_BACKUP_EXCLUDELIST="*.tmp,*.log"
```
## Disable Backup Job Failure Notification

By default, you are notified if the backup job fails. To disable backup job failure notification, add an entry to the sas-backup-job-parameters configMap in the configMapGenerator block of the base kustomization.yaml file. Replace {{ ENABLE-NOTIFICATIONS }} with the string "false".

```yaml
configMapGenerator:
- name: sas-backup-job-parameters
  behavior: merge
  literals:
  - ENABLE_NOTIFICATIONS={{ ENABLE-NOTIFICATIONS }}
```
If the sas-backup-job-parameters configMap is already present in the base kustomization.yaml file, add the last line only. If the configMap is not present, add the entire example.

To restore the default, change the value of {{ ENABLE-NOTIFICATIONS }} from "false" to "true".

## Back Up Specific Set of Tenants

To back up a specific set of tenants, then add the list of tenants to be backed up to the sas-backup-job-parameters configMap in the configMapGenerator block of the base kustomization.yaml file. The entry uses the following format, where {{ TENANT-LIST }} is a comma-separated list of tenant IDs to be backed up.

```yaml
configMapGenerator:
- name: sas-backup-job-parameters
  behavior: merge
  literals:
  - TENANTS={{ TENANT-LIST }}
```
If the sas-backup-job-parameters configMap is already present in the base kustomization.yaml file, you should add the last line only. If the configMap is not present, add the entire example.