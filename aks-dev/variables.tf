variable "azurerm_backend" {
  description = "Configuration for the azurerm backend."
  type = object({
    resource_group_name  = string
    storage_account_name = string
    container_name       = string
    key                  = string
    use_azuread_auth     = bool
  })
}

variable "location" {
    description = "The Azure region where the resources should be created."
    type        = string
    default     = "eastus2"
}

variable "resource_group_name_prefix" {
    description = "The prefix resource group in which the resources should be created."
    type        = string
    default    = "rg-aks-schemata"
}