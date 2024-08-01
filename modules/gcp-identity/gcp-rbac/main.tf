terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

locals {
  gcp_org_id            = var.gcp_org_id
  gcp_project           = var.gcp_project
  gcp_region            = var.gcp_region
  odbag_built_in_roles  = var.odbag_built_in_roles
}

/**
# Uncomment this section and the access token line on the google provider to run the terraform script by impersonating
# a service account. This would use the default login account to get a service account token usable by the terraform script.
provider "google" {
  alias = "impersonate"
  scopes = [
    "https://www.googleapis.com/auth/cloud-platform",
    "https://www.googleapis.com/auth/userinfo.email"
  ]
}

data "google_service_account_access_token" "default" {
  provider = google.impersonate
  target_service_account = "service-account@domain.com"
  scopes = ["cloud-platform", "userinfo-email"]
  lifetime = "3600s"
}
*/

provider "google" {
  project = local.gcp_project
  region = local.gcp_region
#  access_token = data.google_service_account_access_token.default.access_token
#  request_timeout = "60s"
}

data "google_organization" "org" {
  organization = var.gcp_org_id
}

output "google_org" {
  value = data.google_organization.org
}

resource "google_cloud_identity_group" "groups" {
  for_each = local.odbag_built_in_roles

  display_name = each.value.description
  description = each.value.description
  parent = "customers/${data.google_organization.org.directory_customer_id}"

  initial_group_config = var.initial_group_config

  group_key {
    id = "${each.key}@${data.google_organization.org.domain}"
  }

  labels = {
    "cloudidentity.googleapis.com/groups.discussion_forum":""
    "cloudidentity.googleapis.com/groups.security":""
  }
}

resource "google_project_iam_member" "project" {
  depends_on = [google_cloud_identity_group.groups]

  role    = "roles/${each.value}"
  project = local.gcp_project
  member  = "group:${each.key}@${data.google_organization.org.domain}"

  for_each = {for group_role, group_config in local.odbag_built_in_roles : group_role => group_config.role if group_config.role != null }
}