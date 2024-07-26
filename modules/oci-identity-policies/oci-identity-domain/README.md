# Terraform Template to setup federation policies on OCI

Support module. Creates a set of OCI policies including policy statements.

## Providers

| Name                                                                  | Version |
| --------------------------------------------------------------------- | ------- |
| [OCI](https://registry.terraform.io/providers/oracle/oci/latest/docs) | n/a     |

## Inputs Variables

| VARIABLE                         |               DESCRIPTION                | REQUIRED | DEFAULT_VALUE | SAMPLE VALUE                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
|:---------------------------------|:----------------------------------------:|:--------:|--------------:|:----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `config_file_profile`            |           OCI CLI profile name           |   Yes    |               | "ONBOARDING"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| `compartment_ocid`               |               Tenancy OCID               |   Yes    |               | "ocid1.tenancy.oc1..xxxxxxxxxxxxx"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| `region`                         |          OCI region Identifier           |   Yes    |               | "us-ashburn-1"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| `identity_domain_name`           |   Name of an existing identity domain    |    No    |     "Default" |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| `identity_domain_configuration`  | Configuration for a new identity domain  |   No     |               | <pre>{<br/>  name                      = "domain_name"<br/>  description               = "domain description"<br />  compartment_id            = "ocid1.compartment.oc1..xxxxxxx"<br/>  home_region               = "us-ashburn-1"<br/>  license_type              = "Free"<br/>  admin_email               = "<sample_email>"<br/>  admin_first_name          = "First Name"<br/>  admin_last_name           = "Last Name"<br />  admin_user_name           = "admin"<br/>  is_hidden_on_login        = false<br/>  is_notification_bypassed  = false<br/>  is_primary_email_required = true<br/>} |

## Output Variables

| VARIABLE            | DESCRIPTION                           | SAMPLE VALUE                                        |
|:--------------------|:--------------------------------------|:----------------------------------------------------|
| `idcs_endpoint`     | URL for the identity domain.          | https://idcs-xxxxxxxxx.identity.pint.oracle.com:443 |
| `idcs_display_name` | Display name for the identity domain. | Default                                             |


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