# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

# OCI Provider
variable "oci_tenancy_ocid" {}
variable "oci_region" {description = "Your tenancy home region"}
variable "oci_user_ocid" {default = ""}
variable "oci_fingerprint" {default = ""}
variable "oci_private_key_path" {default = ""}
variable "oci_private_key_password" {default = ""}

# OCI Modules - "identity_domains"
variable "identity_domain_identity_providers_configuration" {
  description = "The identity domain identity providers configuration."
  type = any
}
