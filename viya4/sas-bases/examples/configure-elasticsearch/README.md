---
category: OpenSearch
tocprty: 10
---

# OpenSearch for SAS Viya

## Overview

[OpenSearch](https://opensearch.org/) is an Apache 2.0 licensed search and analytics suite based on Elasticsearch 7.10.2 . SAS Viya support for an internally managed search cluster is provided by a proprietary `sas-opendistro` Kubernetes operator.

If you want to use an internal instance of OpenSearch, you should refer to the README file located at
`$deploy/sas-bases/overlays/internal-elasticsearch/README.md`.

Externally managed cloud subscriptions to Elasticsearch, Open Distro for Elasticsearch and OpenSearch are not yet supported. 
 
## Operator

The sas-opendistro operator can customize the internally managed OpenSearch cluster. For operator information refer to the readme file located at
  `$deploy/sas-bases/overlays/internal-elasticsearch/README.md`.
