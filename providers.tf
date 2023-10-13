 
# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.54.0"
    }
    # curl = {
    #   source  = "anschoewe/curl"
    #   version = "1.0.2"
    # }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  #skip_provider_registration = true # This is only required when the User, Service Principal, or Identity running Terraform lacks the permissions to register Azure Resource Providers.
  features {
    # resource_group {
    #   private_endpoint_network_policies_enabled = false
    # }
  }
  subscription_id   = var.subscription_id
  tenant_id         = var.tenant_id
  client_id         = var.client_id
  client_secret     = var.client_secret
}

provider "kubernetes" {
  host                   = module.aks.host
  client_certificate     = base64decode(module.aks.client_certificate)
  client_key             = base64decode(module.aks.client_key)
  cluster_ca_certificate = base64decode(module.aks.cluster_ca_certificate)
}
#provider "curl" {}
