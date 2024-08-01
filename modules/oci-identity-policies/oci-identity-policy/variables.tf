# config_file_*  are for tfm setup , refer https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm
variable "config_file_profile" {
  description = "The profile name if you would like to use a custom profile in the OCI config file to provide the authentication credentials. See Using the SDK and CLI Configuration File for more information, Refer: https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm#terraformproviderconfiguration_topic-SDK_and_CLI_Config_File"
  type        = string
}

variable "region" {
  description = "OCI region "
  type        = string
}

variable "tenancy_ocid" {
  description = "The tenancy OCID."
  type        = string
}

variable "compartment_ocid" {
  description = "for root compartment pass tenancy_ocid , else pass compartment_ocid"
  type        = string
}

variable "identity_domain_policies" {
  description = "Identity Policies for the user groups."
  type = object({
    policies = map(object({
      name        = string
      description = optional(string)
      statements = list(object({
        group      = string
        permission = string

        tenancy_statement = optional(bool)
        where             = optional(string)
      }))
    }))
  })
}