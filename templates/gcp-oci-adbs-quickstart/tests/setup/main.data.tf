provider "google" {
  project = var.project
  region  = var.location
}

locals {
  network_name = regex("^.*/networks/(.*)$", data.google_oracle_database_autonomous_database.this.network)[0]
  vm_name = "${var.autonomous_database_id}-client"
}

data "google_oracle_database_autonomous_database" "this"{
  location = var.location
  autonomous_database_id = var.autonomous_database_id
}

data "google_compute_zones" "available" {
}
