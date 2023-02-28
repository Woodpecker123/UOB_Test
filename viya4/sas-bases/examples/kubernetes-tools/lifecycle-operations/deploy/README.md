---
category: kubernetesTools
tocprty: 4
---

# Lifecycle Operation: Deploy

## Overview

The `deploy` lifecycle operation runs the recommended sequence of
`kubectl apply` commands necessary to deploy the software.

For general lifecycle operation execution details, please see the README file at
`$deploy/sas-bases/examples/kubernetes-tools/README.md` (for Markdown) or
`$deploy/sas-bases/docs/using_kubernetes_tools_from_the_sas-orchestration_image.htm` (for HTML).

**Note:** `$deploy` refers to the directory containing the deployment assets.

The following example assumes:

* The deployment assets for the order have been downloaded to `$deploy`. To download the deployment assets
  for an order from `my.sas.com`, go to [http://my.sas.com](http://my.sas.com), log in, find your order
  and select `Download Deployment Assets`. Extract the downloaded tarball to `$deploy`.
* A `site.yaml` manifest file exists in `$deploy`.
  See the [SAS Viya Deployment Guide](http://documentation.sas.com/?cdcId=itopscdc&cdcVersion=default&docsetId=dplyml0phy0dkr&docsetTarget=titlepage.htm)
  for instructions on how to create the site.yaml manifest.
* A kubeconfig file called `config` exists in `/home/user/kubernetes`. The kubeconfig file defines the cluster
  the lifecycle operations will connect to.
* The orchestration image has been pulled and has the local tag 'sas-orchestration'
* The `$deploy` directory is the current working directory.
  `cd` to $deploy and use `$(pwd)` to mount the current directory into the container.
* The software has been deployed into the namespace `{{ NAME-OF-NAMESPACE }}`

## Example

```
cd $deploy
docker run --rm \
  -v "$(pwd):/cwd" \
  -v /home/user/kubernetes:/kubernetes \
  -e "KUBECONFIG=/kubernetes/config" \
  sas-orchestration \
  lifecycle run \
    --operation deploy \
    --deployment-dir /cwd \
    -- \
    --manifest /cwd/site.yaml \
    --deploymentDir /cwd \
    --namespace {{ NAME-OF-NAMESPACE }}
```

**Note:** To see the commands that would be executed from the operation without
making any changes to the cluster, add `-e "DISABLE_APPLY=true"` to the container.
