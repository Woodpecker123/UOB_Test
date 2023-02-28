# Table of Contents

## Kubernetes Tools

* [Using Kubernetes Tools from the sas-orchestration Image](./examples/kubernetes-tools/README.md)

* [Lifecycle Operation: Assess](./examples/kubernetes-tools/lifecycle-operations/assess/README.md)

* [Lifecycle Operation: Deploy](./examples/kubernetes-tools/lifecycle-operations/deploy/README.md)

* [Lifecycle Operation: Start-all](./examples/kubernetes-tools/lifecycle-operations/start-all/README.md)

* [Lifecycle Operation: Stop-all](./examples/kubernetes-tools/lifecycle-operations/stop-all/README.md)

* [Lifecycle Operation: schedule-start-stop](./examples/kubernetes-tools/lifecycle-operations/schedule-start-stop/README.md)

## SAS Viya Deployment Operator

* [SAS Viya Deployment Operator](./examples/deployment-operator/README.md)

## Mirror Registry

* [Using a Mirror Registry](./examples/mirror/README.md)

## Multi-tenancy

* [Multi-tenant Deployment](./examples/multi-tenant/README.md)

* [Onboard or Offboard Tenants Using the Tenant Job](./examples/sas-tenant-job/README.md)

## sitedefault.yaml File

* [Modify the sitedefault.yaml File](./examples/configuration/README.md)

## CAS

* [CAS Server for SAS Viya](./overlays/cas-server/README.md)

* [Create an Additional CAS Server](./examples/cas/create/README.md)

* [Configuration Settings for CAS](./examples/cas/configure/README.md)

* [Auto Resources for CAS Server for SAS Viya](./overlays/cas-server/auto-resources/README.md)

* [State Transfer for CAS Server for SAS Viya](./overlays/cas-server/state-transfer/README.md)

* [SAS GPU Reservation Service](./examples/gpu/README.md)

## SAS Programming Environment

* [LOCKDOWN Settings for the SAS Programming Environment](./examples/sas-programming-environment/lockdown/README.md)

* [Disable Generation of Java Security Policy File for SAS Programming Environment](./overlays/sas-programming-environment/java-security-policy/README.md)

* [Adding Classes to Java Security Policy File Used by SAS Programming Environment](./examples/sas-programming-environment/java-security-policy/README.md)

* [Configuring SAS Compute Server to Use SAS Watchdog](./overlays/sas-programming-environment/watchdog/README.md)

* [Configuring SAS Compute Server to Use a Personal CAS Server](./overlays/sas-programming-environment/personal-cas-server/README.md)

* [Configuring SAS Compute Server to Use a Personal CAS Server with GPU](./overlays/sas-programming-environment/personal-cas-server-with-gpu/README.md)

* [Configuration Settings for the Personal CAS Server](./examples/sas-programming-environment/personal-cas-server/README.md)

* [SAS Programming Environment Storage Tasks](./examples/sas-programming-environment/storage/README.md)

* [SAS Batch Server Storage Task for Checkpoint/Restart](./examples/sas-batch-server/storage/README.md)

* [Controlling User Access to the SET= System Option](./examples/sas-programming-environment/options-set/README.md)

* [SAS GPU Reservation Service for SAS Programming Environment](./overlays/sas-programming-environment/gpu/README.md)

## SAS Infrastructure Data Server

* [Configure PostgreSQL](./examples/postgres/README.md)

* [Configure Crunchy Data PostgreSQL](./examples/crunchydata/README.md)

* [Configuration Settings for PostgreSQL Database Tuning](./examples/crunchydata/tuning/README.md)

* [Configuration Settings for PostgreSQL Replicas Count](./examples/crunchydata/replicas/README.md)

* [Configuration Settings for PostgreSQL Backups](./examples/crunchydata/backups/README.md)

* [Configuration Settings for PostgreSQL Storage](./examples/crunchydata/storage/README.md)

* [Configuration Settings for PostgreSQL Pod Resources](./examples/crunchydata/pod-resources/README.md)

* [Upgrade to PostgreSQL Operator v5](./examples/crunchydata/pgo4upgrade/README.md)

## Redis

* [Configuration Settings for Redis](./examples/redis/server/README.md)

* [Configuration Settings for Redis Operator](./examples/redis/operator/README.md)

## Open-Source Configuration

* [Configure Python and R Integration with SAS Viya](./examples/sas-open-source-config/README.md)

* [Configure Python for SAS Viya Using a Kubernetes Persistent Volume](./examples/sas-open-source-config/python/README.md)

* [Configure Python for SAS Viya Using a Docker Image](./examples/sas-open-source-config/python-image/README.md)

* [Configure rpy2 for SAS Model Repository Service](./examples/sas-model-repository/r/README.md)

* [Configure R for SAS Viya](./examples/sas-open-source-config/r/README.md)

## High Availability and Scaling

* [High Availability (HA) in SAS Viya](./examples/scaling/ha/README.md)

* [Single Replica Scaling SAS Viya](./examples/scaling/single-replica/README.md)

* [Zero Scaling SAS Viya](./examples/scaling/zero-scale/README.md)

## Security

* [Configure Network Security and Encryption Using SAS Security Certificate Framework](./examples/security/README.md)

* [Configuring Kerberos Single Sign-On for SAS Viya](./examples/kerberos/http/README.md)

* [Configuring SAS Servers for Kerberos in SAS Viya](./examples/kerberos/sas-servers/README.md)

* [Configuring Ingress for Cross-Site Cookies](./examples/security/web/samesite-none/README.md)

* [Configure System Security Services Daemon](./examples/kerberos/sssd/README.md)

