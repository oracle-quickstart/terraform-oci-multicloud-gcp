output "client_vm_name" {
  description = "Name of client VM"
  value = google_compute_instance.this.name
}