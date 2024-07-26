# OCI Identity - Federation
## Introduction
Support module. Search groups inside an identity domain. This is used by other modules when
setting up identity provider configuration.

## Providers

| Name                                                                | Version  |
|---------------------------------------------------------------------|----------|
| [oci](https://registry.terraform.io/providers/hashicorp/oci/latest) | ~> 5.0.0 |


## Inputs Variables
| VARIABLE                 |                          DESCRIPTION                           | REQUIRED | DEFAULT_VALUE |                                        SAMPLE VALUE |
|:-------------------------|:--------------------------------------------------------------:|:--------:|--------------:|----------------------------------------------------:|
| `oci_domain_url`         |                  URL of the identity domain.                   |   YES    |            "" | https://idcs-xxxxxxxxx.identity.pint.oracle.com:443 |
| `group_name`             |                Name of the group to search for.                |   YES    |            "" |                                 "Sample Group Name" |
| `fail_on_missing_group`  | Indicates if a missing group should fail the module execution. |    NO    |          true |                                               false |


## Output Variables
| VARIABLE    | DESCRIPTION                                                 | SAMPLE VALUE |
|:------------|:------------------------------------------------------------|:-------------|
| `group_id`  | The ID of the group in the context of the identity domain.  | xxxxxxxx     |

### Apply

See [parent project](../README.md) for apply details.