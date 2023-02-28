---
category: dataServer
tocprty: 8
---

# Configuration Settings for PostgreSQL Database Tuning

## Overview

PostgreSQL is highly configurable, allowing you to tune the server(s) to meet expected workloads. This README describes how to tune and adjust the configuration for your PostgreSQL clusters.

## Installation

1. Copy the file `$deploy/sas-bases/examples/crunchydata/tuning/crunchy-tuning-transformer.yaml` into your `$deploy/site-config/crunchydata/` directory.

2. Rename the copied file to something unique. SAS recommends following the naming convention `{{ TRANSFORMER-NAME }}-crunchy-tuning-transformer.yaml`. For example, a copy of the transformer targeting Platform PostgreSQL could be named `platform-postgres-crunchy-tuning-transformer.yaml`.

3. Adjust the values in your copied file following the in-line comments and the 'Customize the Configuration Settings' section that follows.

4. Add a reference to the file in the transformers block of the base kustomization.yaml (`$deploy/kustomization.yaml`). The following example shows the content based on a file named `platform-postgres-crunchy-tuning-transformer.yaml`:

   ```yaml
   transformers:
   - site-config/crunchydata/platform-postgres-crunchy-tuning-transformer.yaml
   ```

### Customize the Configuration Settings

#### PostgreSQL Configuration Parameters

You can adjust the default values in the copied transformer file to suit the needs of your deployment. If the parameters are removed, then the PostgreSQL will use its own default values, which might incur a performance degradation.

For a multi-tenant deployment, consider adjusting the 'max_connections' and 'max_prepared_transactions' values according to [Multi-Tenancy Considerations](https://pubshelpcenter.unx.sas.com/test/doc/en/sasadmincdc/v_032/caltuning/n0adso3frm5ioxn1s2kwa4vbm9db.htm#n0u9kakykv7eyrn1ckqndq34o478).

You can also add other parameters to the copied transformer file with the values you want. See the in-line comments in the copied transformer file. For the complete list of available PostgreSQL configuration parameters, see [PostgreSQL Server Configuration](https://www.postgresql.org/docs/12/config-setting.html).

#### PostgreSQL HBA Setting to Disable TLS

Deployments that are not using TLS or are using Front-Door TLS must uncomment the pg_hba entry in the copied transformer file.

#### Patroni Dynamic Configuration Settings

**Note:** SAS does not recommend changing the default Patroni settings because it might negatively impact the Patroni functionality.

If you need to change any Patroni dynamic configuration settings, add the relevent settings to the copied transformer file under the dynamicConfiguration block. For example, if you want to change the settings for 'loop_wait' and 'ttl', add them to the proper place in the copied transformer file as shown below:

```yaml
    path: /spec/patroni/dynamicConfiguration
    value:
      loop_wait: 10
      ttl: 30
      postgresql:
        parameters:
          ...
```
For the complete list of available settings, see [Patroni Dynamic Configuration Settings](https://patroni.readthedocs.io/en/latest/SETTINGS.html).


## Additional Resources

[SAS Viya Deployment Guide](http://documentation.sas.com/?cdcId=itopscdc&cdcVersion=default&docsetId=dplyml0phy0dkr&docsetTarget=titlepage.htm&locale=en)

[PostgreSQL Client Host-Based Authentication](https://www.postgresql.org/docs/12/auth-pg-hba-conf.html)