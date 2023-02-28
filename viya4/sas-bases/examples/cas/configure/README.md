---
category: cas
tocprty: 9
---

# Configuration Settings for CAS

## Overview

This document describes the customizations that can be made by the Kubernetes
administrator for deploying CAS in both symmetric multiprocessing (SMP) and
massively parallel processing (MPP) configurations.

An SMP server requires one Kubernetes node. An MPP server requires one
Kubernetes node for the server controller and two or more nodes for server
workers. The *SAS Viya: Deployment Guide* provides information to help you
decide. A link to the deployment guide is provided in the
[Additional Resources](#additional-resources) section.

## Installation

SAS provides example files for many common customizations. Read the descriptions
for the example files in the following list. If you want to use an example file
to simplify customizing your deployment, copy the file to your
`$deploy/site-config` directory.

Each file has information about its content. The variables in the file are set
off by curly braces and spaces, such as {{ NUMBER-OF-WORKERS }}. Replace the
entire variable string, including the braces, with the value you want to use.

After you edit a file, add a reference to it in the transformer block of the
base `kustomization.yaml` file.

## Examples

The example files are located at `$deploy/sas-bases/examples/cas/configure`. The
following is a list of each example file for CAS settings and the file name.

- mount non-NFS persistentVolumeClaims and data connectors for the CAS server
  (`cas-add-host-mount.yaml`)

  ***Note***: To use hostPath mounts on Red Hat OpenShift, see
  [Enable hostPath Mounts for CAS](https://documentation.sas.com/?cdcId=itopscdc&cdcVersion=default&docsetId=dplyml0phy0dkr&docsetTarget=p1h8it1wdu2iaxn1bkd8anfcuxny.htm#n02xn6pmscncm8n14zm4zlcyyr2g).

- mount NFS persistentVolumeClaims and data connectors for the CAS server
  (`cas-add-nfs-mount.yaml`)

- specify the number of workers in an MPP deployment (`cas-manage-workers.yaml`)

  ***Note***: Do not use this example for an SMP CAS server.

- add a backup controller to an MPP deployment (`cas-manage-backup.yaml`)

  ***Note***: Do not use this example for an SMP CAS server.

- change the user the CAS process runs as (`cas-modify-user.yaml`)

- modify the storage size for CAS PersistentVolumeClaims
  (`cas-modify-pvc-storage.yaml`)

- manage resources for CPU and memory (`cas-manage-cpu-and-memory.yaml`)

- modify the resource allocation for ephemeral storage
  (`cas-modify-ephemeral-storage.yaml`)

- add a configMap to your CAS server (`cas-add-configmap.yaml`)

- add environment variables (`cas-add-environment-variables.yaml`)

- add a configMap with an SSSD configuration (`cas-sssd-example.yaml`)

  ***Note***: This file has no variables. It is an example of how to create a
  configMap for SSSD.

- modify the accessModes on the CAS permstore and data PVCs
  (`cas-storage-access-modes.yaml`)

- disable the sas-backup-agent sidecar from running
  (`cas-disable-backup-agent.yaml`)

- add paths to the file system path allowlist for the CAS server.
  (`cas-add-allowlist-paths.yaml`)

- enable your CAS Services to be externally accessible.
  (`cas-enable-external-services.yaml`)

- remove secure computing mode (seccomp) profile for CAS.
  (`cas-disable-seccomp.yaml`)

- set the secure computing mode (seccomp) profile for CAS, and override the default of "RuntimeDefault".
  (`cas-seccomp-profile.yaml`)

- automatically restart CAS servers during Deployment Operator updates.
  (`cas-auto-restart.yaml`)

- enable host identity session launching.
  (`cas-enable-host.yaml`)

- disable publish of HTTP Ingress.
  (`cas-disable-http-ingress.yaml`)

### Disable Cloud Native Mode

Perform these steps if cloud native mode should be disabled in your environment.

1. Add the following code to the configMapGenerator block of the base kustomization.yaml
file:

   ```yaml
   ...
   configMapGenerator:
   ...
   - name: sas-cas-config
     behavior: merge
     literals:
       - CASCLOUDNATIVE=0
   ...
   ```

2. Deploy the software using the commands in
[SAS Viya: Deployment Guide](http://documentation.sas.com/?softwareId=mysas&softwareVersion=prod&docsetId=dplyml0phy0dkr&docsetTarget=titepage.htm).

### Enable System Security Services Daemon (SSSD) Container

> ***Note***: If you are enabling SSSD on an OpenShift cluster, use the SecurityContextConstraint patch `cas-server-scc-sssd.yaml` instead of `cas-server-scc.yaml`. This will set the correct capabilities and privilege escalation.

Perform these steps if SSSD is required in your environment.

1. Add sas-bases/overlays/cas-server/cas-sssd-sidecar.yaml as the first entry to the transformers list of the base kustomization.yaml file (`$deploy/kustomization.yaml`).
 Here is an example:

   ```yaml
   ...
   transformers:
   ...
   - sas-bases/overlays/cas-server/cas-sssd-sidecar.yaml
   ...
   ```

> ***Note***: In the transformers list, the `cas-sssd-sidecar.yaml` file must precede the entry `sas-bases/overlays/required/transformers.yaml` and any TLS transformers.

### Add a Custom Configuration for System Security Services Daemon (SSSD)

Use these steps to provide a custom SSSD configuration to handle user authorization in your environment.

1. Copy the `$deploy/sas-bases/examples/cas/configure/cas-sssd-example.yaml`file to the location of your
   CAS server overlay.
   Example: `site-config/cas-server/cas-sssd-example.yaml`

2. Add the relative path of cas-sssd-example.yaml to the transformers block of the base kustomization.yaml file
   (`$deploy/kustomization.yaml`).
   Here is an example:

   ```yaml
   ...
   transformers:
   ...
   - site-config/cas-server/cas-sssd-example.yaml
   ...
   ```

3. Copy your custom SSSD configuration file to `sssd.conf`.

4. Add the following code to the secretGenerator block of the base kustomization.yaml
  file with a relative path to `sssd.conf`:

   ```yaml
   ...
   secretGenerator:
   ...
   - name: sas-sssd-config
     files:
       - SSSD_CONF=site-config/cas-server/sssd.conf
     type: Opaque
   ...
   ```

### Enable Host Launch in the CAS Server

> ***Note***: If you use Kerberos in your deployment, or enable SSSD and disable CASCLOUDNATIVE,
you must enable host launch.

By default, CAS cannot launch sessions under a user's host identity. All sessions run
under the cas service account instead. CAS can be configured to allow for host identity
launches by including a patch transformer in the kustomization.yaml file. The
`/$deploy/sas-bases/examples/cas/configure` directory
contains a cas-enable-host.yaml file, which can be used for this purpose.

> ***Note***: If you are enabling host launch on an OpenShift cluster, specify one of the following files to create the SecurityContextConstraint instead of `cas-server-scc.yaml`:
>
> - If SSSD is not configured, use the SecurityContextConstraint patch `cas-server-scc-host-launch.yaml`
> - If SSSD is configured, use the SecurityContextConstraint patch `cas-server-scc-sssd.yaml`
>
> This will set the correct capabilities and privilege escalation.

To enable this feature:

1. Copy the `$deploy/sas-bases/examples/cas/configure/cas-enable-host.yaml` file to the location of your
CAS server overlay. For example, `site-config/cas-server/cas-enable-host.yaml`.

2. The example file defaults to targeting all CAS servers by specifying a name component of `.*`.
To target specific CAS servers, comment out the `name: .*` line and choose which CAS servers you
want to target. Either uncomment the name: and replace NAME-OF-SERVER with one particular CAS
server or uncomment the labelSelector line to target only the default deployment.

3. Add the relative path of the `cas-enable-host.yaml` file to the transformers block of the base
kustomization.yaml file (`$deploy/kustomization.yaml`) before the reference to
the sas-bases/overlays/required/transformers.yaml file and any SSSD transformers. Here is an example:

   ```yaml
   transformers:
   ...
   - site-config/cas-server/cas-enable-host.yaml
   ...
   - sas-bases/overlays/required/transformers.yaml
   ...
   ```

## Targeting CAS Servers

Each example patch has a target section which tells it what resource(s) it should apply to.
There are several parameters including object name, kind, version, and labelSelector. By default,
the examples in this directory use  `name: .*` which applies to all CAS server definitions.
If there are multiple CAS servers and you want to target a specific instance, you can set the
"name" option to the name of that CASDeployment.  If you want to target the default "cas-server"
overlay you can use a labelSelector:

Example:

```yaml
target:
  name: cas-example
  labelSelector: "sas.com/cas-server-default"
  kind: CASDeployment
```

> ***Note***: When targeting the default CAS server provided explicitly the path option must be used, because the name is a config map token that cannot be targeted.

## Additional Resources

For more information about CAS configuration and using example files, see the
[SAS Viya: Deployment Guide](http://documentation.sas.com/?softwareId=mysas&softwareVersion=prod&docsetId=dplyml0phy0dkr&docsetTarget=titlepage.htm).