* [SAS Programming Environment Configuration Tasks](./overlays/sas-programming-environment/README.md)

* [Modify Container Security Settings](./examples/security/container-security/README.md)

## Migration

* [Migrate to SAS Viya 4](./examples/migration/README.md)

* [Migrate to SAS Viya 4](./overlays/migration/README.md)

* [Configuration Settings for SAS Viya Migration](./examples/migration/configure/README.md)

* [Uncommon Migration Customizations](./examples/migration/postgresql/README.md)

* [Convert CAS Server Definitions for Migration](./examples/migration/cas/README.md)

* [Granting Security Context Constraints for Migration on an OpenShift Cluster](./overlays/migration/openshift/README.md)

## Backup and Restore

* [SAS Viya Backup](./examples/backup/README.md)

* [Configuration Settings for SAS Viya Backup](./examples/backup/configure/README.md)

* [Configuration Settings for PostgreSQL Backup](./examples/backup/postgresql/README.md)

* [Restore a SAS Viya Deployment](./examples/restore/README.md)

* [Restore a SAS Viya Deployment](./overlays/restore/README.md)

* [Configuration Settings for SAS Viya Restore](./examples/restore/configure/README.md)

* [Uncommon Restore Customizations](./examples/restore/postgresql/README.md)

* [Configure Python for SAS Model Repository Service](./examples/sas-model-repository/python/README.md)

## Update Checker

* [Update Checker Cron Job](./examples/update-checker/README.md)

## Product-Specific Instructions

### Inventory Collector

* [Using the Inventory Collector](./examples/sas-inventory-collector/README.md)

### Model Publish service

* [Configure Git for SAS Model Publish Service](./examples/sas-model-publish/git/README.md)

* [Configure Kaniko for SAS Decisions Runtime Builder Service](./examples/sas-decisions-runtime-builder/kaniko/README.md)

* [Configure Kaniko for SAS Model Publish Service](./examples/sas-model-publish/kaniko/README.md)

### OpenSearch

* [OpenSearch for SAS Viya](./examples/configure-elasticsearch/README.md)

* [Configure an Internal OpenSearch Instance for SAS Viya](./overlays/internal-elasticsearch/README.md)

* [Configure a Default StorageClass for OpenSearch](./examples/configure-elasticsearch/internal/storage/README.md)

* [Configure a Default Topology for OpenSearch](./examples/configure-elasticsearch/internal/topology/README.md)

* [Configure a Run User for OpenSearch](./examples/configure-elasticsearch/internal/run-user/README.md)

* [OpenSearch on Red Hat OpenShift](./examples/configure-elasticsearch/internal/openshift/README.md)

* [OpenSearch Security Audit Logs](./examples/configure-elasticsearch/internal/security-audit-logs/README.md)

### RabbitMQ

* [Configuration Settings for RabbitMQ](./examples/rabbitmq/configuration/README.md)

### SAS Compute Server

* [Configuration Settings for Compute Server](./examples/sas-compute-server/configure/README.md)

### SAS Compute Service

* [Update Compute Service Internal HTTP Request Timeout](./examples/compute/client-request-timeout/README.md)

### SAS Configurator for Open Source

* [SAS Configurator for Open Source Options](./examples/sas-pyconfig/README.md)

### SAS Data Catalog

* [Configure SAS Data Catalog to Use JanusGraph](./overlays/data-catalog/README.md)

### SAS Data Quality

* [Quality Knowledge Base for SAS Viya](./examples/data-quality/storageclass/README.md)

* [SAS Quality Knowledge Base Maintenance Scripts](./examples/data-quality/scripts/README.md)

### SAS Image Staging

* [SAS Image Staging Configuration Options](./examples/sas-prepull/README.md)

### SAS Launcher Service

* [Configuration Settings for SAS Launcher Service](./examples/sas-launcher/configure/README.md)

* [Configuring SAS Launcher Service to Disable the Resource Exhaustion Protection](./overlays/sas-launcher/README.md)

### SAS Micro Analytic Service

* [Configure SAS Micro Analytic Service to Support Analytic Stores](./examples/sas-microanalytic-score/astores/README.md)

* [Configure CPU and Memory Resources for SAS Micro Analytic Service](./examples/sas-microanalytic-score/resources/README.md)

* [Configure SAS Micro Analytic Service to Support Archive for Log Step Execution](./examples/sas-microanalytic-score/archive/README.md)

* [Configuration Settings for SAS Micro Analytic Service](./examples/sas-microanalytic-score/config/README.md)

* [Configure SAS Micro Analytic Service to Add Service Account](./overlays/sas-microanalytic-score/service-account/README.md)

### SAS Natural Language Understanding

* [Reduce Memory Resources for SAS Natural Language Understanding](./overlays/sas-natural-language-understanding/resources/README.md)

### SAS Startup Sequencer

* [Controlling SAS Viya Start-Up Sequence](./examples/startup/README.md)

### SAS Viya File Service

* [Change Alternate Data Storage for SAS Viya File Service](./overlays/sas-files/README.md)

* [Configure SAS Viya File Service for Azure Blob Storage](./examples/azure/blob/README.md)

### SAS/ACCESS

* [Configuring SAS/ACCESS and Data Connectors for SAS Viya 4](./examples/data-access/README.md)

### SAS/CONNECT Spawner

* [Configure SAS/CONNECT Spawner in SAS Viya](./examples/sas-connect-spawner/README.md)

* [Granting Security Context Constraints on an OpenShift Cluster for SAS/CONNECT](./examples/sas-connect-spawner/openshift/README.md)

## Uncategorized

* [SAS Audit Archive Configuration](./examples/sas-audit/archive/README.md)

