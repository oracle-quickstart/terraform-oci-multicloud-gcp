# Terraform Template to setup federation groups on OCI

Support module. Creates a set of OCI groups for user federation.

## Providers

| Name                                                                  | Version |
| --------------------------------------------------------------------- | ------- |
| [OCI](https://registry.terraform.io/providers/oracle/oci/latest/docs) | n/a     |

## Inputs Variables

| VARIABLE                               |                 DESCRIPTION                 | REQUIRED | DEFAULT_VALUE | SAMPLE VALUE                                                                                                                                                                                                                                                                                                                                                             |
|:---------------------------------------|:-------------------------------------------:|:--------:|--------------:|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `config_file_profile`                  |            OCI CLI profile name             |   Yes    |               | "ONBOARDING"                                                                                                                                                                                                                                                                                                                                                             |
| `compartment_ocid`                     |                Tenancy OCID                 |   Yes    |               | "ocid1.tenancy.oc1..xxxxxxxxxxxxx"                                                                                                                                                                                                                                                                                                                                       |
| `region`                               |            OCI region Identifier            |   Yes    |               | "us-ashburn-1"                                                                                                                                                                                                                                                                                                                                                           |
| `idcs_enpoint`                         |         Identity provider endpoint          |   Yes    |               | https://idcs-xxxxxxxxx.identity.pint.oracle.com:443                                                                                                                                                                                                                                                                                                                      |
| `identity_domain_groups_configuration` | Configuration for new groups to be created. |   Yes    |               | <pre>{<br/>  default_defined_tags  = var.default_defined_tags<br/>  default_freeform_tags = var.default_freeform_tags<br/>  groups                = {<br/>    name          = "group_name"<br/>    description   = "group description"<br/>    requestable   = true<br/>    members       = ["user_1", "user_2"]<br/>    freeform_tags = var.freeform_tags<br/>  }<br/>} |

### Setting param value

The following input tfvars _must_ be set

Either as `terraform.tfvars` file in same directory

```
config_file_profile="<MY_PROFILE_NAME>"
compartment_ocid="<MY_OCI_TENANCY_ID>"
region="<MY_REGION_IDENTIFIER>"
```

Or running as command line parameter

```
terraform apply -var="config_file_profile=ONBOARDING"  -var='compartment_ocid=ocid1.tenancy.oc1..xxxxxxxxxxxxx' -var='region=us-ashburn-1'
```

### Authentication

```
# authenticate OCI cli
oci session authenticate --region=<region-identifier>
```

### Execution

Review execution details for the [parent module](../README.md). That module defines the required configuration
for default groups and policies.