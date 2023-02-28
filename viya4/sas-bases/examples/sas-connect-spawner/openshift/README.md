---
category: SAS/CONNECT Spawner
tocprty: 2
---

# Granting Security Context Constraints on an OpenShift Cluster for SAS/CONNECT

By default, the SAS/CONNECT Spawner ONLY launches servers in their own pods (-nolocallaunch) instead
of spawning them in the Spawner pod itself. Unless you specifically want to spawn the servers in the Spawner pod,
there is no need to grant a special elevated security constraint for the SAS/CONNECT Spawner.

Follow these instructions ONLY if your deployment is spawning servers locally.

The `$deploy/sas-bases/examples/sas-connect-spawner/openshift` directory contains a file to
grant security context constraints (SCCs) for the sas-connect-spawner pod on an OpenShift cluster.
A Kubernetes cluster administrator should add these SCCs
to their OpenShift cluster prior to deploying SAS Viya.

1. As a Kubernetes cluster administrator of the OpenShift cluster, use one of the following sets of commands to apply the SCCs.

```sh
kubectl apply -f sas-connect-spawner-scc.yaml
```

or

```sh
oc create -f sas-connect-spawner-scc.yaml
```

2. Use the following command to link the SCCs to Kubernetes ServiceAccounts. Replace the entire variable {{ NAME-OF-NAMESPACE }}, including the braces, with the Kubernetes namespace used for SAS Viya.

```sh
oc -n {{ NAME-OF-NAMESPACE }} adm policy add-scc-to-user sas-connect-spawner -z sas-connect-spawner
```