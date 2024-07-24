module "identity_domain" {
  source = "./oci-identity-domain"

  region              = var.region
  tenancy_id          = var.tenancy_id
  compartment_ocid    = var.compartment_ocid
  config_file_profile = var.config_file_profile

  identity_domain_name          = var.identity_domain_name
  identity_domain_configuration = var.identity_domain_configuration
}

module "identity_domain_groups" {
  source = "./oci-identity-group"

  region              = var.region
  compartment_ocid    = var.compartment_ocid
  config_file_profile = var.config_file_profile

  idcs_endpoint = module.identity_domain.idcs_endpoint
  identity_domain_groups_configuration = var.identity_domain_configuration != null ? {
    default_defined_tags  = var.identity_domain_groups_configuration != null ? var.identity_domain_groups_configuration.default_defined_tags : null
    default_freeform_tags = var.identity_domain_groups_configuration != null ? var.identity_domain_groups_configuration.default_freeform_tags : null
    groups                = merge(local.domain_groups, var.identity_domain_groups_configuration != null ? var.identity_domain_groups_configuration.groups != null ? var.identity_domain_groups_configuration.groups : {} : {})
  } : var.identity_domain_groups_configuration
}
