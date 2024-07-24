locals {
  groups = {
    "odbg-db-family-administrators" : {
      name : "odbg-db-family-administrators"
      description : "Oracle.Database owner"
      policy : "MulticloudLink_ODBG_Custom_DbFamilyPolicy"
      permissions : ["manage database-family"]
    }
    "odbg-db-family-readers" : {
      name : "odbg-db-family-readers"
      description : "Oracle.Database reader"
      policy : "MulticloudLink_ODBG_Custom_DbFamilyPolicy"
      permissions : ["read database-family", "read autonomous-database-family"]
    }
    "odbg-exa-infra-administrators" : {
      name : "odbg-exa-infra-administrators"
      description : "Oracle.Database Exadata Infrastructure Administrator"
      policy : "MulticloudLink_ODBG_Custom_DbFamilyPolicy"
      permissions : ["manage cloud-exadata-infrastructures", "use cloud-vmclusters"]
    }
    "odbg-vm-cluster-administrators" : {
      name : "odbg-vm-cluster-administrators"
      description : "Oracle.Database VmCluster Administrator"
      policy : "MulticloudLink_ODBG_Custom_DbFamilyPolicy"
      permissions : [
        "use cloud-exadata-infrastructures", "manage cloud-vmclusters", "manage db-homes", "manage databases",
        "manage db-backups"
      ]
    }
    "odbg-exa-cdb-administrators" : {
      name : "odbg-exa-cdb-administrators"
      description : "Oracle.Database CDB Administrator"
      policy : "MulticloudLink_ODBG_Custom_DbFamilyPolicy"
      permissions : ["manage db-homes", "manage databases", "manage db-backups"]
    }
    "odbg-exa-pdb-administrators" : {
      name : "odbg-exa-pdb-administrators"
      description : "Oracle.Database PDB Administrator"
      policy : "MulticloudLink_ODBG_Custom_DbFamilyPolicy"
      permissions : ["manage pluggable-databases"]
    }
    "odbg-adbs-db-administrators" : {
      name : "odbg-adbs-db-administrators"
      description : "Oracle.Database Autonomous Administrator"
      policy : "MulticloudLink_ODBG_Custom_DbFamilyPolicy"
      permissions : ["manage autonomous-databases", "manage autonomous-backups"]
    }
    "odbg-network-administrators" : {
      name : "odbg-network-administrators"
      description : "Oracle.Database Network Administrator"
      policy : "MulticloudLink_ODBG_Custom_NetworkAdminPolicy"
      permissions : ["manage virtual-network-family"]
    }
    "odbg-costmgmt-administrators" : {
      name : "odbg-costmgmt-administrators"
      description : "Oracle.Database Cost Management"
      policy : "MulticloudLink_ODBG_Custom_CostMgmtPolicy"
      permissions : ["manage usage-report"]
    }
  }
  domain_groups = var.identity_domain_configuration == null ? {} : { for key, group in local.groups : key => {
    name : group.name
    description : group.description
  }}
}