
variable "subnet_name" {
  description = "The name of the subnet."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "virtual_network_name" {
  description = "The name of the virtual network."
  type        = string
}

variable "address_prefixes" {
  description = "The address prefixes for the subnet."
  type        = list(string)
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "service_endpoints" {
  description = "A list of service endpoints to associate with the subnet."
  type        = list(string)
  default     = null
}

variable "delegation" {
  description = "A delegation block as defined in the AzureRM provider documentation."
  type        = any
  default     = []
}

variable "network_security_group_id" {
  description = "The ID of the Network Security Group to associate with the subnet."
  type        = string
  default     = null
}

variable "route_table_id" {
  description = "The ID of the Route Table to associate with the subnet."
  type        = string
  default     = null
}
