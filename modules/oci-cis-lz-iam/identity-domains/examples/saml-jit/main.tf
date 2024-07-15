module "identity_domains" {
  source       = "../../"
  tenancy_ocid = var.oci_tenancy_ocid
  identity_domain_identity_providers_configuration = var.identity_domain_identity_providers_configuration
}
