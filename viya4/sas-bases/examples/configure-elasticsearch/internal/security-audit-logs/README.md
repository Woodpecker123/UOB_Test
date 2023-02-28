---
category: OpenSearch
tocprty: 70
---

# OpenSearch Security Audit Logs

## Overview 

Security audit logs track a range of OpenSearch cluster events. The OpenSearch audit logs can provide beneficial information for compliance purposes or assist in the aftermath of a security breach.

The audit logs are written to audit indices in the OpenSearch cluster. Audit indices use additional resources. Therefore, it may be preferable to disable the OpenSearch security logging in the cluster.

**Note:** By default, audit logging is enabled for additional security. 

## Disable Security Audit Logs 

1. Copy the disable security audit transformer from `$deploy/sas-bases/examples/configure-elasticsearch/internal/security-audit-logs/disable-security-audit-transformer.yaml` into the `$deploy/site-config` directory.

2. Add the disable-security-audit-transformer.yaml file to the transformers block of the base kustomization.yaml file (`$deploy/kustomization.yaml`). Here is an example:
   
   ```yaml
   transformers:
   ...
   - site-config/disable-security-audit-transformer.yaml
   ```

## Additional Resources 

For more information on OpenSearch audit logs, see the [OpenSearch Documentation](https://opensearch.org/docs/latest/).