---
category: dataServer
tocprty: 40
---

# Upgrade to PostgreSQL Operator v5

**IMPORTANT:** Upgrading to version 5 of the Crunchy Data PostgreSQL Operator from prior SAS Viya versions is not currently supported for existing deployments running on OpenShift. If your SAS Viya deploying is run on OpenShift, upgrades should not be attempted as they might leave your machine in a failed state.

## Overview

Beginning with version 2022.10, SAS Viya uses version 5 of the Crunchy Data PostgreSQL Operator. This README describes how to upgrade the PostgreSQL Operator and the PostgreSQL clusters it manages.

**Note:** The PostgreSQL Operator is specific to internal PostgreSQL. If Viya is configured to use external PostgreSQL, skip the contents of this README. You should also skip the contents of this README if you have already deployed the correct PostgreSQL Operator version. To check the version that is deployed run the following command. If it returns an error or a message, "No resources found in <your-namespace> namespace", you are at version 5 of the operator.

```bash
kubectl get pgclusters.crunchydata.com -n {{ NAME-OF-NAMESPACE }}
```

## Instructions

Perform the steps under each of the following subsections in the order they are written.

**Note:** If your deployment is managed by the SAS Viya Deployment Operator, skip to [Migrate Data to New PostgreSQL Operator Version](#migrate-data-to-new-postgresql-operator-version).

### Scale Down the SAS Data Server Operator

1. Scale down the existing SAS Data Server Operator deployment. In the following command, replace the entire variable `{{ NAME-OF-NAMESPACE }}`, including the braces, with your SAS Viya namespace.

   ```bash
   kubectl scale deployment --replicas=0 sas-data-server-operator -n {{ NAME-OF-NAMESPACE }}
   ```

   If you receive the following error, your SAS Viya deployment did not include the SAS Data Server Operator. In this case, skip to [Prepare and Terminate PostgreSQL Clusters](#prepare-and-terminate-postgresql-clusters).

   ```bash
   Error from server (NotFound): deployments.apps "sas-data-server-operator" not found
   ```

2. Wait for the SAS Data Server Operator pod to be terminated:

   ```bash
   kubectl wait --for=delete --selector="app.kubernetes.io/name=sas-data-server-operator" pods --timeout=300s -n {{ NAME-OF-NAMESPACE }}
   ```

### Prepare and Terminate PostgreSQL Clusters

1. List the PostgreSQL clusters included in your deployment using the command below.

   ```bash
   kubectl get pgclusters.crunchydata.com -n {{ NAME-OF-NAMESPACE }}
   ```

   The remaining steps in this section should be performed for *each* PostgreSQL cluster listed by the command. Replace the variable `{{ PGCLUSTER-NAME }}` in any later commands with the PostgreSQL cluster resource you are targeting.

2. Scale down the replica deployments. Scaling down fails back the primary if it was failed over to a replica.

   ```bash
   kubectl scale --replicas=0 deployment --selector=crunchy-pgha-scope={{ PGCLUSTER-NAME }},name!={{ PGCLUSTER-NAME }} -n {{ NAME-OF-NAMESPACE }}

   kubectl wait --for=delete --selector=crunchy-pgha-scope={{ PGCLUSTER-NAME }},name!={{ PGCLUSTER-NAME }} pods --timeout=300s -n {{ NAME-OF-NAMESPACE }}
   ```

   Ignore the following error, which is returned if the pods are already down before the wait command.

   ```bash
   error: no matching resources found
   ```

3. Check the cluster to ensure only one pod is running as Leader.

   ```bash
   kubectl exec deployment/{{ PGCLUSTER-NAME }} -c database -n {{ NAME-OF-NAMESPACE }} -- patronictl list
   ```

   The output should look something like the following:

   ```bash
   + Cluster: sas-crunchy-data-postgres (7016764262444130456) -----------+---------+---------+----+-----------+
   | Member                                                | Host        | Role    | State   | TL | Lag in MB |
   +-------------------------------------------------------+-------------+---------+---------+----+-----------+
   | sas-crunchy-data-postgres-7f846c5d94-wlwrp            | 10.244.2.88 | Leader  | running | 19 |           |
   +-------------------------------------------------------+-------------+---------+---------+----+-----------+
   ```

4. Delete the replica PVCs.

   ```bash
   kubectl delete pvc $(kubectl get deploy --selector=crunchy-pgha-scope={{ PGCLUSTER-NAME }},name!={{ PGCLUSTER-NAME }} -o jsonpath='{.items[*].metadata.name}' -n {{ NAME-OF-NAMESPACE }} ) --timeout=300s -n {{ NAME-OF-NAMESPACE }}
   ```

5. Scale down the primary deployment.

   ```bash
   kubectl scale --replicas=0 deployment --selector=crunchy-pgha-scope={{ PGCLUSTER-NAME }},name={{ PGCLUSTER-NAME }} -n {{ NAME-OF-NAMESPACE }}

   kubectl wait --for=delete --selector=crunchy-pgha-scope={{ PGCLUSTER-NAME }},name={{ PGCLUSTER-NAME }} pods --timeout=300s -n {{ NAME-OF-NAMESPACE }}
   ```

   Ignore the following error, which is returned if the pods are already down before the wait command.

   ```bash
   error: no matching resources found
   ```

6. Patch the security context of the pgBackrest deployment.

   ```bash
   kubectl patch -n {{ NAME-OF-NAMESPACE }} deployment {{ PGCLUSTER-NAME }}-backrest-shared-repo --type json -p '[{"op": "replace", "path": "/spec/template/spec/securityContext", "value": { "runAsNonRoot": true, "runAsUser": 2000, "runAsGroup": 26, "fsGroup": 26, "supplementalGroups": [26, 2000]}}]'

   kubectl rollout status -n {{ NAME-OF-NAMESPACE }} deployment {{ PGCLUSTER-NAME }}-backrest-shared-repo
   ```

7. Modify file permissions for the pgBackrest directory.

   ```bash
   kubectl exec -n {{ NAME-OF-NAMESPACE }} deployment/{{ PGCLUSTER-NAME }}-backrest-shared-repo -- chmod -R 770 /backrestrepo/{{ PGCLUSTER-NAME }}-backrest-shared-repo/

   kubectl exec -n {{ NAME-OF-NAMESPACE }} deployment/{{ PGCLUSTER-NAME }}-backrest-shared-repo -- chgrp -R postgres /backrestrepo/{{ PGCLUSTER-NAME }}-backrest-shared-repo/
   ```

8. Terminate the PostgreSQL cluster.

   Copy the template file `$deploy/sas-bases/examples/crunchydata/pgo4upgrade/pgtask-rmdata.yaml` to your site-config directory, `$deploy/site-config/`. If a copy already exists, you may overwrite it. Then, follow the instructions within the copied file to populate any necessary variables.

   After copying and filling out the file, apply it to terminate the PostgreSQL cluster. Replace the entire variable `{{ PGTASK-PATH }}`, including the braces, with the expanded location of your copy of the file `$deploy/sas-bases/examples/crunchydata/pgo4upgrade/pgtask-rmdata.yaml`.

   ```bash
   kubectl apply -f {{ PGTASK-PATH }} -n {{ NAME-OF-NAMESPACE }}
   ```

   **Note:** Your copy of the file `$deploy/sas-bases/examples/crunchydata/pgo4upgrade/pgtask-rmdata.yaml` should NOT be added or referenced in any kustomization files. After applying it, you may delete your copy of the file.

9. Wait for the internal PostgreSQL pods to be terminated.

   ```bash
   kubectl wait --for=delete --selector=pg-cluster={{ PGCLUSTER-NAME }} pods --timeout=300s -n {{ NAME-OF-NAMESPACE }}
   ```

10. Wait for the custom resource pgtask to be terminated.

   ```bash
   kubectl wait --for=delete --selector=pg-cluster={{ PGCLUSTER-NAME }} pgtask --timeout=300s -n {{ NAME-OF-NAMESPACE }}
   ```

11. Remove the TLS artifacts for the PostgreSQL cluster.

   ```bash
   kubectl delete job "{{ PGCLUSTER-NAME }}-tls-generator" --ignore-not-found=true --timeout=300s -n {{ NAME-OF-NAMESPACE }}

   kubectl delete secret "{{ PGCLUSTER-NAME }}-tls-secret" --ignore-not-found=true --timeout=300s -n {{ NAME-OF-NAMESPACE }}
   ```

12. Repeat steps 2-11 for any remaining PostgreSQL clusters listed in step 1.

### Migrate Data to New PostgreSQL Operator Version

You must explicitly tell the new PostgreSQL Operator to migrate existing PostgreSQL data. Use the following subsections based on the PostgreSQL clusters included in your SAS Viya deployment.

#### Migrate Platform PostgreSQL ("sas-crunchy-data-postgres"):

Go to the base kustomization.yaml file (`$deploy/kustomization.yaml`). In the transformers block of that file, add the following content, including adding the block if it doesn't already exist:

```yaml
transformers:
- sas-bases/examples/crunchydata/pgo4upgrade/crunchy-upgrade-platform-transformer.yaml
```

**Note:** After upgrading your SAS Viya deployment, remove the above content from your base kustomization.yaml file.

#### Migrate CDS PostgreSQL ("sas-crunchy-data-cdspostgres"):

Go to the base kustomization.yaml file (`$deploy/kustomization.yaml`). In the transformers block of that file, add the following content, including adding the block if it doesn't already exist:

```yaml
transformers:
- sas-bases/examples/crunchydata/pgo4upgrade/crunchy-upgrade-cds-transformer.yaml
```

**Note:** After upgrading your SAS Viya deployment, remove the above content from your base kustomization.yaml file.