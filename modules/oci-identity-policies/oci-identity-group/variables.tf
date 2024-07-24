# config_file_*  are for tfm setup , refer https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm
variable "config_file_profile" {
  description = "The profile name if you would like to use a custom profile in the OCI config file to provide the authentication credentials. See Using the SDK and CLI Configuration File for more information, Refer: https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm#terraformproviderconfiguration_topic-SDK_and_CLI_Config_File"
  type        = string
}

variable "region" {
  description = "OCI region "
  type        = string
}

variable "compartment_ocid" {
  description = "for root compartment pass tenancy_ocid , else pass compartment_ocid"
  type        = string
}

variable "idcs_endpoint" {
  description = "Identity domain group endpoint"
  type        = string
}

variable "identity_domain_groups_configuration" {
  description = "The identity domain groups configuration."
  type = object({
    default_defined_tags  = optional(map(string))
    default_freeform_tags = optional(map(string))
    groups = map(object({
      name               = string,
      description        = optional(string),
      requestable        = optional(bool),
      members            = optional(list(string)),
      defined_tags       = optional(map(string)),
      freeform_tags      = optional(map(string))
    }))
  })
  default = null
}