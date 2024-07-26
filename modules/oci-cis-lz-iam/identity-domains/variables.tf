# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

variable "tenancy_ocid" {
  type = string
  description = "The OCID of the tenancy."
}

variable "identity_domains_configuration" {
  description = "The identity domains configuration."
  type = object({
    default_compartment_id = optional(string)
    default_defined_tags   = optional(map(string))
    default_freeform_tags  = optional(map(string))
    identity_domains = map(object({
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
    }))
  })
  default = null
}

variable "identity_domain_groups_configuration" {
  description = "The identity domain groups configuration."
  type = object({
    default_identity_domain_id  = optional(string)
    default_defined_tags        = optional(map(string))
    default_freeform_tags       = optional(map(string))
    groups = map(object({
      identity_domain_id        = optional(string),
      name                      = string,
      description               = optional(string),
      requestable               = optional(bool),
      members                   = optional(list(string)),
      defined_tags              = optional(map(string)),
      freeform_tags             = optional(map(string))
    }))
  })
  default = null
}

variable "identity_domain_dynamic_groups_configuration" {
  description = "The identity domain dynamic groups configuration."
  type = object({
    default_identity_domain_id  = optional(string)
    default_defined_tags        = optional(map(string))
    default_freeform_tags       = optional(map(string))
    dynamic_groups = map(object({
      identity_domain_id        = optional(string),
      name                      = string,
      description               = optional(string),
      matching_rule             = string,
      defined_tags              = optional(map(string)),
      freeform_tags             = optional(map(string))
    }))
  })
  default = null
}

variable "identity_domain_identity_providers_configuration" {
  description = "The identity domain identity providers configuration."
  type = object({
    default_identity_domain_id  = optional(string)
    #default_defined_tags        = optional(map(string))
    #default_freeform_tags       = optional(map(string))
    identity_providers = map(object({
      identity_domain_id        = optional(string),
      name                      = string,
      description               = optional(string),
      icon_file                 = optional(string),
      enabled                   = bool,
      name_id_format            = optional(string),
      user_mapping_method       = optional(string),
      user_mapping_store_attribute = optional(string),
      assertion_attribute          = optional(string),

      idp_metadata_file         = optional(string),

      idp_issuer_uri            = optional(string),
      sso_service_url           = optional(string),
      sso_service_binding       = optional(string),
      idp_signing_certificate   = optional(string),
      idp_encryption_certificate = optional(string),
      enable_global_logout      = optional(bool),
      idp_logout_request_url    = optional(string),
      idp_logout_response_url   = optional(string),
      idp_logout_binding        = optional(string),

      signature_hash_algorithm  = optional(string),
      send_signing_certificate  = optional(bool),

      jit_user_prov_attribute_update_enabled          = optional(bool),
      jit_user_prov_create_user_enabled               = optional(bool),
      jit_user_prov_enabled                           = optional(bool),
      jit_user_prov_group_assertion_attribute_enabled = optional(bool),
      jit_user_prov_group_assignment_method           = optional(string),
      jit_user_prov_group_mapping_mode                = optional(string),
      jit_user_prov_group_saml_attribute_name         = optional(string),
      jit_user_prov_group_static_list_enabled         = optional(bool),
      jit_user_prov_ignore_error_on_absent_groups     = optional(string),
      jit_user_prov_attributes                        = optional(string),

      #defined_tags              = optional(map(string)),
      #freeform_tags             = optional(map(string))
    }))
  })
  default = null
}

variable module_name {
  description = "The module name."
  type = string
  default = "iam-identity-domains"
}

variable compartments_dependency {
  description = "A map of objects containing the externally managed compartments this module may depend on. All map objects must have the same type and must contain at least an 'id' attribute (representing the compartment OCID) of string type." 
  type = map(object({
    id = string
  }))
  default = null
}
