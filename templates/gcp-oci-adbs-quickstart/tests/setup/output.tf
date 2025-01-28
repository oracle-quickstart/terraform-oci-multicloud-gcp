output "external_ip" {
  value = google_compute_instance.this.network_interface.0.access_config.0.nat_ip
}

output "network_name" {
    value = local.network_name
}

output "connection_strings" {
    value = data.google_oracle_database_autonomous_database.this.properties[0].connection_strings[0]
}
