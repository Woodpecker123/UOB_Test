---
category: sasProgrammingEnvironment
tocprty: 15
---

# Controlling User Access to the SET= System Option

## Overview

This document describes the customizations that can be made by the Kubernetes
administrator for controlling the access a user has to change environment
variables by way of the SET= System Option.

The SAS language includes the SET= System Option, which allows the user to
define or change the value of an environment variable in the session that
the user is working in. However, an administrator might want to limit the
ability of the user to change certain environment variables.  The steps
described in this README provide the administrator with the ability to
block specific variables from being set by the user.

## Installation

The list of environment variables that should be blocked for users to change
can be modified by using the transformer in the example file located at
`$deploy/sas-bases/examples/sas-programming-environment/options-set`.

1. Copy the
`$deploy/sas-bases/examples/sas-programming-environment/options-set/deny-options-set-variables.yaml`
file to the site-config directory.

2. To add variables that users should be prevented from changing, replace the
{{ OPTIONS-SET-DENY-LIST }} variable in the copied file with the list of
environment variables to be protected.
Here is an example:

   ```yaml
   ...
   patch : |-
     - op: add
       path: /data/SAS_OPTIONS_SET_DENY_LIST
       value: "VAR1 VAR2 VAR3"
   ...
   ```

3. After you edit the file, add a reference to it in the transformers block of
the base kustomization.yaml file (`$deploy/kustomization.yaml`).  Here is an
example assuming the file has been saved to
 `$deploy/site-config/sas-programming-environment/options-set`:

   ```yaml
   transformers:
   ...
   - site-config/sas-programming-environment/options-set/deny-options-set-variables.yaml
   ...
   ```

## Additional Resources

For more information about deployment and using example files, see the
[SAS Viya: Deployment Guide](http://documentation.sas.com/?cdcId=itopscdc&cdcVersion=default&docsetId=dplyml0phy0dkr&docsetTarget=titlepage.htm).