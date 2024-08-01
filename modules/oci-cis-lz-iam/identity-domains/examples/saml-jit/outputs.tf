output "identity-domain-identity-providers" {
  description = "The identity domain identity providers."
  value       = module.identity_domains.identity_domain_identity_providers
}

resource "local_file" "identity-domain-metadata" {
  content  = module.identity_domains.identity_domain_saml_metadata[keys(module.identity_domains.identity_domain_saml_metadata)[0]]
  filename = "./identity-domain-metadata.xml"
}