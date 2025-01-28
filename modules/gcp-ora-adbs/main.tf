data "google_compute_network" "this" {
  name     = var.network_name
  project = var.project
}

resource "google_oracle_database_autonomous_database" "this"{
  autonomous_database_id = var.autonomous_database_id
  location = var.location
  project = var.project
  display_name = var.display_name
  database = var.database
  admin_password = var.admin_password
  network = data.google_compute_network.this.id
  cidr = var.cidr
  labels = var.labels
  properties {
    compute_count         = var.compute_count
    data_storage_size_tb   = var.data_storage_size_tb
    db_version = var.db_version
    db_edition = var.db_edition
    db_workload = var.db_workload
    is_auto_scaling_enabled= var.is_auto_scaling_enabled
    license_type = var.license_type
    backup_retention_period_days    = var.backup_retention_period_days
    character_set                   = var.character_set
    is_storage_auto_scaling_enabled = var.is_storage_auto_scaling_enabled
    maintenance_schedule_type       = var.maintenance_schedule_type
    mtls_connection_required        = var.mtls_connection_required
    n_character_set                 = var.n_character_set
    operations_insights_state       = var.operations_insights_state
    customer_contacts {
      email = var.customer_email
    }
    private_endpoint_ip    = var.private_endpoint_ip
    private_endpoint_label = var.private_endpoint_label
  }
  deletion_protection = var.deletion_protection
}

data "google_oracle_database_autonomous_database" "this" {
  depends_on = [ google_oracle_database_autonomous_database.this ]
    location = var.location
  autonomous_database_id = google_oracle_database_autonomous_database.this.autonomous_database_id
}