resource "oci_identity_policy" "identity_policies" {
  compartment_id = var.compartment_ocid
  name           = each.value.name
  description    = each.value.description == null ? each.value.name : each.value.description

  statements = [for policy in each.value.statements : "ALLOW group ${policy.group} TO ${policy.permission} IN %{if coalesce(policy.tenancy_statement, false)}tenancy%{else}compartment id ${var.compartment_ocid}%{endif}%{if policy.where != null} WHERE ${policy.where}%{endif}"]

  for_each = var.identity_domain_policies.policies
}