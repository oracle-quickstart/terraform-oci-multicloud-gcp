# GCP Identity - Federation
## Introduction
Setup Identity Providers for ODB@G service.

## Providers

| Name                                                                | Version  |
|---------------------------------------------------------------------|----------|
| [oci](https://registry.terraform.io/providers/hashicorp/oci/latest) | ~> 5.0.0 |


## Inputs Variables
| VARIABLE                  |                          DESCRIPTION                          | REQUIRED | DEFAULT_VALUE |                          SAMPLE VALUE |
|:--------------------------|:-------------------------------------------------------------:|:--------:|--------------:|--------------------------------------:|
| `config_file_profile`     |        Authorization profile used by the OCI provider         |    NO    |     "DEFAULT" |                                       |
| `region`                  |                          OCI region.                          |   YES    |               |                        "us-ashburn-1" |
| `compartment_ocid`        | OCI compartment for the new provider. It can be a tenancy id. |   YES    |               |  ""ocid1.tenancy.oc1..xxxxxxxxxxxxx"" |
| `gcp_federation_xml_url`  |        URL to download the GCP metadata xml file from.        |    NO    |            "" | "https://somedomain.com/metadata.xml" |
| `gcp_federation_xml_file` |           Local file for the GCP metadata xml file.           |    NO    |            "" |           "//local_path/metadata.xml" |
| `idp_name`                |                    Identity provider name.                    |    NO    |      "Google" |                                       |
| `idp_description`         |                Identity provider description.                 |    NO    |            "" |                                       |
| `domain_display_name`     |       Identity domain linked to the identity provider.        |    NO    |     "Default" |                                       |
| `jit_groups`              |        List of groups to be assigned to new JIT users.        |    NO    |            [] |               ["odbag-adbs-db-users"] |
| `group_prefix`            |        Group prefix to add to each jit_groups element.        |    NO    |            "" |                          "org_prefix" |
| `idp_group_mapping`       |            Mapping between IDP and domain groups.             |    NO    |            {} | {"idp-group-1":"odbag-adbs-db-users"} |

## Output Variables
| VARIABLE          | DESCRIPTION                               | SAMPLE VALUE |
|:------------------|:------------------------------------------|:-------------|
| `new_saml_idp_id` | The ID of the new SAML Identity Provider. | xxxxxxxxxx   |

# Setup OCI Federation
Setting up Federation configuration on OCI.

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

See [parent project](../README.md) for apply details.