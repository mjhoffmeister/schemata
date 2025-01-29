variable "azure_devops_project_names" {
  description = "The names of the Azure DevOps projects."
  type        = list(string)
  nullable    = true
  default     = null
  validation {
    condition     = var.azure_devops_project_names == null || try(alltrue([for project_name in var.azure_devops_project_names : length(project_name) >= 1 && length(project_name) <= 64 && can(regex("^[^_.][^\\/:*?\"<>;#$*{},+=\\[\\]]*[^.]$", project_name))]), true)
    error_message = "The Azure DevOps project names must be between 1 and 64 characters, must not contain the special characters \\/:*?\"<>;#$*{},+=[], must not begin with '_', and must not begin or end with '.'."
  }
}

variable "azure_devops_organization_name" {
  description = "The name of the Azure DevOps organization."
  type        = string
  nullable    = true
  default     = null
  validation {
    condition     = var.azure_devops_organization_name == null || try((length(var.azure_devops_organization_name) >= 1 && length(var.azure_devops_organization_name) <= 50 && can(regex("^[a-zA-Z0-9][a-zA-Z0-9-]*[a-zA-Z0-9]$", var.azure_devops_organization_name))), true)
    error_message = "The Azure DevOps organization name must be between 1 and 50 characters, only contain alphanumerics and hyphens, start with an alphanumeric, and end with an alphanumeric."
  }
}

variable "dev_center_name" {
  description = "The name of the dev center."
  type        = string
  nullable    = true
  default     = null
  validation {
    condition     = var.dev_center_name == null || try((length(var.dev_center_name) >= 3 && length(var.dev_center_name) <= 26 && can(regex("^[^-_][a-zA-Z0-9]+[^.]$", var.dev_center_name))), true)
    error_message = "Dev center names must be between 3 and 26 characters long and cannot contain special characters \\/\"[]:|<>+=;,?*@&, whitespace, or begin with '_' or '-' or end with '.'."
  }
}

variable "devopsinfrastructure_principal_id" {
  description = "The DevOpsInfrastructure principal id."
  type        = string
  validation {
    condition     = can(regex("^([0-9a-fA-F]{8})-([0-9a-fA-F]{4})-([0-9a-fA-F]{4})-([0-9a-fA-F]{4})-([0-9a-fA-F]{12})$", var.devopsinfrastructure_principal_id))
    error_message = "The DevOpsInfrastructure principal id must be a valid GUID."
  }
}

variable "dev_center_project_name" {
  description = "The name of the dev center project."
  type        = string
  nullable    = true
  default     = null
  validation {
    condition     = var.dev_center_project_name == null || try((length(var.dev_center_project_name) >= 1 && length(var.dev_center_project_name) <= 64), true)
    error_message = "The Azure DevOps project name must be between 1 and 64 characters."
  }
}

variable "enable_network_creation" {
  description = "Enable/disable the creation of networking resources. This should only be used for demo purposes."
  type        = bool
  default     = false
}

variable "location" {
  description = "The location for the Managed DevOps Pool resources."
  type        = string
  default     = "eastus"
  validation {
    condition     = contains(["eastus", "westus", "centralus", "eastus2", "westus2", "northcentralus", "southcentralus", "northeurope", "westeurope", "southeastasia", "eastasia", "japaneast", "japanwest", "australiaeast", "australiasoutheast", "brazilsouth", "southindia", "centralindia", "canadacentral", "canadaeast", "uksouth", "ukwest", "koreacentral", "koreasouth"], var.location)
    error_message = "The location must be one of the following: eastus, westus, centralus, eastus2, westus2, northcentralus, southcentralus, northeurope, westeurope, southeastasia, eastasia, japaneast, japanwest, australiaeast, australiasoutheast, brazilsouth, southindia, centralindia, canadacentral, canadaeast, uksouth, ukwest, koreacentral, koreasouth."
  }
}

variable "managed_devops_pool_name" {
  description = "The name of the Managed DevOps pool."
  type        = string
  default     = null
  validation {
    condition     = var.managed_devops_pool_name == null || try(length(var.managed_devops_pool_name) >= 3 && length(var.managed_devops_pool_name) <= 44 && can(regex("^[a-zA-Z0-9][a-zA-Z0-9.-]*$", var.managed_devops_pool_name)), true)
    error_message = "The name must be between 3 and 44 characters long, start with an alphanumeric character, and can only contain alphanumeric characters, hyphens, and dots."
  }
}

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
  nullable    = true
  default     = null
  validation {
    condition     = var.resource_group_name == null || try((length(var.resource_group_name) >= 1 && length(var.resource_group_name) <= 90), true)
    error_message = "The resource group name must be between 1 and 90 characters."
  }
}

variable "subnet_id" {
  description = "If networking creation is disabled, the id of the subnet to be used."
  type        = string
  nullable    = true
  default     = null
}

variable "subnet_name" {
  description = "If networking creation is enabled, the name of the subnet to be created."
  type        = string
  nullable    = true
  default     = null
  validation {
    condition     = var.subnet_name == null || try((length(var.subnet_name) >= 1 && length(var.subnet_name) <= 80 && can(regex("^[a-zA-Z0-9][a-zA-Z0-9._-]*[a-zA-Z0-9_]$", var.subnet_name))), true)
    error_message = "The subnet name must be between 1 and 80 characters, only contain alphanumerics, underscores, periods, and hyphens, start with an alphanumeric, and end with an alphanumeric or underscore."
  }
}

variable "subscription_id" {
  description = "The Azure subscription id."
  type        = string
  validation {
    condition     = can(regex("^([0-9a-fA-F]{8})-([0-9a-fA-F]{4})-([0-9a-fA-F]{4})-([0-9a-fA-F]{4})-([0-9a-fA-F]{12})$", var.subscription_id))
    error_message = "The subscription id must be a valid GUID."
  }
}

variable "virtual_network_name" {
  description = "If networking creation is enabled, the name of the virtual network to be created."
  type        = string
  nullable    = true
  default     = null
  validation {
    condition     = var.virtual_network_name == null || try((length(var.virtual_network_name) >= 1 && length(var.virtual_network_name) <= 80 && can(regex("^[a-zA-Z0-9][a-zA-Z0-9._-]*[a-zA-Z0-9_]$", var.virtual_network_name))), true)
    error_message = "The virtual network name must be between 1 and 80 characters, only contain alphanumerics, underscores, periods, and hyphens, start with an alphanumeric, and end with an alphanumeric or underscore."
  }
}