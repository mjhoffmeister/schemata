# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
}

# Create a resource group for the storage account where the Terraform state will
# be stored
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# Create a storage account for storing the Terraform state
resource "azurerm_storage_account" "st" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = var.location
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type
}

# Assign the Storage Blob Data Contributor role to the specified principal
resource "azurerm_role_assignment" "st_blob_data_contributor_role_assignment" {
  principal_id         = var.storage_blob_data_contributor_object_id
  scope                = azurerm_storage_account.st.id
  role_definition_name = "Storage Blob Data Contributor"
}

# Create a container for storing the Terraform state file
resource "azurerm_storage_container" "stcontainer" {
  name                  = "tfstate"
  storage_account_id    = azurerm_storage_account.st.id
  container_access_type = "private"
}