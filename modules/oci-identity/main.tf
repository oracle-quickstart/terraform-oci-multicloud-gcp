module "oci-identity-provider" {
  source                  = "./oci-identity-provider"
  config_file_profile     = var.config_file_profile
  region                  = var.region
  compartment_ocid        = var.compartment_ocid
  gcp_federation_xml_file = var.gcp_federation_xml_file
  gcp_federation_xml_url  = var.gcp_federation_xml_url

  idp_name            = var.idp_name
  idp_description     = var.idp_description
  default_rule_id     = var.default_rule_id
  domain_display_name = var.domain_display_name

  jit_groups = []
  idp_group_mapping = {
    "${var.group_prefix}odbg_db_family_administrators" : "odbg-db-family-administrators"
    "${var.group_prefix}odbg_db_family_readers" : "odbg-db-family-readers"
    "${var.group_prefix}odbg_vm_cluster_administrators" : "odbg-vm-cluster-administrators"
    "${var.group_prefix}odbg_exa_infra_administrators" : "odbg-exa-infra-administrators"
    "${var.group_prefix}odbg_exa_cdb_administrators" : "odbg-exa-cdb-administrators"
    "${var.group_prefix}odbg_exa_pdb_administrators" : "odbg-exa-pdb-administrators"
    "${var.group_prefix}odbg_adbs_db_administrators" : "odbg-adbs-db-administrators"
  }
}