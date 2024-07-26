# Terraform Template to setup federation policies on OCI

Support module. Creates a set of OCI policies including policy statements.

## Providers

| Name                                                                  | Version |
| --------------------------------------------------------------------- | ------- |
| [OCI](https://registry.terraform.io/providers/oracle/oci/latest/docs) | n/a     |

## Inputs Variables

| VARIABLE                   |        DESCRIPTION        | REQUIRED | DEFAULT_VALUE | SAMPLE VALUE                                                                                                                                                                                                                                                                                                                                             |
|:---------------------------|:-------------------------:|:--------:|--------------:|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `config_file_profile`      |   OCI CLI profile name    |   Yes    |               | "ONBOARDING"                                                                                                                                                                                                                                                                                                                                             |
| `compartment_ocid`         |       Tenancy OCID        |   Yes    |               | "ocid1.tenancy.oc1..xxxxxxxxxxxxx"                                                                                                                                                                                                                                                                                                                       |
| `region`                   |   OCI region Identifier   |   Yes    |               | "us-ashburn-1"                                                                                                                                                                                                                                                                                                                                           |
| `identity_domain_policies` | Map of policies to create |   Yes    |               | <pre>{<br/>  policies = {<br/>    name        = "Sample policy"<br/>    description = "Sample policy description"<br/>    statements  = [<br />    {<br/>      group             = "group_name"<br />      permission        = "manage network"<br/>      tenancy_statement = false<br />      where             = "!request.operation"<br/>    }]<br/>} |

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

Review execution details for [oci-identity-policies](../README.md). That module defines the required configuration
for default groups and policies.