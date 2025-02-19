locals {
  vm_name      = "vm-oraclient-${random_string.suffix.result}"
  subnet_name =  "sn-client-${random_string.suffix.result}"
  zone = random_shuffle.zone.result[0]
}

data "google_compute_zones" "available" {
  region = var.location
}

resource "random_shuffle" "zone" {
  input        = data.google_compute_zones.available.names
}

resource "random_string" "suffix" {
  length  = var.random_suffix_length
  special = false
  upper   = false
  numeric = true
}