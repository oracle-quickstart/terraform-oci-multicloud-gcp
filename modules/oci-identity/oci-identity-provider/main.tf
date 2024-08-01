terraform {
  required_providers {
    oci = {
      source  = "hashicorp/oci"
      version = ">= 5.0.0" # -- for local module run
    }
  }
}

# uncomment below for local module run -- start
# provider "oci" {
#   auth                = "SecurityToken"
#   config_file_profile = var.config_file_profile
#   region              = var.region
# }
# uncomment -- end

locals {
  jit_groups        = var.jit_groups
  group_prefix      = var.group_prefix
  idp_group_mapping = var.idp_group_mapping
}

# https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/identity_domains
data "oci_identity_domains" "list_domain" {
  compartment_id = var.compartment_ocid
  display_name   = var.domain_display_name
}

locals {
  oci_domain_url = data.oci_identity_domains.list_domain.domains[0].url
}

# Fetch GCP federation metadata url
data "http" "gcp_federation_xmldata_http" {
  count = var.gcp_federation_xml_url != "" ? 1 : 0
  url = var.gcp_federation_xml_url
}

locals {
  gcp_federation_xmldata = var.gcp_federation_xml_url != "" ? replace(data.http.gcp_federation_xmldata_http[0].response_body, "\ufeff", "") : file(var.gcp_federation_xml_file)
}

module "jit_groups" {
  source = "../oci-identity-provider-group"

  oci_domain_url = local.oci_domain_url
  group_name     = "${local.group_prefix}${each.key}"

  for_each = local.jit_groups
}

module "idp_related_groups" {
  source = "../oci-identity-provider-group"

  oci_domain_url = local.oci_domain_url
  group_name     = each.value

  for_each = local.idp_group_mapping
}

# Create SAML identity provider
# https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_domains_identity_provider
resource "oci_identity_domains_identity_provider" "new_saml_idp" {
  lifecycle {
    precondition {
      condition     = var.gcp_federation_xml_file != "" || var.gcp_federation_xml_url != ""
      error_message = "Either gcp_federation_xml_file or gcp_federation_xml_url need to be provided."
    }
  }

  #Required
  enabled       = true
  idcs_endpoint = local.oci_domain_url
  partner_name  = var.idp_name
  schemas       = ["urn:ietf:params:scim:schemas:oracle:idcs:IdentityProvider"]
  #Optional but required for our purpose
  description = var.idp_description
  type        = "SAML"
  metadata    = local.gcp_federation_xmldata
  signature_hash_algorithm     = "SHA-256"
  user_mapping_method          = "NameIDToUserAttribute"
  user_mapping_store_attribute = "userName"
  name_id_format               = "saml-emailaddress"

  jit_user_prov_enabled                           = true
  jit_user_prov_create_user_enabled               = true
  jit_user_prov_attribute_update_enabled          = true
  jit_user_prov_group_assertion_attribute_enabled = true
  jit_user_prov_group_assignment_method           = "Overwrite"
  jit_user_prov_group_saml_attribute_name         = "MemberOf"
  jit_user_prov_group_static_list_enabled         = true
  jit_user_prov_ignore_error_on_absent_groups     = true
  jit_user_prov_group_mapping_mode                = "explicit"

  dynamic "jit_user_prov_assigned_groups" {
    for_each = local.jit_groups
    content {
      value = module.jit_groups[jit_user_prov_assigned_groups.value].group_id
    }
  }

  dynamic "jit_user_prov_group_mappings" {
    for_each = local.idp_group_mapping
    content {
      idp_group = jit_user_prov_group_mappings.key
      value     = module.idp_related_groups[jit_user_prov_group_mappings.key].group_id
    }
  }
}


locals {
  new_saml_idp_id = oci_identity_domains_identity_provider.new_saml_idp.id
}

output "new_saml_idp_id" {
  value = local.new_saml_idp_id
}

# Patch identity domain policy rule and MappedAttribute
resource "terraform_data" "patch_identity_domain" {
  depends_on = [
    oci_identity_domains_identity_provider.new_saml_idp
  ]

  provisioner "local-exec" {
    working_dir = path.module
    command     = "pip3 install -r scripts/requirements.txt"
  }

  provisioner "local-exec" {
    working_dir = path.module
    command     = "python3 scripts/patch_identity_domain_rule.py -p '${var.config_file_profile}' -u '${local.oci_domain_url}' -r '${var.default_rule_id}' -i '${local.new_saml_idp_id}'"
  }

  provisioner "local-exec" {
    working_dir = path.module
    command     = "python3 scripts/patch_identity_domain_attribute_mapping.py -p '${var.config_file_profile}'  -u '${local.oci_domain_url}' -i '${local.new_saml_idp_id}'"
  }
}