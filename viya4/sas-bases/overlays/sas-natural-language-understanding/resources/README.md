---
category: SAS Natural Language Understanding
tocprty: 3
---

# Reduce Memory Resources for SAS Natural Language Understanding

## Overview

The SAS Natural Language Understanding service requires at least 4 GB of
memory to run. If you do not use SAS Conversation Designer or the SAS
Natural Language Understanding API, you can reduce the memory resources
allocated by 3.5 GB by using the disable-parser-transformer.yaml file in
the
`$deploy/sas-bases/overlays/sas-natural-language-understanding/resources`
directory.

If the overlay is applied, SAS Conversation Designer and the SAS Natural
Language Understanding API may return error messages when accessed.

## Installation

1. In the base kustomization.yaml in the `$deploy` directory, add
   sas-bases/overlays/sas-natural-language-understanding/resources/disable-parser-transformer.yaml
   to the transformers block.

   Here is an example:

   ```yaml
   ...
   transformers:
   ...
   - sas-bases/overlays/sas-natural-language-understanding/resources/disable-parser-transformer.yaml
   ...
   ```

2. Deploy the software using the commands in
   [SAS Viya: Deployment Guide](https://documentation.sas.com/?cdcId=itopscdc&cdcVersion=default&docsetId=dplyml0phy0dkr&docsetTarget=p127f6y30iimr6n17x2xe9vlt54q.htm).

   ***Note:*** The overlay can be applied during the initial deployment
   of SAS Viya or after the deployment of SAS Viya.

## Verify the Changes

1. Run the following command to see the current value of the memory
   request:

   ```sh
   kubectl get -n <name-of-namespace> deploy sas-natural-language-understanding -o jsonpath='{.spec.template.spec.containers[0].resources.requests.memory}'
   ```

   If the output value is "650M", then the memory request is set
   correctly. If you do not get the result described in this step,
   perform the Installation steps again.

2. Run the following command to see the environment variables set for
   the container:

   ```sh
   kubectl get -n <name-of-namespace> deploy sas-natural-language-understanding -o jsonpath='{.spec.template.spec.containers[0].env}'
   ```

   If an environment variable named SAS_NLU_ENABLE_DEPENDENCY_PARSER
   exists in the output array with a value of "false", then it has been
   added correctly. If you do not get the result described in this step,
   perform the Installation steps again.

## Uninstallation

If you previously applied the overlay and now want to use SAS
Conversation Designer or the SAS Natural Language Understanding API,
you can uninstall the overlay using the following steps:

1. In the base kustomization.yaml in the `$deploy` directory, remove
   sas-bases/overlays/sas-natural-language-understanding/resources/disable-parser-transformer.yaml
   from the transformers block.

2. Deploy the software using the commands in
   [SAS Viya: Deployment Guide](https://documentation.sas.com/?cdcId=itopscdc&cdcVersion=default&docsetId=dplyml0phy0dkr&docsetTarget=p127f6y30iimr6n17x2xe9vlt54q.htm).

## Additional Resources

* [SAS Viya: Deployment Guide](http://documentation.sas.com/?cdcId=itopscdc&cdcVersion=default&docsetId=dplyml0phy0dkr&docsetTarget=titlepage.htm)
* [Resource Requests and Limits for Pods in Kubernetes](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#requests-and-limits)