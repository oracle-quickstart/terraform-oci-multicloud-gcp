variable "location" {
  type = string
}

variable "autonomous_database_id" {
  type = string
}

variable "project" {
  type = string
}

variable "client_subnet_cidr" {
  type = string
  default = "10.0.2.0/24"
}

variable "vm_sshkey_path" {
  type = string
}

variable "vm_username" {
  type = string
}