# Provision Autonomous Database @ Google Cloud with minimal inputs

This example provision a Autonomous Database @ Google Cloud by using the [gcp-oci-adbs-quickstart](#module\_gcp-oci-adbs-quickstart) template with minimal input.

## Example
![https://gstatic.com/cloudssh/images/open-btn.svg](https://console.cloud.google.com/cloudshell/open?cloudshell_git_repo=https%3A%2F%2Fgithub.com%2Foracle-quickstart%2Fterraform-oci-multicloud-gcp.git&cloudshell_image=gcr.io%2Fcloudshell-images%2Fcloudshell%3Alatest&cloudshell_print=.%2Fmotd&cloudshell_tutorial=.%2FREADME.md&cloudshell_working_dir=.%2Fexamples%2Fadbs-minimal&open_in_editor=main.tf&cloudshell_git_branc=adbs-ai)

```tf
module "gcp-oci-adbs-quickstart" {
  # source = "github.com/oracle-quickstart/terraform-oci-multicloud-gcp//templates/gcp-oci-adbs-quickstart"
  source = "../../templates/gcp-oci-adbs-quickstart"
  project = "example"
  location = "europe-west2"  
  network_name = "example-vpc"
  cidr = "10.1.0.0/24"
  customer_email = "your_email@here"
  admin_password = "DoNotKeepThis$1234"
}

output "adbs_ocid" {
  description = "OCID of this Autonomous Database @ Google Cloud"
  value = module.gcp-oci-adbs-quickstart.oci_adbs_ocid
}
```

## Architecture
![gcp-oci-adbs-quickstart](../../images/gcp-oci-adbs-quickstart.png)
