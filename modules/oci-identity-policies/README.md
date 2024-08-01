# Terraform Template to setup custom federation policies on OCI

Support module. Creates a set of OCI policies including policy statements.

## Providers

| Name                                                                  | Version |
| --------------------------------------------------------------------- | ------- |
| [OCI](https://registry.terraform.io/providers/oracle/oci/latest/docs) | n/a     |

## Inputs Variables

| VARIABLE                               |                            DESCRIPTION                             | REQUIRED | DEFAULT_VALUE | SAMPLE VALUE                                         |
|:---------------------------------------|:------------------------------------------------------------------:|:--------:|--------------:|:-----------------------------------------------------|
| `config_file_profile`                  |                        OCI CLI profile name                        |   Yes    |               | "ONBOARDING"                                         |
| `tenancy_id`                           |                            Tenancy OCID                            |   Yes    |               | "ocid1.tenancy.oc1..xxxxxxxxxxxxx"                   |
| `compartment_ocid`                     |                          Compartment OCID                          |   Yes    |               | "ocid1.tenancy.oc1..xxxxxxxxxxxxx"                   |
| `region`                               |                       OCI region Identifier                        |   Yes    |               | "us-ashburn-1"                                       |
| `google_project_number`                |     Google Project ID related to the current OCI configuration     |    No    |               | "<google_project_number>"                            |
| `identity_domain_name`                 |                Name of an existing identity domain                 |    No    |     "Default" | "ExistingDomain"                                     |
| `identity_domain_configuration`        | Identity domain definition to isolate the federation configuration |    No    |               | See [domain module](./oci-identity-domain/README.md) |
| `identity_domain_groups_configuration` |                    Additional groups to create                     |    No    |               | See [groups module](./oci-identity-group/README.md)  |

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

The policies created using this script are similar to the ones created by default and can be differentiated because the name of
the policies would include the word "Custom".

To recreate the default policies on the Default domain you can use the following domain.

```
terraform apply
```

To create the default policies using an existing identity domain.

```
terraform apply -var="identity_domain_name=<NonDefaultExistingDomainName>
```

To create a new identity domain and recreate the default groups and policies add a value for the variable `identity_domain_configuration`.

```
# on terraform.tvars
# identity_domain_configuration = {
#   display_name = "NewDomain"
#   description  = "New domain to isolate groups and policies for federation"
#   license_type = "Free"
# }

terraform apply
```

To recreate the default policies and limit the access to only a single Google Cloud project.

```
terraform apply -var="gcp_project_number=<gcp_project_number>"
```

New groups can be created by providing a value for `identity_domain_groups_configuration`

```
# on terraform.tvars
# identity_domain_groups_configuration = {
#  groups: {
#    "group_1" : {
#      name:        "Console Access Group"
#      description: "Group with access to OCI Console"
#      requestable: true
#    }
#  }
# }

terraform apply
```