# VM
resource "google_compute_instance" "this" {
  name         = local.vm_name
  machine_type = var.vm_type
  zone         = local.zone

  boot_disk {
    initialize_params {
      image = var.vm_image
      size = 10
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.this.name
    access_config {
    }
  }

  metadata = {
    # user-data = file("${path.module}/cloud-init.yaml")
    user-data = templatefile("${path.module}/cloud-init.yaml.tftpl", {install_oraclient_sh = filebase64("${path.module}/install_oraclient.sh")})
  }
  tags = ["oraclient"]

}
