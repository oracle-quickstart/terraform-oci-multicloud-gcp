output "client_vm" {
  description = "Info of client VM"
  value = {
    name = google_compute_instance.this.name
    zone = google_compute_instance.this.zone
    project = google_compute_instance.this.project
  }
}