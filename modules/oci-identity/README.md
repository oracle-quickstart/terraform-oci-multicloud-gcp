# GCP Identity - Federation
## Introduction
Setup Identity Providers for ODB@G service.

## Providers

| Name                                                                | Version  |
|---------------------------------------------------------------------|----------|
| [oci](https://registry.terraform.io/providers/hashicorp/oci/latest) | ~> 5.0.0 |


## Inputs Variables
| VARIABLE                  |                                DESCRIPTION                                | REQUIRED | DEFAULT_VALUE |                          SAMPLE VALUE |
|:--------------------------|:-------------------------------------------------------------------------:|:--------:|--------------:|--------------------------------------:|
| `config_file_profile`     |              Authorization profile used by the OCI provider               |    NO    |     "DEFAULT" |                                       |
| `region`                  |                                OCI region.                                |   YES    |               |                        "us-ashburn-1" |
| `compartment_ocid`        |       OCI compartment for the new provider. It can be a tenancy id.       |   YES    |               |  ""ocid1.tenancy.oc1..xxxxxxxxxxxxx"" |
| `gcp_federation_xml_url`  |              URL to download the GCP metadata xml file from.              |    NO    |            "" | "https://somedomain.com/metadata.xml" |
| `gcp_federation_xml_file` |                 Local file for the GCP metadata xml file.                 |    NO    |            "" |           "//local_path/metadata.xml" |
| `idp_name`                |                          Identity provider name.                          |    NO    |      "Google" |                                       |
| `idp_description`         |                      Identity provider description.                       |    NO    |            "" |                                       |
| `domain_display_name`     |             Identity domain linked to the identity provider.              |    NO    |     "Default" |                                       |
| `group_prefix`            | Group prefix as referred on the [RBAC](../gcp-identity/README.md) module. |    NO    |            "" |                          "org_prefix" |

# Setup OCI Federation
Setting up Federation configuration on OCI.

### Setting param value

The following input tfvars _must_ be set

Either as `terraform.tfvars` file in same directory

```
config_file_profile="<MY_PROFILE_NAME>"
compartment_ocid="<MY_OCI_TENANCY_ID>"
region="<MY_REGION_IDENTIFIER>"
```

### Authentication
```
# authenticate OCI CLI for execution on a local workstation
oci session authenticate
```

### Initialize
```
$ terraform init
```
### Apply

First apply [oci-identity-domain](oci-identity-domain/README.md) module, the output of the module would be used for GCP configuration and for later steps of Federation configuration.

```
$ cd oci-identitity-domain
$ terraform init
$ terraform apply -var="compartment_ocid=<compartment_ocid>" -var="region=<region>"
$ cd ..
```

Output would include some values used to configure GCP Federation. The `acs_url` and `provider_id` ID would be needed for the identity
configuration, `next_steps` describes the steps needed to complete the Google side configuration.

During the GCP Federation configuration, get the metadata file URL or download the file to your local environment, this file would be used
for OCI configuration.

To configure OCI Identity Provider with default group names using a local metadata file:

```
$ tf apply -var="gcp_federation_xml_file=/path/metadata.xml"
```

To configure OCI Identity Provider with groups created using a prefix and a URL metadata file:

```
$ tf apply -var="gcp_federation_xml_url=<url_of_metadata_fle>" -var="group_prefix=<group_prefix>"
```