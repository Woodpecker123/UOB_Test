---
category: sasProgrammingEnvironment
tocprty: 14
---

# SAS Batch Server Storage Task for Checkpoint/Restart

## Overview

A SAS Batch Server has the ability to restart a SAS job using
either SAS's data step checkpoint/restart capability or
SAS's label checkpoint/restart capability.
For the checkpoint/restart capability to work properly, the checkpoint
information must be stored on storage that persists across all compute
nodes in the deployment. When the Batch Server job is restarted, it will have
access to the checkpoint information no matter what compute node it is started on.

The checkpoint information is stored in SASWORK, which is allocated in
the volume named `viya`. Since a Batch Server is a SAS Viya server that
uses the SAS Programming Run-Time Environment, it is possible that the
`viya` volume may be set to ephemeral storage by the
`$deploy/sas-bases/examples/sas-programming-environment/storage/change-viya-volume-storage-class.yaml`
patch. If that is the case, the Batch Server's `viya` volume would need
to be changed to persistent storage without changing any other server's
storage.

**Note:** For more information about changing the storage for SAS Viya servers that use the SAS Programming Run-Time Environment, see the README file at `$deploy/sas-bases/examples/sas-programming-environment/storage/README.md` (for Markdown format) or at `$deploy/sas-bases/docs/sas_programming_environment_storage_tasks.htm` (for HTML format).

The patch described in this README sets the storage class for the SAS Batch
Server's `viya` volume defined in the SAS Batch Server pod templates without
changing the storage of the other SAS Viya servers that use the SAS
Programming Run-Time Environment.

## Installation

The changes described by this README take place at the initialization of
the server application; therefore the changes take effect at the next
launch of a pod for the server application.

The volume storage class for these applications can be modified by using the
example file located at `$deploy/sas-bases/examples/sas-batch-server/storage`.

1. Copy the
`$deploy/sas-bases/examples/sas-batch-server/storage/change-batch-server-viya-volume-storage-class.yaml`
file to the site-config directory.

2. To change the storage class, replace the {{ VOLUME-STORAGE-CLASS }} variable
in the copied file with a different volume storage class.
The unedited example file looks like this:

   ```yaml
   apiVersion: v1
   kind: PodTemplate
     metadata:
       name: change-batch-server-viya-volume-storage-class
     template:
      spec:
       volumes:
       - $patch: delete
         name: viya
       - name: viya
         nfs:
           {{ VOLUME-STORAGE-CLASS }}
   ```

   Assume that the storage location you want to use is an NFS volume.   That volume may be
   described in the following way:

   ```yaml
   nfs:
     server: myserver.mycompany.com
     path: /path/to/my/location
   ```

   To use this storage location in the patch, substitute in the volume definition in the
   {{ VOLUME-STORAGE-CLASS }} location.  The result would look like this:

   ```yaml
   apiVersion: v1
   kind: PodTemplate
     metadata:
       name: change-batch-server-viya-volume-storage-class
     template:
      spec:
       volumes:
       - $patch: delete
         name: viya
       - name: viya
         nfs:
           server: myserver.mycompany.com
           path: /path/to/my/location
   ```

   **NOTE:** The patch defined here deletes the previously defined `viya`
   volume specification in the associated podTemplates.   Any content that may
   exist in the current `viya` volume is not affected by this patch.

3. After you edit the change-batch-server-viya-volume-storage-class.yaml file, add a patch to
the base kustomization.yaml file (`$deploy/kustomization.yaml`).

   **NOTE:** If the `$deploy/sas-bases/examples/sas-programming-environment/storage/change-viya-volume-storage-class.yaml`
   patch is also being used in the base kustomization.yaml file,
   ensure the Batch Server patch is located after the entry for
   the `change-viya-volume-storage-class.yaml` patch.
   Otherwise the Batch Server patch will have no effect.

   Here is an example assuming the file has been saved to
   `$deploy/site-config`:

   ```yaml
   patches:
     <...other patches...>
     - path: site-config/change-batch-server-viya-volume-storage-class.yaml
       target:
         kind: PodTemplate
         labelSelector: "launcher.sas.com/job-type=sas-batch-job"
   ...
   ```

## Additional Resources

For more information about deployment and using example files, see the
[SAS Viya: Deployment Guide](http://documentation.sas.com/?cdcId=itopscdc&cdcVersion=default&docsetId=dplyml0phy0dkr&docsetTarget=titlepage.htm).