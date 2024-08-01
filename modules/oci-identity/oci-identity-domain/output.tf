
output "domain_url" {
  value = local.oci_domain_url
}

output "provider_id" {
  value = "${local.oci_domain_url}/fed"
}

output "acs_url" {
  value = "${local.oci_domain_url}/fed/v1/sp/sso"
}

output "domain_metadata_xml_url" {
  value = "${local.oci_domain_url}/fed/v1/metadata"
}

# TODO: URL for instructions on GCP configuration needs to be used instead of Azure instructions.
output "next_steps" {
  value = "For next steps see CHANGE_TO_GCP! https://docs.oracle.com/en-us/iaas/Content/Identity/tutorials/azure_ad/sso_azure/azure_sso.htm CHANGE_TO_GCP"
}