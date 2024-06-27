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
  odbag_built_in_roles  = var.odbag_built_in_roles
}

provider "google" {
  project = local.gcp_project
}

data "google_organization" "org" {
  organization = var.gcp_org_id
}

module "groups" {
  source   = "terraform-google-modules/group/google"
  version  = "~> 0.6"
  for_each = local.odbag_built_in_roles

  id                   = each.key
  display_name         = each.value
  description          = each.value
  initial_group_config = var.initial_group_config
  customer_id          = data.google_organization.org.directory_customer_id
  types                = ["default", "security"]
}

resource "google_project_iam_member" "project" {
  project = local.gcp_project
  role    = "roles/${each.key}"
  member  = "group:${each.key}"

  for_each = local.odbag_built_in_roles
}