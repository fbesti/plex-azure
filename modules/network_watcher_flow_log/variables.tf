variable "name" {
  description = "The name of the Network Watcher Flow Log."
  type        = string
}

variable "network_watcher_name" {
  description = "The name of the Network Watcher."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which the Network Watcher was deployed."
  type        = string
}

variable "target_resource_id" {
  description = "The ID of the Resource for which to enable flow logs for."
  type        = string
}

variable "storage_account_id" {
  description = "The ID of the Storage Account where flow logs are stored."
  type        = string
}

variable "enabled" {
  description = "Should Network Flow Logging be Enabled?"
  type        = bool
  default     = true
}

variable "version" {
  description = "The version (revision) of the flow log. Possible values are 1 and 2."
  type        = number
  default     = 2
}

variable "retention_policy_enabled" {
  description = "Boolean flag to enable/disable retention."
  type        = bool
  default     = true
}

variable "retention_policy_days" {
  description = "The number of days to retain flow log records."
  type        = number
  default     = 7
}

variable "traffic_analytics_enabled" {
  description = "Boolean flag to enable/disable traffic analytics."
  type        = bool
  default     = false
}

variable "traffic_analytics_workspace_id" {
  description = "The resource GUID of the attached workspace."
  type        = string
  default     = null
}

variable "traffic_analytics_workspace_region" {
  description = "The location of the attached workspace."
  type        = string
  default     = null
}

variable "traffic_analytics_workspace_resource_id" {
  description = "The resource ID of the attached workspace."
  type        = string
  default     = null
}

variable "traffic_analytics_interval_in_minutes" {
  description = "How frequently service should do flow analytics in minutes."
  type        = number
  default     = 60
}

variable "tags" {
  description = "A mapping of tags which should be assigned to the Network Watcher Flow Log."
  type        = map(string)
  default     = {}
}
