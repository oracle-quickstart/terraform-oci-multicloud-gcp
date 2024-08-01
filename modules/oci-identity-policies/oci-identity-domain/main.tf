# Copyright (c) 2024 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

data "oci_identity_regions" "these" {}

data "oci_identity_tenancy" "this" {
  tenancy_id = var.tenancy_id
}

locals {
  regions_map     = { for r in data.oci_identity_regions.these.regions : r.key => r.name }
  home_region_key = data.oci_identity_tenancy.this.home_region_key
}

resource "oci_identity_domain" "identity_domain" {
  count          = var.identity_domain_configuration != null ? 1 : 0
  compartment_id = var.compartment_ocid

  display_name = var.identity_domain_configuration.display_name
  description  = var.identity_domain_configuration.description
  home_region  = var.identity_domain_configuration.home_region != null ? var.identity_domain_configuration.home_region : local.regions_map[local.home_region_key]
  license_type = var.identity_domain_configuration.license_type

  admin_email      = var.identity_domain_configuration.admin_email
  admin_first_name = var.identity_domain_configuration.admin_first_name
  admin_last_name  = var.identity_domain_configuration.admin_last_name
  admin_user_name  = var.identity_domain_configuration.admin_user_name

  is_hidden_on_login        = var.identity_domain_configuration.is_hidden_on_login
  is_notification_bypassed  = var.identity_domain_configuration.is_notification_bypassed
  is_primary_email_required = var.identity_domain_configuration.is_primary_email_required

  defined_tags  = var.identity_domain_configuration.defined_tags
  freeform_tags = var.identity_domain_configuration.freeform_tags
}

data "oci_identity_domains" "existing_domain" {
  count          = var.identity_domain_configuration == null ? 1 : 0
  compartment_id = var.compartment_ocid

  display_name = var.identity_domain_name

  lifecycle {
    postcondition {
      condition     = length(self.domains) == 1
      error_message = "Unable to find group with name '${self.display_name}' and no identity_domain_configuration was provided"
    }
  }
}

output "idcs_endpoint" {
  value = var.identity_domain_configuration != null ? oci_identity_domain.identity_domain[0].url : data.oci_identity_domains.existing_domain[0].domains[0].url
}

output "idcs_display_name" {
  value = var.identity_domain_configuration != null ? oci_identity_domain.identity_domain[0].display_name : data.oci_identity_domains.existing_domain[0].domains[0].display_name
}