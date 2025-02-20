
terraform {
  required_version = ">= 1.5.0"
  required_providers {
    # https://registry.terraform.io/providers/hashicorp/local/latest/docs
    local = {
      source  = "hashicorp/local"
      version = ">= 2.5.1"
    }
    # https://registry.terraform.io/providers/hashicorp/random/latest/docs
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5"
    }
    # https://registry.terraform.io/providers/hashicorp/google/latest/docs
    google = {
      source  = "hashicorp/google"
      version = ">= 6.8.0"
    }
 
    # https://registry.terraform.io/providers/oracle/oci/latest/docs
    # oci = {
    #   source  = "oracle/oci"
    #   version = ">= 6.15.0"
    # }
  }
}
