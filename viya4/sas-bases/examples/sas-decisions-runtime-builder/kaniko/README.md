---
category: Model Publish service
tocprty: 2
---

# Configure Kaniko for SAS Decisions Runtime Builder Service

## Overview

[Kaniko](https://github.com/GoogleContainerTools/kaniko) is a tool to build container images from a Dockerfile without depending on a Docker daemon. The Kaniko container can load the build context from cloud storage or a local directory, and then push the built image to the container registry for a specific destination.

The Decisions Runtime Builder service uses the sas-decisions-runtime-builder-kaniko dedicated PersistentVolume Claim (PVC) as a workspace, which is shared with the Kaniko container. When a user updates sas-decisions-runtime-image in  container destination, sas-decisions-runtime-builder creates a temporary folder (publish-xxxxxxxx) on the volume (/models/kaniko/), which is then mounted from the sas-decisions-runtime-builder-kaniko PVC in the start-up process.

The update process generates the following content:

* Context (Dockerfile and mainifest) in the /models/kaniko/publish-xxxxxxxx directory.
* Docker configuration in the /models/kaniko/publish-xxxxxxxx-docker directory (Required by all container destination types).

**Note:** The "xxxxxxxx" part of the folder names is a system-generated alphanumeric string and is 8 characters in length.

The Decisions Runtime Builder service then loads a pod templates from the sas-decisions-runtime-builder-kaniko-job-config (as defined in updateJobtemplate.yaml) and sas-decisions-runtime-builder-kaniko-prep-job-config (as defined in prepJobtemplate.yaml) and dynamically constructs a job specification. The job specification helps mount the directories in the Kaniko container. The default pod template uses the official Kaniko image URL `gcr.io/kaniko-project/executor:latest`. Users can replace this image URL in the pod template, if the user wants to host the Kaniko image in a different container registry or use a Kaniko debug image.

The Kaniko container is started after a batch job is executed. The Decisions Runtime Builder service checks the job status every 30 seconds. The job times out after 30 minutes, if it has not completed.

The Decisions Runtime Builder service deletes the job and the temporary directories after the job has completed successfully, completed with errors, or has timed out.

## Prerequisites

If you are deploying in a Red Hat OpenShift cluster, use this command to link the service account to run as root user.

```yaml
oc -n {{ NAME-OF-NAMESPACE }} adm policy add-scc-to-user anyuid -z sas-decisions-runtime-builder-kaniko
```

## Files

In order for the Decisions Runtime Builder service to successfully update image in a container destination, the user must prepare and adjust the following files that are located in the `$deploy/sas-bases/examples/sas-decisions-runtime-builder/kaniko` directory:

**storage.yaml**

  defines a PVC for the Kaniko workspace.

**prepJobtemplate.yaml**

  defines a pod template for the preparation job that prepares files for the Kaniko container.

**updateJobtemplate.yaml**

  defines a pod template for the batch job that launches the Kaniko container.

** sa.yaml

  defines the service account for running the Kaniko job.

The following file is located in the `$deploy/sas-bases/overlays/sas-decisions-runtime-builder/kaniko` directory and does not need to be modified:

**kaniko-transformer.yaml**

  adds the sas-decisions-runtime-builder-kaniko PVC to the sas-decisions-runtime-builder deployment object.

## Installation

1. Copy the files in the `$deploy/sas-bases/examples/sas-decisions-runtime-builder/kaniko` directory to the `$deploy/site-config/sas-decisions-runtime-builder/kaniko` directory. Create the destination directory, if it does not already exist.

   **Note:** If the destination directory already exists, [verify that the overlay](#verify-overlay-for-the-persistent-volume) has been applied. 
   If the output contains the /models/kaniko/ mount directory path, you do not need to take any further actions, unless you want to change the overlay parameters for the mounted directory.

2. Modify the parameters in the podtemplate.yaml file, if you need to implement customized requirements, such as the location of Kaniko image.

3. Modify the parameters in storage.yaml. For more information about PersistentVolume Claims (PVCs), see [Persistent Volume Claims on Kubernetes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#persistentvolumeclaims).

   * Replace {{ STORAGE-CAPACITY }} with the amount of storage required.
   * Replace {{ STORAGE-CLASS-NAME }} with the appropriate storage class from the cloud provider that supports ReadWriteMany access mode.

4. Make the following changes to the base kustomization.yaml file in the $deploy directory.

   * Add site-config/sas-decisions-runtime-builder/kaniko to the resources block.
   * Add sas-bases/overlays/sas-decisions-runtime-builder/kaniko/kaniko-transformer.yaml to the transformers block.

   Here is an example:
   
   ```yaml
   resources:
   - site-config/sas-decisions-runtime-builder/kaniko
   
   transformers:
   - sas-bases/overlays/sas-decisions-runtime-builder/kaniko/kaniko-transformer.yaml
   ```
     
5. Complete the deployment steps to apply the new settings. See [Deploy the Software](http://documentation.sas.com/?cdcId=itopscdc&cdcVersion=default&docsetId=dplyml0phy0dkr&docsetTarget=p127f6y30iimr6n17x2xe9vlt54q.htm) in _SAS Viya: Deployment Guide_.

   **Note:** This overlay can be applied during the initial deployment of SAS Viya or after the deployment of SAS Viya.
   
   * If you are applying the overlay during the initial deployment of SAS Viya, complete all the tasks in the README files that you want to use, then run `kustomize build` to create and apply the manifests. 
   * If the overlay is applied after the initial deployment of SAS Viya, run `kustomize build` to create and apply the manifests.

## Verify Overlay for the Persistent Volume

1. Run the following command to verify whether the overlays have been applied:

   ```sh
   kubectl describe pod  <sas-decisions-runtime-builder-pod-name> -n <name-of-namespace>
   ```
   
2. Verify that the output contains the following mount directory paths:
    
   ```yaml
   Mounts:
     /models/kaniko
   ```

## Additional Resources

* [SAS Viya: Deployment Guide](http://documentation.sas.com/?cdcId=itopscdc&cdcVersion=default&docsetId=dplyml0phy0dkr&docsetTarget=titlepage.htm)
* [Persistent Volume Claims on Kubernetes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#persistentvolumeclaims)
* [Configuring Publishing Destinations](http://documentation.sas.com/?cdcId=mdlmgrcdc&cdcVersion=default&docsetId=mdlmgrag&docsetTarget=n0x0rvwqs9lvpun16sfdqoff4tsk.htm) in the _SAS Model Manager: Administrator's Guide_
