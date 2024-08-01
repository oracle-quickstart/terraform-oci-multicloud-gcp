# Copyright (c) 2024 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

locals {
  oci_console_policy_statements = [
    #"inspect tenancy",
    "inspect tag-namespaces", "use tag-namespaces"
  ]

  gcp_project_where = var.google_project_number != null ? "target.resource.compartment.tag.orcl-OracleDatabase@GCP.ocid1.tagdefinition.oc1..aaaaaaaaobo5z3qm4xu5p5nueol46zwfnz7et2axi3vgp7tzp77ndjrrqepq = '${var.google_project_number}'" : null
  # TODO: The condition for GCP project should be the one below this line, temporarily the previous line works
  # gcp_project_where = var.google_project_number != null ? "ALL {target.resource.compartment.tag.orcl-OracleDatabase@GCP.AuthorizationContextId = '${var.google_project_number}' }" : null

  oci_console_policy = {
    "MulticloudLink_ODBG_Custom_ConsoleAccess" : {
      name : "MulticloudLink_ODBG_Custom_ConsoleAccess"
      description: "MulticloudLink_ODBG_Custom_ConsoleAccess"
      statements : flatten([
        for group in keys(local.groups) : [
          for statement in local.oci_console_policy_statements : {
            group : "%{if var.identity_domain_configuration != null && module.identity_domain.idcs_display_name != "Default"}'${module.identity_domain.idcs_display_name}'/%{endif}${group}"
            permission : statement
            tenancy_statement : true
            where : statement == "use tag-namespaces" ? "ALL{%{if local.gcp_project_where != null}${local.gcp_project_where}, %{endif}target.tag-namespace.name = 'Multicloud'}" : local.gcp_project_where != null ? "ALL {${local.gcp_project_where}}" : null
          }
        ]
      ])
    }
  }

  oci_policies = {
    for group, configuration in local.groups : configuration.policy => [for permission in configuration.permissions : {
      group : group
      permission : permission
    }]...
  }

  oci_group_policies = {
    for policy, statements in local.oci_policies : policy => {
      name : policy,
      description : policy,
      statements : [for statement in flatten(statements) : {
        group : "%{if var.identity_domain_configuration != null && module.identity_domain.idcs_display_name != "Default"}'${module.identity_domain.idcs_display_name}'/%{endif}${statement.group}"
        permission : statement.permission
        where : local.gcp_project_where != null ? "ALL {${local.gcp_project_where}}" : null
      }]
    }
  }

  # TODO: Add policy statement to cover DBAASEXACS-13091 issue.
  #  Allow group odbg-db-family-administrators to manage database-family in compartment id <baseCompartmentId> where any {!request.operation, all { request.operation != 'CreateAutonomousContainerDatabase', request.operation != 'CreateAutonomousDatabase', request.operation != 'CreateAutonomousDatabaseBackup', request.operation != 'CreateAutonomousVmCluster', request.operation != 'CreateBackup', request.operation != 'CreateBackupDestination', request.operation != 'CreateCloudAutonomousVmCluster', request.operation != 'CreateCloudExadataInfrastructure', request.operation != 'CreateCloudVmCluster', request.operation != 'CreateDatabaseSoftwareImage', request.operation != 'CreateExadataInfrastructure', request.operation != 'CreateExternalBackupJob', request.operation != 'CreateExternalContainerDatabase', request.operation != 'CreateExternalDatabaseConnector', request.operation != 'CreateExternalPluggableDatabase', request.operation != 'CreateVmCluster', request.operation != 'CreateVmClusterNetwork' } }
}

module "identity_policies" {
  source = "./oci-identity-policy"

  tenancy_ocid        = var.tenancy_id
  compartment_ocid    = var.compartment_ocid
  config_file_profile = var.config_file_profile
  region              = var.region

  identity_domain_policies = {
    policies : merge(local.oci_console_policy, local.oci_group_policies)
  }
}