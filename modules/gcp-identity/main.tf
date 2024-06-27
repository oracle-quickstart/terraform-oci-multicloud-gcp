terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}


locals {
  gcp_org_id  =  var.gcp_org_id
  gcp_project = var.gcp_project

  initial_group_config = var.initial_group_config

  odbg_db_family_administrators	 = "${var.group_prefix}odbg-db-family-administrators"
  odbg_db_family_readers    	 = "${var.group_prefix}odbg-db-family-readers"
  odbg_vm_cluster_administrators = "${var.group_prefix}odbg-vm-cluster-administrators"
  odbg_exa_infra_administrators	 = "${var.group_prefix}odbg-exa-infra-administrators"
  odbg_exa_cdb_administrators    = "${var.group_prefix}odbg-exa-cdb-administrators"
  odbg_exa_pdb_administrators    = "${var.group_prefix}odbg-exa-pdb-administrators"
  odbg_adbs_db_administrators    = "${var.group_prefix}odbg-adbs-db-administrators"
  odbag_built_in_roles = tomap({
    "${local.odbg_db_family_administrators}"  = "Oracle.Database Owner"
    "${local.odbg_db_family_readers}"         = "Oracle.Database Reader"
    "${local.odbg_vm_cluster_administrators}" = "Oracle.Database VmCluster Administrator"
    "${local.odbg_exa_infra_administrators}"  = "Oracle.Database Exadata Infrastructure Administrator"
    "${local.odbg_exa_cdb_administrators}"    = "Oracle.Database CDB Administrator"
    "${local.odbg_exa_pdb_administrators}"    = "Oracle.Database PDB Administrator"
    "${local.odbg_adbs_db_administrators}"    = "Oracle.Database Autonomous Administrator"
  })
}

module "gcp-rbac-setup" {
  source = "./gcp-rbac"
  gcp_org_id = local.gcp_org_id
  gcp_project = local.gcp_project
  initial_group_config = local.initial_group_config
  odbag_built_in_roles = local.odbag_built_in_roles
}