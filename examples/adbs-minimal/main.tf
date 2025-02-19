module "gcp-oci-adbs-quickstart" {
  # source = "github.com/oracle-quickstart/terraform-oci-multicloud-gcp//templates/gcp-oci-adbs-quickstart"
  source = "../../templates/gcp-oci-adbs-quickstart"
  
  project = "example"
  customer_email = "your_email@here"
  admin_password = var.admin_password

  location = "europe-west2"  
  network_name = "example-vpc"
  cidr = "10.1.0.0/24"

}

output "adbs_ocid" {
  description = "OCID of this Autonomous Database @ Google Cloud"
  value = module.gcp-oci-adbs-quickstart.oci_adbs_ocid
}