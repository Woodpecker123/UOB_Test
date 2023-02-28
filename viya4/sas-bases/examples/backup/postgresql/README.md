---
category: backupRestore
tocprty: 3
---

# Configuration Settings for PostgreSQL Backup

## Overview

This readme describes how to revise and apply the settings available for
backing up PostgreSQL.

## Add Additional Options for PostgreSQL Backup Command

If you need to add or change any option for PostgreSQL backup command (pg_dump), add an entry to the sas-backup-job-parameters configMap in the configMapGenerator block of the (`$deploy/kustomization.yaml`) file.

```yaml
configMapGenerator:
- name: sas-backup-job-parameters
  behavior: merge
  literals:
  - SAS_DATA_SERVER_BACKUP_ADDITIONAL_OPTIONS={{ OPTION-1-NAME OPTION-1-VALUE }},{{ FLAG-1 }},{{ OPTION-2-NAME OPTION-2-VALUE }}
```
The {{ OPTION-NAME OPTION-VALUE }} and {{ FLAG }} variables should be a comma-separated list of options to be added, such as `-Z 0,--version`.

If the sas-backup-job-parameters configMap is already present in the (`$deploy/kustomization.yaml`) file, you should add the last line only. If the configMap is not present, add the entire example.