
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