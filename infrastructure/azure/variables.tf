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
