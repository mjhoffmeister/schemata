# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.15.0"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
}

# Create a resource group
resource "azurerm_resource_group" "rg_terraform_test" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    Environment = "Terraform Getting Started"
    Team        = "DevOps"
  }
}