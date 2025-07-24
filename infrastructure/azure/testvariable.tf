
variable "app_gw_name" {
  description = "The name for the Application Gateway and its related resources."
  type        = string
  default     = "app-gw-test"
}

variable "location" {
  description = "The Azure region where the resources will be created."
  type        = string
  default     = "eastus"
}

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
  default     = "plex-test-rg"
}

variable "vnet_address_space" {
  description = "The address space for the virtual network."
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_address_prefixes" {
  description = "The address prefixes for the subnet."
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "app_gw_sku_name" {
  description = "The SKU name for the Application Gateway."
  type        = string
  default     = "Standard_v2"
}

variable "app_gw_sku_tier" {
  description = "The SKU tier for the Application Gateway."
  type        = string
  default     = "Standard_v2"
}

variable "app_gw_sku_capacity" {
  description = "The capacity for the Application Gateway SKU."
  type        = number
  default     = 2
}

variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
  default = {
    Environment = "Test"
    Project     = "Plex"
    ManagedBy   = "Terraform"
  }
}
