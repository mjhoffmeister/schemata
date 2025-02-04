# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "sttfstateschemata"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
    use_azuread_auth     = true
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
}

# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = coalesce(var.resource_group_name, local.resource_group_name)
  location = var.location
}

# Create a dev center
resource "azurerm_dev_center" "dev_center" {
  name                = coalesce(var.dev_center_name, local.dev_center_name)
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}

# Create a dev center project
resource "azurerm_dev_center_project" "dev_center_project" {
  name                = coalesce(var.dev_center_project_name, local.dev_center_project_name)
  dev_center_id       = azurerm_dev_center.dev_center.id
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}

# Create a virtual network and subnet if network creation is enabled
resource "azurerm_virtual_network" "vnet" {
  count               = var.enable_network_creation ? 1 : 0
  name                = coalesce(var.virtual_network_name, local.virtual_network_name)
  address_space       = ["10.0.0.0/24"]
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Assign the DevOpsInfrastructure service principal the Reader role on the virtual network
resource "azurerm_role_assignment" "vnet_reader_role_assignment" {
  count                = var.enable_network_creation ? 1 : 0
  principal_id         = var.devopsinfrastructure_principal_id
  role_definition_name = "Reader"
  scope                = azurerm_virtual_network.vnet[0].id
}

# Assign the DevOpsInfrastructure service principal the Network Contributor role on the virtual network
resource "azurerm_role_assignment" "vnet_network_contributor_role_assignment" {
  count                = var.enable_network_creation ? 1 : 0
  principal_id         = var.devopsinfrastructure_principal_id
  role_definition_name = "Network Contributor"
  scope                = azurerm_virtual_network.vnet[0].id
}

# Create a subnet with a service delegation for Managed DevOps Pools
resource "azurerm_subnet" "subnet" {
  count                = var.enable_network_creation ? 1 : 0
  name                 = coalesce(var.subnet_name, local.subnet_name)
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet[0].name
  address_prefixes     = ["10.0.0.0/26"]

  delegation {
    name = "delegation"

    service_delegation {
      name    = "Microsoft.DevOpsInfrastructure/pools"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
    }
  }
}

# Use the Azure Verified Module (AVM) for Managed DevOps Pools
module "managed_devops_pool" {
  source                                   = "Azure/avm-res-devopsinfrastructure-pool/azurerm"
  resource_group_name                      = azurerm_resource_group.rg.name
  location                                 = var.location
  name                                     = coalesce(var.managed_devops_pool_name, local.managed_devops_pool_name)
  dev_center_project_resource_id           = azurerm_dev_center_project.dev_center_project.id
  version_control_system_organization_name = coalesce(var.azure_devops_organization_name, local.azure_devops_organization_name)
  version_control_system_project_names     = var.azure_devops_project_names
  subnet_id                                = var.enable_network_creation ? azurerm_subnet.subnet[0].id : var.subnet_id
}