# Provision Autonomous Database @ Google Cloud with minimal inputs

This example provision a Autonomous Database @ Google Cloud by using the quickstart template directly with minimal input.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_gcp-oci-adbs-quickstart"></a> [gcp-oci-adbs-quickstart](#module\_gcp-oci-adbs-quickstart) | ../../templates/gcp-oci-adbs-quickstart | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_project"></a> [project](#input\_project) | The ID of the project in which the resource belongs. If it is not provided, the provider project is used. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | GCP region where Autonmous Database is hosted. | `string` | n/a | yes |
| <a name="input_network_name"></a> [network\_name](#input\_network\_name) | The name of the VPC network used by the Autonomous Database | `string` | n/a | yes |
| <a name="input_cidr"></a> [cidr](#input\_cidr) | The subnet CIDR range for the Autonmous Database | `string` | n/a | yes |
| <a name="input_customer_email"></a> [customer\_email](#input\_customer\_email) | The email address used by Oracle to send notifications regarding databases and infrastructure. | `string` | n/a | yes |
| <a name="input_admin_password"></a> [admin\_password](#input\_admin\_password) | The password for the default ADMIN user | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_adbs_ocid"></a> [adbs\_ocid](#output\_adbs\_ocid) | OCID of this Autonomous Database @ Google Cloud |
