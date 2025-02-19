variable "location" {
  type        = string
  description = "GCP region where Autonmous Database is hosted."
}

variable "project" {
  type        = string
  description = "The ID of the project in which the resource belongs. If it is not provided, the provider project is used."
}

variable "cidr" {
  type        = string
  description = "The subnet CIDR range for the client subnet"
}

variable "vm_type" {
  type = string
  description = "Machine type of the client VM"
  default = "e2-medium"
}

variable "vm_image" {
  type = string
  default = "ubuntu-2004-focal-v20250130"
}

variable "network_name" {
  type        = string
  description = "The name of the VPC network used by the Autonomous Database"
}

variable "random_suffix_length" {
  type    = number
  default = 3
}