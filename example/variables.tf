variable "subscription_id" {
  description = "The Azure subscription id."
  default     = "c94297dc-12b3-40c7-a773-64846b40a34c"
  validation {
    condition     = can(regex("^([0-9a-fA-F]{8})-([0-9a-fA-F]{4})-([0-9a-fA-F]{4})-([0-9a-fA-F]{4})-([0-9a-fA-F]{12})$", var.subscription_id))
    error_message = "The subscription id must be a valid GUID."
  }
}