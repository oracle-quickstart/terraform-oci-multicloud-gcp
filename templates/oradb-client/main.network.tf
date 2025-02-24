# Subnet for VM
resource "google_compute_subnetwork" "this" {
  name          = local.subnet_name
  ip_cidr_range = var.cidr
  region        = var.location
  network       = var.network_name
}


# Firewall Rules
resource "google_compute_firewall" "ingress" {
  name          = "${var.network_name}-${local.subnet_name}-ingress"
  network       = var.network_name
  description   = "Allow SSH, HTTP, HTTPS, Autonomous DB, and RDP access"
  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["oraclient"]
  allow {
    protocol = "tcp"
    ports    = ["22", "443", "1522", "3389"]
  }
}

resource "google_compute_firewall" "egress" {
  name               = "${var.network_name}-${local.subnet_name}-egress"
  network            = var.network_name
  description        = "Allow SSH, HTTP, HTTPS, Autonomous DB, and RDP access"
  direction          = "EGRESS"
  destination_ranges = ["0.0.0.0/0"]
  target_tags        = ["oraclient"]

  allow {
    protocol = "tcp"
    ports    = ["22", "443", "1522", "3389"]
  }
}
