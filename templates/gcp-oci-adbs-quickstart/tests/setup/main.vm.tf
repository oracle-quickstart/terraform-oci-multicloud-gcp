resource "google_compute_instance" "this" {
  provider = google
  name = local.vm_name
  machine_type = "e2-micro"
  zone = data.google_compute_zones.available.names[0]

  metadata = {
    ssh-keys = "${var.vm_username}:${file(var.vm_sshkey_path)}"
    user-data = file("${path.module}/cloud-config.yaml")
  }

  tags = ["allow-ssh"]

  network_interface {
    # network = local.network_name
    subnetwork = google_compute_subnetwork.this.id
    access_config {}
  }

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }
}


