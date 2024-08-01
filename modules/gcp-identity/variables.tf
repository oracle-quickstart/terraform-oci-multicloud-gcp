variable "gcp_org_id" {
  description = "GCP Organization ID"
  type        = string
}

variable "gcp_project" {
  type        = string
  default     = ""
  description = "GCP project"
}

variable "gcp_region" {
  type = string
  description = "GCP region"
}

variable "group_prefix" {
  type        = string
  default     = ""
  description = "Group name prefix in GCP"
}

variable "initial_group_config" {
  description = "Define the group configuration when it is initialized. Valid values are: WITH_INITIAL_OWNER, EMPTY and INITIAL_GROUP_CONFIG_UNSPECIFIED."
  type        = string
  default     = "WITH_INITIAL_OWNER"
}