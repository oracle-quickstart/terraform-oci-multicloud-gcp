terraform {
  required_providers {
    # https://registry.terraform.io/providers/Azure/azapi/latest/docs
    azapi = {
      source = "azure/azapi"
    }
    # https://registry.terraform.io/providers/hashicorp/random/latest/docs
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }
}
