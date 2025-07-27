variable "name" {
  description = "The name of the Network Watcher."
  type        = string
}

variable "location" {
  description = "The supported Azure location where the resource exists."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the Network Watcher."
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}
