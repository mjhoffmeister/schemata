terraform {
  required_version = ">= 1.3.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0, < 5.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = var.azurerm_backend.resource_group_name
    storage_account_name = var.azurerm_backend.storage_account_name
    container_name       = var.azurerm_backend.container_name
    key                  = var.azurerm_backend.key
    use_azuread_auth     = var.azurerm_backend.use_azuread_auth
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

# This ensures we have unique Cloud Adoption Framework (CAF) compliant names for our resources
module "naming" {
  source  = "Azure/naming/azurerm"
  version = "~> 0.4"
  suffix = [var.location, "dev"]
}

# This is required for resource modules
resource "azurerm_resource_group" "this" {
  location = var.location
  name     = naming.resource_group.name
}

# This is the module call for the AKS cluster
module "aks-dev" {
  source  = "Azure/avm-ptn-aks-dev/azurerm"
  version = "0.2.0"
  kubernetes_version  = "1.31"
  name                = module.naming.kubernetes_cluster.name
  resource_group_name = azurerm_resource_group.this.name
  location            = var.location
  container_registry_name            = module.naming.container_registry.name
}