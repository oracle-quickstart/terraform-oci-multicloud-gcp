# Info for Google Cloud
output "resource_id" {
  description = "Resource Identifier of Autonomous Database in Google Cloud"
  value       = module.google_ora_adbs.resource_id
}

output "location" {
  description = "The location of the resource in Google Cloud."
  value       = module.google_ora_adbs.resource.location
}

output "autonomous_database_id" {
  description = "The ID of the AutonomousDatabase in Google Cloud."
  value       = module.google_ora_adbs.resource.autonomous_database_id
}

output "project" {
  description = "The Project of the AutonomousDatabase in Google Cloud."
  value       = module.google_ora_adbs.resource.project
}

# Info for OCI
output "oci_adbs_ocid" {
  description = "OCID of Autonomous Database in OCI"
  value       = module.google_ora_adbs.oci_adbs_ocid
}

output "oci_tenant" {
  description = "The OCI tenant of the Autonomous Database"
  value       = module.google_ora_adbs.oci_tenant
}

output "oci_region" {
  description = "Region of the Autonomous Database in OCI"
  value       = module.google_ora_adbs.oci_region
}

output "oci_compartment_ocid" {
  description = "Compartment OCID of the Autonomous Database in OCI"
  value       = module.google_ora_adbs.oci_compartment_ocid
}
