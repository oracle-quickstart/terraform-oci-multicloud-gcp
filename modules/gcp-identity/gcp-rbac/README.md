# Azure Identity  
## Introduction
Setup Roles Based access control for ODB@G service.

## Providers

| Name                                                                      | Version  |
|---------------------------------------------------------------------------|----------|
| [google](https://registry.terraform.io/providers/hashicorp/google/latest) | ~> 5.0.0 |


## Inputs Variables
| VARIABLE               |                           DESCRIPTION                           | REQUIRED | DEFAULT_VALUE |                                              SAMPLE VALUE |
|:-----------------------|:---------------------------------------------------------------:|:--------:|--------------:|--------------------------------------------------------:|
| `gcp_org_id`           |                      GCP Organization ID                        |   YES    |            "" | |
| `gcp_project`          |                         GCP Project ID.                         |   YES    |            "" |  |
| `odbag_built_in_roles` | Map of Role ID to Role Description for the roles to be created. |    NO    |            {} |  |
| `initial_group_config` |             Ownership of the newly created groups.              |    NO    |              WITH_INITIAL_OWNER | WITH_INITIAL_OWNER |


# Setup Roles based access
See [parent project](../README.md) to run this module with the required groups and roles.

### Authentication
There are several alternatives for GCP authentication, including
using a service account JSON credentials file or using a OAuth access
tokens.

Details on authentication options can be found on the 
[Google provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_reference#authentication) details page.

To run this module on a local workstation `gcloud auth` can be used:

```
# authenticate GCP CLI for execution on a local workstation
gcloud auth application-default login <ACCOUNT>
```

### Initialize
```
$ terraform init
```
### Apply

See [parent project](../README.md) for apply details.