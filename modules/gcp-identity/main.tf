locals {
  gcp_org_id  = var.gcp_org_id
  gcp_project = var.gcp_project
  gcp_region  = var.gcp_region

  initial_group_config = var.initial_group_config

  odbg_db_family_administrators  = "${var.group_prefix}odbg-db-family-administrators"
  odbg_db_family_readers         = "${var.group_prefix}odbg-db-family-readers"
  odbg_vm_cluster_administrators = "${var.group_prefix}odbg-vm-cluster-administrators"
  odbg_exa_infra_administrators  = "${var.group_prefix}odbg-exa-infra-administrators"
  odbg_exa_cdb_administrators    = "${var.group_prefix}odbg-exa-cdb-administrators"
  odbg_exa_pdb_administrators    = "${var.group_prefix}odbg-exa-pdb-administrators"
  odbg_adbs_db_administrators    = "${var.group_prefix}odbg-adbs-db-administrators"
  odbg_network_administrators    = "${var.group_prefix}odbg-network-administrators"
  odbg_costmgmt_administrators   = "${var.group_prefix}odbg-costmgmt-administrators"
  odbag_built_in_roles = tomap({
    (local.odbg_db_family_administrators) = {
      description : "Oracle.Database Owner",
      role : "oracledatabase.googleapis.com/admin"
    }
    (local.odbg_db_family_readers) = {
      description : "Oracle.Database Reader"
      role : "oracledatabase.googleapis.com/viewer"
    }
    (local.odbg_vm_cluster_administrators) = {
      description : "Oracle.Database VmCluster Administrator"
      role : "oracledatabase.googleapis.com/cloudExadataInfrastructureAdmin"
    }
    (local.odbg_exa_infra_administrators) = {
      description : "Oracle.Database Exadata Infrastructure Administrator"
      role : "oracledatabase.googleapis.com/cloudVmClusterAdmin "
    }
    (local.odbg_exa_cdb_administrators) = {
      description : "Oracle.Database CDB Administrator"
    }
    (local.odbg_exa_pdb_administrators) = {
      description : "Oracle.Database PDB Administrator"
    }
    (local.odbg_adbs_db_administrators) = {
      description : "Oracle.Database Autonomous Administrator"
    }
    (local.odbg_network_administrators) = {
      description : "Oracle.Database Network Administrator"
    }
    (local.odbg_costmgmt_administrators) = {
      description : "Oracle.Database Cost Management"
    }
  })
}

module "gcp-rbac-setup" {
  source               = "./gcp-rbac"
  gcp_org_id           = local.gcp_org_id
  gcp_project          = local.gcp_project
  gcp_region           = local.gcp_region
  initial_group_config = local.initial_group_config
  odbag_built_in_roles = local.odbag_built_in_roles
}
