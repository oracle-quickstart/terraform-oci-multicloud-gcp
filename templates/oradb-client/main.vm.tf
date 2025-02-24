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
    enable-oslogin : "TRUE"
    user-data = templatefile("${path.module}/cloud-init.yaml.tftpl", {install_oraclient_sh = filebase64("${path.module}/install_oraclient.sh")})
  }
  tags = ["oraclient"]

}

locals {
  
}

resource "null_resource" "wait_for_sqlplus" {
  depends_on = [ google_compute_instance.this , google_compute_firewall.egress, google_compute_firewall.ingress]

  provisioner "local-exec" {
    quiet = true
    command = <<EOT
      GCLOUD_SSH="gcloud compute ssh --quiet --project ${google_compute_instance.this.project} --zone ${google_compute_instance.this.zone} ${google_compute_instance.this.name}" 
      echo "Waiting for Oracle Instant Client installation ..."

      for i in {1..60}; do
        sleep 10        
        if $GCLOUD_SSH --command="sqlplus -v" &>/dev/null 2>/dev/null; then
          $GCLOUD_SSH --command="sqlplus -v"
          break
        fi
      done
    EOT
  }
}