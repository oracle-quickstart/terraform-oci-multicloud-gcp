terraform {
  required_providers {
    oci = {
      source = "hashicorp/oci"
      version = ">= 5.0.0"# -- for local module run
    }
  }
}

# uncomment below for local module run -- start
# provider "oci" {
#  auth                = "SecurityToken"
#  config_file_profile = var.config_file_profile
#  region              = var.region
# }
# uncomment -- end

# https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/identity_domains
data "oci_identity_domains" "list_domain" {
  compartment_id = var.compartment_ocid
  display_name   = var.domain_display_name
}

locals {
  oci_domain_url = data.oci_identity_domains.list_domain.domains[0].url
}



# https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/identity_domains_setting
data "oci_identity_domains_setting" "domain_setting" {
  #Required
  idcs_endpoint = local.oci_domain_url
  setting_id    = "Settings"

  #Optional
  attribute_sets = ["all"]
}


# https://registry.terraform.io/providers/oracle/oci/5.40.0/docs/resources/identity_domains_setting
resource "oci_identity_domains_setting" "domain_setting" {
  #Required
  csr_access    = "readWrite"
  idcs_endpoint = local.oci_domain_url
  schemas       = ["urn:ietf:params:scim:schemas:oracle:idcs:Settings"]
  setting_id    = "Settings"

  # Optional
  attribute_sets             = ["all"]
  signing_cert_public_access = true
  # to counter auto-updates
  contact_emails                        = data.oci_identity_domains_setting.domain_setting.contact_emails
  custom_branding                       = data.oci_identity_domains_setting.domain_setting.custom_branding
  locale                                = data.oci_identity_domains_setting.domain_setting.locale
  service_admin_cannot_list_other_users = data.oci_identity_domains_setting.domain_setting.service_admin_cannot_list_other_users
  timezone                              = data.oci_identity_domains_setting.domain_setting.timezone

}
