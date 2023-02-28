---
category: dataServer
tocprty: 16
---

# Configuration Settings for PostgreSQL Backups

## Overview

PostgreSQL backups play a vital role in disaster recovery. Automatically scheduled backups and backup retention policies prevent unnecessary storage accumulation and further support disaster recovery. SAS installs Crunchy Data PostgreSQL servers with automatically scheduled backups and a retention policy. This README describes how to change the scheduling of these backups.

## Installation

1. Copy the file `$deploy/sas-bases/examples/crunchydata/backups/crunchy-backup-transformer.yaml` into your `$deploy/site-config/crunchydata/` directory.

2. Adjust the values in your copied file following the in-line comments.

3. Add a reference to the file in the transformers block of the base kustomization.yaml (`$deploy/kustomization.yaml`), including adding the block if it doesn't already exist:

   ```yaml
   transformers:
   - site-config/crunchydata/crunchy-backup-transformer.yaml
   ```

For reference, SAS uses the below default schedules.

* Full backup every Sunday at 6am ("0 6 * * 0")
* Incremental backup every Monday-Saturday at 6am ("0 6 * * 1-6")

**Note:** Avoid scheduling backups during times when the environment may be shut down, such as Saturday or Sunday if you regularly scale down your Kubernetes cluster on weekends.

## Additional Resources

For more information, see [SAS Viya Deployment Guide](http://documentation.sas.com/?cdcId=itopscdc&cdcVersion=default&docsetId=dplyml0phy0dkr&docsetTarget=titlepage.htm&locale=en).