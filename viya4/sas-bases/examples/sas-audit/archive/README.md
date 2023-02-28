# SAS Audit Archive Configuration

## Overview

The SAS Audit service can be configured to periodically archive audit records to file. If this feature is enabled, then a PersistentVolumeClaim must be created as the output location for these archive files.

## Prerequisites

Archiving is disabled by default, so you must enable the feature to use it.
As an administrator, open the Audit service configuration in SAS Environment Manager and change the following settings to the specified values.

| Setting Name                                       | Value                                                       |
| ---------------------------------------------------| ----------------------------------------------------------- |
| sas.audit.archive.system.storage.local.destination | The path where archive files should be written.             |
| sas.audit.archive.process.storageType              | local                                                       |

## Installation

### Copy the Example Files

Copy all of the files in `$deploy/sas-bases/examples/sas-audit/archive` to `$deploy/site-config/sas-audit`, where $deploy is the directory containing your SAS Viya install files.

### Update the resources.yaml File

Edit the resources.yaml file to replace the following parameters with the appropriate values.

| Parameter Name   | Description                                                                                     | Example Value |
| ---------------- | ----------------------------------------------------------------------------------------------- | ------------- |
| STORAGE-CLASS    | The storage class of the PersistentVolumeClaim. The storage class must support ReadWriteMany.   | nfs-client    |
| STORAGE-CAPACITY | The size of the PersistentVolumeClaim.                                                          | 1Gi           |

### Update the Base kustomization.yaml File

After updating the example files, you should add references to them to the base kustomization.yaml:
* Add a reference to the resources.yaml file to the resources block.
* Add a reference to the archive-transformer.yaml file to the transformers block.

For example, if you made the changes
described in the above steps, then the base kustomization.yaml in your $deploy directory should have entries
similar to the following:

```yaml
resources:
- site-config/sas-audit/resources.yaml
transformers:
- site-config/sas-audit/archive-transformer.yaml
```

### Build and Apply the Manifest

As an administrator with cluster permissions, apply the edited files to your deployment.

1. Switch to the directory containing the Viya install files ($deploy). If a sub-directory named manifests doesn't exit, create one.

  ```bash
  mkdir manifests
  ```

2. Build a new deployment manifest that includes your custom settings:

  ```bash
  kustomize build . -o manifests/manifest.yaml
  ```

3. Apply the manifest to your deployment:

  ```bash
  kubectl apply -f manifests/manifest.yaml
  ```