# Required
variable "project" {
  type        = string
  description = "The ID of the project in which the resource belongs. If it is not provided, the provider project is used."
}

variable "adb_name" {
  description = "The name (prefix) which should be used for this Autonomous Database."
  type        = string
  default     = "oraadbs"
}

variable "network_name" {
  type        = string
  description = "The name of the VPC network used by the Autonomous Database"
}

variable "cidr" {
  type        = string
  description = "The subnet CIDR range for the Autonmous Database"
}

variable "location" {
  type        = string
  description = "GCP region where Autonmous Database is hosted."
}

# variable "autonomous_database_id" {
#   type        = string
#   description = "The ID of the Autonomous Database to create. This value is restricted to (^a-z?$) and must be a maximum of 63 characters in length. The value must start with a letter and end with a letter or a number"
# }

variable "db_workload" {
  type        = string
  default     = "OLTP"
  description = "Possible values: DB_WORKLOAD_UNSPECIFIED OLTP DW AJD APEX"
}

variable "license_type" {
  type        = string
  default     = "LICENSE_INCLUDED"
  description = "The license type used for the Autonomous Database. Possible values: LICENSE_TYPE_UNSPECIFIED LICENSE_INCLUDED BRING_YOUR_OWN_LICENSE"
}

variable "customer_email" {
  type        = string
  description = "The email address used by Oracle to send notifications regarding databases and infrastructure."
}

variable "admin_password" {
  type        = string
  description = "The password for the default ADMIN user"
  sensitive   = true
}

# Optional
variable "display_name" {
  type        = string
  description = "The display name for the Autonomous Database. The name does not have to be unique within your project."
  default     = ""
}


variable "labels" {
  type        = map(string)
  description = "The labels or tags associated with the Autonomous Database."
  default = {
    "createdby" = "gcp-ora-adbs"
  }
}

variable "compute_count" {
  type        = number
  description = "The number of compute servers for the Autonomous Database."
  default     = 2
}

variable "data_storage_size_tb" {
  type        = number
  description = "The size of the data stored in the database, in terabytes."
  default     = 1
}

variable "db_version" {
  type        = string
  description = "The Oracle Database version for the Autonomous Database."
  default     = "23ai"
}

variable "db_edition" {
  type        = string
  description = "The edition of the Autonomous Databases. Possible values: DATABASE_EDITION_UNSPECIFIED STANDARD_EDITION ENTERPRISE_EDITION"
  default     = ""
}


variable "is_auto_scaling_enabled" {
  type        = bool
  description = "This field indicates if auto scaling is enabled for the Autonomous Database CPU core count."
  default     = false
}


variable "backup_retention_period_days" {
  type        = number
  description = "The retention period for the Autonomous Database. This field is specified in days, can range from 1 day to 60 days, and has a default value of 60 days."
  default     = 60
}

variable "character_set" {
  type        = string
  description = "The character set for the Autonomous Database. The default is AL32UTF8."
  default     = "AL32UTF8"
}

variable "is_storage_auto_scaling_enabled" {
  type        = bool
  description = "This field indicates if auto scaling is enabled for the Autonomous Database storage."
  default     = false
}

variable "maintenance_schedule_type" {
  type        = string
  description = "The maintenance schedule of the Autonomous Database. Possible values: MAINTENANCE_SCHEDULE_TYPE_UNSPECIFIED EARLY REGULAR"
  default     = "REGULAR"
}

variable "mtls_connection_required" {
  type        = bool
  description = "This field specifies if the Autonomous Database requires mTLS connections."
  default     = false
}

variable "n_character_set" {
  type        = string
  description = "The national character set for the Autonomous Database. The default is AL16UTF16."
  default     = "AL16UTF16"
}

variable "operations_insights_state" {
  type        = string
  description = "Possible values: OPERATIONS_INSIGHTS_STATE_UNSPECIFIED ENABLING ENABLED DISABLING NOT_ENABLED FAILED_ENABLING FAILED_DISABLING"
  default     = "NOT_ENABLED"
}

variable "private_endpoint_ip" {
  type        = string
  description = "The private endpoint IP address for the Autonomous Database."
  default     = ""
}

variable "private_endpoint_label" {
  type        = string
  description = "The private endpoint label for the Autonomous Database."
  default     = ""
}

variable "deletion_protection" {
  type        = bool
  description = "Whether or not to allow Terraform to destroy the instance. Unless this field is set to false in Terraform state, a terraform destroy or terraform apply that would delete the instance will fail."
  default     = true
}

variable "random_suffix_length" {
  type    = number
  default = 3
}
