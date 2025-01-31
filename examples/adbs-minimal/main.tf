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