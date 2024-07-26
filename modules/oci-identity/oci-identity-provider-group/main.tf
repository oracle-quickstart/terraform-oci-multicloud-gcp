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
  oci_domain_url = var.oci_domain_url
  group_name = var.group_name
  fail_on_missing_group = var.fail_on_missing_group
}

data "oci_identity_domains_groups" "identity_groups" {
  idcs_endpoint = local.oci_domain_url
  group_filter = "displayName eq \"${local.group_name}\""
  attributes = "id"

  lifecycle {
    postcondition {
      condition = length(self.groups) == 1 || !local.fail_on_missing_group
      error_message = "Unable to find group with filter '${local.group_name}'"
    }
  }
}

output "group_id" {
  value = length(data.oci_identity_domains_groups.identity_groups.groups) > 0 ? data.oci_identity_domains_groups.identity_groups.groups[0].id : ""
}