---
category: multiTenant
tocprty: 5
---

# Onboard or Offboard Tenants Using the Tenant Job

## Overview

The deployment of SAS Viya creates an initial provider tenant. After deployment, a Kubernetes user with elevated permissions runs the tenant job to onboard one or more tenants. All tenants onboard into the
same namespace as the provider. Subsequent onboarding jobs run without interrupting service to existing tenants.

For each new tenant, the onboarding process creates a new PostgreSQL database (database-per-tenant mode) or new schemas in a shared database (schema-per-application-tenant mode, which is the default mode). All tenants share the same database server configuration. The tenant database or shared database can be in the SAS Viya internal database server or it can be in an external database server. The database server configuration and database tenant mode are specified during deployment. To learn more about deployment, see the README file at 
`$deploy/sas-bases/examples/multi-tenant/README.md` (for Markdown format) or 
at `$deploy/sas-bases/docs/multi-tenant_deployment.htm` (for HTML format).

Onboarding adds users and groups, installs tenant-specific applications, and optionally enables TLS security. Offboarding deletes users and groups, drops the database or schemas, and uninstalls tenant-specific applications.

Cloud Analytic Services (CAS) are installed or uninstalled separately after you run the tenant onboarding or offboarding job. To learn more, see [Onboard a CAS Server](https://documentation.sas.com/?cdcId=sasadmincdc&cdcVersion=default&docsetId=caltenants&docsetTarget=p0emzq13c0zbhxn1hktsdlmig934.htm#n0uh9ovr91gtjvn1hvxtr50do7kt).

## Prepare to Onboard or Offboard

### Permissions

Elevated Kubernetes permissions are required to run the tenant job and perform the prerequisite steps.

### Prerequisites

The sas-tenant-job can be used to onboard or offboard tenants. Each job type has its own prerequisite tasks. These tasks must be performed before running the tenant job.

* [Onboarding prerequisites](https://documentation.sas.com/?cdcId=sasadmincdc&cdcVersion=default&docsetId=caltenants&docsetTarget=p0emzq13c0zbhxn1hktsdlmig934.htm#n1fptbibrh96r8n1jy317onpjd8r)

* [Offboarding prerequisites](https://documentation.sas.com/?cdcId=sasadmincdc&cdcVersion=default&docsetId=caltenants&docsetTarget=p0emzq13c0zbhxn1hktsdlmig934.htm#n0m5v7ldcutnmqn1e5ts1toy7fx5) 
 

### Copy the Tenant Job Files

1. If you have any files in `$deploy/site-config/sas-tenant-job/`, move them to a new sub-directory or delete them to ensure that you utilize the latest files in the next step.

2. Always copy the latest tenant files from `$deploy/sas-bases/examples/sas-tenant-job/*` to `$deploy/site-config/sas-tenant-job/`.

3. Add write permission to all of the YAML files in the `$deploy/site-config/sas-tenant-job/` directory.

### Specify the Namespace of the Deployment

Edit each of the following files to replace all occurrences of `{{ VIYA-DEPLOYMENT-NAMESPACE }}`
with the name of your SAS Viya namespace. 

* `$deploy/site-config/sas-tenant-job/tenant-job-service-account-role.yaml`

* `$deploy/site-config/sas-tenant-job/kustomization-onboard.yaml`

* `$deploy/site-config/sas-tenant-job/kustomization-offboard.yaml`

If you are using a mirror registry for the deployment, be sure to uncomment (enable) the mirror registry transformer `site-config/mirror.yaml` in the copies of these example files.

### Apply the Service Account Role for the Tenant Job

The tenant job requires the service account role so that it can make API calls.

**Note:**
This role must be applied before you onboard your first tenant. For subsequent runs of the tenant job, re-apply this role if the role has been dropped, or if the tenant-job-service-account-role.yaml file has changed. To ensure the latest role has been applied, you may want to always re-apply this role before each onboard or offboard job.

Apply the service account role.

```
kubectl apply -f $deploy/site-config/sas-tenant-job/tenant-job-service-account-role.yaml
```

## Onboard or Offboard

1. Ensure that you are in the new tenant job directory, such as
   `$deploy/site-config/sas-tenant-job/`.

2. Edit the job file `tenant-onboard-job.yaml` or `tenant-offboard-job.yaml`.

   - Replace `{{ SAS-TENANT-IDS }}` with the valid tenant ID/tenant IDs that will be onboarded or offboarded.

     Example:

        Single tenant ID: `"acme"`

        or

        Multiple tenant IDs: `"acme, cyberdyne, intech"`

        **Note:**
          Quotation marks and commas are required if you include multiple tenant IDs in one action.

3. Update the default job parameters in the `tenant-onboard-job.yaml` or
   `tenant-offboard-job.yaml` file. Refer to [Job Parameters](#job-parameters) below.

4. To create the kustomization.yaml, enter the following copy command.

   If you are onboarding:

   ```
   cp -v kustomization-onboard.yaml kustomization.yaml
   ```

   If you are offboarding:

   ```
   cp -v kustomization-offboard.yaml kustomization.yaml
   ```

5. If your SAS Viya deployment disables Transport Layer Security (TLS), edit `kustomization.yaml` and comment out the appropriate line:

   If you are onboarding:
 
   ```
   #- tenant-onboard-job-tls-transformer.yaml
   ```

   If you are offboarding:

   ```
   #- tenant-offboard-job-tls-transformer.yaml
   ```

6. In the new job directory, build the manifest file.

   If you are onboarding:

   ```
   kustomize build . -o site-onboard.yaml --load_restrictor=none
   ```

   If you are offboarding:

   ```
   kustomize build . -o site-offboard.yaml --load_restrictor=none
   ```

7. If your SAS Viya containers and `sas-tenant-job` come from the same registry, get the full name of the `sas-image-pull-secrets` currently in your deployment.

   ```
   kubectl get secrets -n {{ name-of-namespace }} | grep sas-image-pull-secrets
   ```

   Then edit the site-onboard.yaml and site-offboard.yaml files by replacing `sas-image-pull-secrets` with the full secret name you just retrieved.
   
8. If your SAS Viya containers and `sas-tenant-job` come from different registries, create a new secret named `sas-tenant-job-image-pull-secrets`.

   ```
   kubectl create secret -n {{ name-of-namespace }} docker-registry sas-tenant-job-image-pull-secrets --docker-server=cr.sas.com --docker-username=xxxxxxxxxx --docker-password=xxxxxxxx --docker-email=Firstname.Lastname@sas.com
   ```
   
   Then edit the site-onboard.yaml and site-offboard.yaml files, by replacing `sas-image-pull-secrets` with `sas-tenant-job-image-pull-secrets`.

9. Run the onboarding or offboarding command:

    ```
    kubectl create -f site-onboard.yaml
    ```

    or

    ```
    kubectl create -f site-offboard.yaml
    ```

    The job runs under the name `sas-tenant-{{onboard-or-offboard}}-job-{{suffix}}`. For example, 
    `sas-tenant-onboard-job-4mf9j-zp2n9` or `sas-tenant-offboard-job-62llh-pmw8j`.

    **Note:** The suffix is uniquely generated by Kubernetes for each job.

10. Use the following commands to track the job.

    To list tenant jobs:

    ```
    kubectl get jobs -n {{ name-of-namespace }} -l run=sas-tenant-onboard-job
    ```

    or

    ```
    kubectl get jobs -n {{ name-of-namespace }} -l run=sas-tenant-offboard-job
    ```

    To show details for a tenant job:

    ```
    kubectl -n {{ name-of-namespace }} describe jobs sas-tenant-onboard-job
    ```

    or

    ```
    kubectl -n {{ name-of-namespace }} describe jobs sas-tenant-offboard-job
    ```

    To view the log of a specific tenant job, first find its pod name:

    ```
    kubectl get pods -n {{ name-of-namespace }} | grep sas-tenant-onboard-job
    ```

    or

    ```
    kubectl get pods -n {{ name-of-namespace }} | grep sas-tenant-offboard-job
    ```

    To see the log:

    ```
    kubectl -n {{ name-of-namespace }} logs {{ sas-tenant-onboard-job-pod-name }}
    ```

    or

    ```
    kubectl -n {{ name-of-namespace }} logs {{ sas-tenant-offboard-job-pod-name }}
    ```
   
### Job Parameters

**TENANT\_LIFECYCLE\_ACTION**

The action to perform. The options are onboard and offboard.

**SAS\_TENANT\_IDS**

One or more tenant IDs to onboard or offboard.

Tenant IDs have the following restrictions:
* Cannot be longer than 16 characters.
* Must be completely lowercase.
* Must start with a letter.
* Must be letters and numbers only.
* Cannot start with "sas".

In addition, the following tenant IDs are reserved and cannot be used:
* default
* provider
* shared
* sharedservices
* spre
* uaa
* viya

**SAS\_LOG\_LEVEL**

The logging level for the tenant job. Valid values are FATAL, ERROR, WARN, DEBUG, or INFO. The default level is DEBUG.

### Password Parameters
When a new tenant is onboarded, an initial administrator account named sasprovider is created. Use the following job parameters to set the password for sasprovider. These parameters are used for onboarding and are never used for offboarding. If you re-onboard an existing tenant, the password parameters are not used and the existing sasprovider password is not changed. If you do not want to set the sasprovider password to a specific value, remove all of the password parameters from the job manifest file and the account will be assigned a random password.

To reset the password, use the following steps:

1. Get the full name of the sas-tenant-onboard-job pod that was used to onboard the tenant

    ```
    kubectl get pods -n {{ name-of-namespace }} | grep sas-tenant-onboard-job
    ```
	
2. Get the password reset link from the log. This link expires 24 hours after the tenant is onboarded.

    ```
    kubectl -n {{ name-of-namespace }} logs {{ sas-tenant-onboard-job-pod-name }} | grep reset_password
    ```
   
3. Go to the link and reset the password. The full URL will take this form:

    ```
    https://<tenantID>.<hostname>/SASLogon/reset_password?code=<resetCode>
    ```
   
**SAS\_PROVIDER\_PASSWORD**

Optional. Can be used to set a single sasprovider password for all tenants being onboarded. If this parameter is set, then you should not set SAS\_PROVIDER\_PASSWORD_{{TENANT-ID}} parameters as defined below. 

**SAS\_PROVIDER\_PASSWORD_{{TENANT-ID}}**

Optional. Can be used to specify a unique sasprovider password for each tenant being onboarded. The parameter suffix should be the tenant ID. For example, to set the sasprovider password for the tenant "acme", set the job parameter SAS\_PROVIDER\_PASSWORD\_ACME. To set the password for a tenant named "cyberdyne", set the job parameter SAS\_PROVIDER\_PASSWORD\_CYBERDYNE. If these parameters are set, you should not set SAS\_PROVIDER\_PASSWORD.