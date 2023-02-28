---
category: backupRestore
tocprty: 18
---

# Configure Python for SAS Model Repository Service

## Overview

The SAS Model Repository service provides support for registering, organizing, and managing models within a common model repository. 
This service is used by SAS Event Stream Processing, SAS Intelligent Decisioning, SAS Model Manager, Model Studio, SAS Studio, and SAS Visual Analytics. 

Analytic store (ASTORE) files are extracted from the analytic store's CAS table in the ModelStore caslib and written to the ASTORES persistent volume, when the following actions are performed:

* an analytic store model is set as the project champion model using SAS Model Manager
* an analytic store model is published to a SAS Micro Analytic Service publishing destination from SAS Model Manager or Model Studio 
* a test is run for a decision that contains an analytic store model using SAS Intelligent Decisioning

When Python models (or decisions that use Python models) are published to the SAS Micro Analytic Service or CAS, the Python score resources are copied to the ASTORES persistent volume. 
Score resources for project champion models that are used by SAS Event Stream Processing are also copied to the persistent volume.

During the migration process, the Python restore script (RestoreScript.py) enables users to restore analytic stores models and Python models in the common model repository, 
along with their associated resources and analytic store files in the ASTORES persistent volume. In order to run the restore script, you must first verify that Python is configured for the SAS Model Repository service. 
The restore script can be used in a customer-prepared environment that consists of a Python installation with any required packages that are stored in a Kubernetes persistent volume. 

