output "adbs_ocid" {
  description = "OCID for this Autonomous Database@Google Cloud"
  value = module.gcp-oci-adbs-quickstart.oci_adbs_ocid
}

output "adbs_dbid" {
  description = "DBID of this Autonomous Database@Google Cloud"
  value = module.gcp-oci-adbs-quickstart.autonomous_database_id
}