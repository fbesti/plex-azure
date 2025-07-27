variable "location" {
  description = "The Azure region where resources will be created."
  type        = string
  default     = "North Europe"
}

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
  default     = "rg-network"
}