**Note:** The restore script does not migrate Python score resources from SAS Viya 3.5 to SAS Viya 4. For more information, see [Promoting and Migrating Content](http://documentation.sas.com/?cdcId=mdlmgrcdc&cdcVersion=default&docsetId=mdlmgrag&docsetTarget=p0n2f2djoollgqn13isibmb98qd2.htm) in _SAS Model Manager: Administrator's Guide_.

This README describes how to make the Python persistent volume available to the sas-model-repository container within your deployment, as part of the backup and restore process. 
The restore script is executed during start-up of the sas-model-repository container, if the `SAS_DEPLOYMENT_START_MODE` parameter is set to `RESTORE` or `MIGRATION`. 

## Prerequisites

SAS Viya provides YAML files that the Kustomize tool uses to configure Python. Before you use those files, you must perform the following tasks:

1. Make note of the attributes for the volume where Python and the associated packages are to be deployed. For example, for NFS, note the NFS server and directory. 
   For more information about the various types of persistent volumes in Kubernetes, see [Additional Resources](#additional-resources).
   
2. Verify that Python 3.5+ and the requests package are installed on the volume. 

## Installation

1. Copy the files in the `$deploy/sas-bases/examples/sas-model-repository/python` directory
to the `$deploy/site-config/sas-model-repository/python` directory. Create the target directory, if
it does not already exist.

2. Make a copy of the kustomization.yaml file to recover after temporary changes are made:
   cp kustomization.yaml kustomization.yaml.save

3. Attach storage to your SAS Viya deployment. The python-transformer.yaml file uses PatchTransformers in Kustomize
to attach the volume containing your Python installation to SAS Viya. 
Replace {{ VOLUME-ATTRIBUTES }} with the appropriate volume specification. 
For example, when using an NFS mount, the {{ VOLUME-ATTRIBUTES }} tag should be
replaced with `nfs: {path: /vol/python, server: myserver.sas.com}`
where `myserver.sas.com` is the NFS server and `/vol/python` is the
NFS path that you recorded in the [Prerequisites](#prerequisites) step.

   The relevant code excerpt from python-transformer.yaml file before the change:

   ```yaml
   patch: |-
     # Add Python volume
     - op: add
       path: /spec/template/spec/volumes/-
       value: { name: python-volume, {{ VOLUME-ATTRIBUTES }} }
   
     # Add mount path for Python
     - op: add
       path: /template/spec/containers/0/volumeMounts/-
       value:
         name: python-volume
         mountPath: /python
         readOnly: true  
   
     # Add restore job parameters
     - op: add
       path: /spec/template/spec/containers/0/envFrom/-
       value:
         configMapRef:
           name: sas-restore-job-parameters
   ```

   The relevant code excerpt from python-transformer.yaml file after the change:

   ```yaml
   patch: |-
     # Add Python volume
     - op: add
       path: /spec/template/spec/volumes/-
       value: { name: python-volume, nfs: {path: /vol/python, server: myserver.sas.com} }
   
     # Add mount path for Python
     - op: add
       path: /template/spec/containers/0/volumeMounts/-
       value:
         name: python-volume
         mountPath: /python
         readOnly: true   
   
     # Add restore job parameters
     - op: add
       path: /spec/template/spec/containers/0/envFrom/-
       value:
         configMapRef:
           name: sas-restore-job-parameters
   ```

3. Add site-config/sas-model-repository/python/python-transformer.yaml to the transformers block to the base kustomization.yaml file in the `$deploy` directory.

   ```yaml
   transformers: 
   - site-config/sas-model-repository/python/python-transformer.yaml
   ```
   
4. Add the sas-restore-job-parameters code below to the configMapGenerator section of kustomization.yaml, and remove the `configMapGenerator` line, if it is already present in the default kustomization.yaml:
   
   ```yaml
   configMapGenerator:
    - name: sas-restore-job-parameters
      behavior: merge
      literals:
       - SAS_BACKUP_ID={{ SAS-BACKUP-ID-VALUE }} 
       - SAS_DEPLOYMENT_START_MODE=RESTORE
   ```
   
   Here are more details about the previous code.
   
   * Replace the value for `{{SAS-BACKUP-ID-VALUE}}` with the ID of the backup that is selected for restore. 
   * To increase the logging levels, add the following line to the literals section:
     - SAS_LOG_LEVEL=DEBUG
   
   For more information, see [Backup and Restore: Perform a Restore](http://documentation.sas.com/?cdcId=itopscdc&cdcVersion=default&docsetId=calbr&docsetTarget=n1607whucnyc02n1eo6tbvl1tzcs.htm) in _SAS Viya Operations_.

5. If you need to rerun a migration, you must remove the `RestoreBreadcrumb.txt` file from the `/models/resources/viya` directory. 

   Here is example code for removing the file:
   
   ```
   kubectl get pods -n <namespace> | grep model-repository
   kubectl exec -it -n <namespace> <podname> -c sas-model-repository -- bash
   rm /models/resources/viya/RestoreBreadcrumb.txt
   ```

6. Complete the deployment steps to apply the new settings. See [Deploy the Software]((http://documentation.sas.com/?cdcId=itopscdc&cdcVersion=default&docsetId=dplyml0phy0dkr&docsetTarget=p127f6y30iimr6n17x2xe9vlt54q.htm)) in _SAS Viya: Deployment Guide_.

   **Note:** This overlay can be applied during the initial deployment of SAS Viya or after the deployment of SAS Viya.
   
   * If you are applying the overlay during the initial deployment of SAS Viya, complete all the tasks in the README files that you want to use, then run `kustomize build` to create and apply the manifests. 
   * If the overlay is applied after the initial deployment of SAS Viya, run `kustomize build` to create and apply the manifests.


## Additional Resources

* [SAS Viya Deployment Guide](http://documentation.sas.com/?cdcId=itopscdc&cdcVersion=default&docsetId=dplyml0phy0dkr&docsetTarget=titlepage.htm)
* [SAS Viya: Models Administration](http://documentation.sas.com/?cdcId=sasadmincdc&cdcVersion=default&docsetId=calmodels)
* [SAS Model Manager: Administrator's Guide](http://documentation.sas.com/?cdcId=mdlmgrcdc&cdcVersion=default&docsetId=mdlmgrag)
* [Persistent volumes in Kubernetes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)
* [Types of volumes in Kubernetes](https://kubernetes.io/docs/concepts/storage/volumes/#types-of-volumes)