locals {
  policy_configuration = {
    supplied_policies = {
      for name, config in var.identity_domain_policies.policies : name => {
        name : config.name
        description : config.description
        compartment_id : var.compartment_ocid
        statements : [
          for policy in config.statements :
          "ALLOW group ${policy.group} TO ${policy.permission} IN %{if coalesce(policy.tenancy_statement, false)}tenancy%{else}compartment id ${var.compartment_ocid}%{endif}%{if policy.where != null} WHERE ${policy.where}%{endif}"
        ]
      }
    }
  }
}

module "identity_policies" {
  # Reference to cis landing zone can use github.com instead of local source, the referenced version needs to support terraform newer than 1.3
  source = "../policies"

  tenancy_ocid = var.tenancy_ocid
  policies_configuration = local.policy_configuration
}