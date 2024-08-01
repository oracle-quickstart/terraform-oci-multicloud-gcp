# config_file_*  are for tfm setup , refer https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm
variable "oci_domain_url" {
  description = "this will be output of module oci-identity-domain"
  type        = string
}

variable "group_name" {
  type        = string
  description = "Group name prefix in GCP"
}

variable "fail_on_missing_group" {
  type = bool
  default = true
  description = "Fail the execution if the given group name is not found."
}