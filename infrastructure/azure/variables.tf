variable "location" {
  description = "The Azure region where resources will be created."
  type        = string
  default     = "North Europe"
}

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
  default     = "rg-plex-cert"
}

variable "resource_group_name_test" {
  description = "The name of the resource group."
  type        = string
  default     = "rg-test-cert"
}

variable "remote_state_subscription_id" {
  description = "The subscription ID of the remote state storage account. Extreme secret shit"
  type        = string
  sensitive   = true
}

variable "remote_state_tenant_id" {
  description = "The tenant ID of the remote state storage account."
  type        = string
  sensitive   = true
}
