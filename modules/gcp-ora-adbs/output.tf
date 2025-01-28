# Google info
output "resource_id" {
  description = "Resource ID of Autonomous Database in Google Cloud"
  value       = google_oracle_database_autonomous_database.this.id
}

output "resource" {
  description = "Resource Object of Autonomous Database in Google Cloud"
  value       = data.google_oracle_database_autonomous_database.this
}

# OCI info
output "oci_adbs_ocid" {
  description = "OCID of Autonomous Database in OCI"
  value       = google_oracle_database_autonomous_database.this.properties[0].ocid
}

output "oci_region" {
  description = "Region of the Autonomous Database in OCI"
  value       = regex("(?:region=)([^?&/]+)", google_oracle_database_autonomous_database.this.properties[0].oci_url)[0]
}

output "oci_compartment_ocid" {
  description = "Compartment OCID of the Autonomous Database in OCI"
  value       = regex("(?:compartmentId=)([^?&/]+)", google_oracle_database_autonomous_database.this.properties[0].oci_url)[0]
}

output "oci_tenant" {
  description = "Tenant of the Autonomous Database in OCI"
  value       = regex("(?:tenant=)([^?&/]+)", google_oracle_database_autonomous_database.this.properties[0].oci_url)[0]
}
