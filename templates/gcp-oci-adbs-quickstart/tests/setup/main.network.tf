resource "google_compute_subnetwork" "this" {
  name          = "oraadbs-client-subnet"
  ip_cidr_range = var.client_subnet_cidr
  region        = var.location
  network       = local.network_name
}

resource "google_compute_firewall" "rules" {
  project     = var.project
  name        = "allow-ssh"
  network     = local.network_name
  description = "Allow ssh"

  allow {
    protocol  = "tcp"
    ports     = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["allow-ssh"]
}