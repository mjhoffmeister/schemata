variable "location" {
  type        = string
  description = "The Azure region where the resources will be deployed."
  nullable    = false
}

variable "resource_group_name" {
  type        = string
  default     = "rg-tfstate"
  description = "The name of the resource group."
  nullable    = false
}

variable "storage_account_name" {
  type        = string
  default     = "sttfstateschemata"
  description = "The name of the storage account."
  nullable    = false
}

variable "storage_account_replication_type" {
  type        = string
  default     = "LRS"
  description = "(Optional) The replication type of the storage account. Defaults to LRS."
  nullable    = false
  validation {
    condition     = contains(["LRS", "GRS", "RAGRS", "ZRS", "GZRS", "RAGZRS"], var.storage_account_replication_type)
    error_message = "The storage account replication type must be one `LRS`, `GRS`, `RAGRS`, `ZRS`, `GZRS` or `RAGZRS`."
  }
}

variable "storage_account_tier" {
  type        = string
  default     = "Standard"
  description = "(Optional) The tier of the storage account. Defaults to Standard."
  nullable    = false
  validation {
    condition     = contains(["Standard", "Premium"], var.storage_account_tier)
    error_message = "The storage account tier must be either 'Standard' or 'Premium'."
  }
}

variable "storage_blob_data_contributor_object_id" {
  type        = string
  description = "The object id of the principal for which to assign the Storage Blob Data Contributor role."
  nullable    = false
}

variable "subscription_id" {
  type        = string
  description = "The Azure subscription id."
  nullable    = false
  validation {
    condition     = can(regex("^([0-9a-fA-F]{8})-([0-9a-fA-F]{4})-([0-9a-fA-F]{4})-([0-9a-fA-F]{4})-([0-9a-fA-F]{12})$", var.subscription_id))
    error_message = "The subscription id must be a valid GUID."
  }
}