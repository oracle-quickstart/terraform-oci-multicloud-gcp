# config_file_*  are for tfm setup , refer https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm
variable "config_file_profile" {
  description = ""
  type        = string
  default     = "DEFAULT"
}

variable "region" {
  description = "OCI region "
  type        = string
}

variable "compartment_ocid" {
  description = "for root compartment pass tenancy_ocid , else pass compartment_ocid"
  type        = string
}

variable "gcp_federation_xml_url" {
  description = "url used to retrieve GCP identity metadata file"
  type        = string
}

variable "gcp_federation_xml_file" {
  description = "Local file used to retrieve GCP identity metadata file"
  type = string
}

variable "idp_name" {
  description = " name of identity provider, if not provided Default name will be used"
  type        = string
  default     = "Google"
}


variable "idp_description" {
  description = "(optional) description of identity provider"
  type        = string
  default     = "" # empty
}


variable "default_rule_id" {
  description = "name id of Default domain default IDP rule"
  type        = string
  default     = "DefaultIDPRule"
}

variable "domain_display_name" {
  description = "Use default value unless using non default domain"
  type        = string
  default     = "Default"
}

variable "jit_groups" {
  description = "List of groups to be assigned by default to new JIT users"
  type        = set(string)
  default     = []
}

variable "group_prefix" {
  type        = string
  default     = ""
  description = "Group name prefix in GCP"
}

variable "idp_group_mapping" {
  description = "Map between OCI identity groups and IdP groups"
  type        = map(string)
  default     = {}
}