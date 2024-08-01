# GCP Identity - RBAC 
## Introduction
Setup Roles Based access control for ODB@G service.

## Providers

| Name                                                                      | Version  |
|---------------------------------------------------------------------------|----------|
| [google](https://registry.terraform.io/providers/hashicorp/google/latest) | ~> 5.0.0 |


## Inputs Variables
| VARIABLE               |                DESCRIPTION                 | REQUIRED | DEFAULT_VALUE |       SAMPLE VALUE |
|:-----------------------|:------------------------------------------:|:--------:|--------------:|-------------------:|
| `gcp_org_id`           |            GCP Organization ID             |   YES    |            "" |                    |
| `gcp_project`          |              GCP Project ID.               |   YES    |            "" |                    |
| `gcp_region`           |   GCP Region.                              |    NO    |            "" |       "us-east-1"  |
| `group_prefix`         | Custom role prefix for all created groups. |    NO    |            {} |                    |
| `initial_group_config` |   Ownership of the newly created groups.   |    NO    |              WITH_INITIAL_OWNER | WITH_INITIAL_OWNER |


# Setup Roles based access
Setting up RBAC for Exa and ADB-S in Azure using default group names.

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

To create the default ODB@G roles using non-custom names

```
$ terraform apply -var="gcp_org_id=<org_id>" -var="gcp_project=<project_id>"
```

To create ODB@G roles using a custom prefix.

```
$ terraform apply -var="gcp_org_id=<org_id>" -var="gcp_project=<project_id>" -var="group_prefix=<custom_prefix>"
```