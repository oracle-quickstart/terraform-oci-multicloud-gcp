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

variable "tenancy_id" {
  description = "Tenancy ocid"
  type        = string
}

variable "domain_name" {
  description = "Name of existing domain where groups would be created. It would be used if identity_domain_configuration is not present"
  type        = string
  default     = "Default"
}

variable "google_project_number" {
  description = "The linked GCP project used to limit access to existing groups and policies"
  type        = string
  default     = null
}

variable "identity_domain_name" {
  description = "Name of existing domain where groups would be created. It would be used if identity_domain_configuration is not present"
  type        = string
  default     = "Default"
}

variable "identity_domain_configuration" {
  description = "The identity domain configuration."
  type = object({
    compartment_id            = optional(string),
    display_name              = string,
    description               = string,
    home_region               = optional(string),
    license_type              = string,
    admin_email               = optional(string),
    admin_first_name          = optional(string),
    admin_last_name           = optional(string),
    admin_user_name           = optional(string),
    is_hidden_on_login        = optional(bool),
    is_notification_bypassed  = optional(bool),
    is_primary_email_required = optional(bool),
    defined_tags              = optional(map(string)),
    freeform_tags             = optional(map(string))
  })
  default = null
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