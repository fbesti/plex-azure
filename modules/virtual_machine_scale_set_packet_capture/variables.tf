variable "name" {
  description = "The name to use for this Network Packet Capture."
  type        = string
}

variable "network_watcher_id" {
  description = "The resource ID of the Network Watcher."
  type        = string
}

variable "virtual_machine_scale_set_id" {
  description = "The resource ID of the Virtual Machine Scale Set to capture packets from."
  type        = string
}

variable "maximum_bytes_per_packet" {
  description = "The number of bytes captured per packet."
  type        = number
  default     = 0
}

variable "maximum_bytes_per_session" {
  description = "Maximum size of the capture in Bytes."
  type        = number
  default     = 1073741824
}

variable "maximum_capture_duration_in_seconds" {
  description = "The maximum duration of the capture session in seconds."
  type        = number
  default     = 18000
}

variable "storage_location_file_path" {
  description = "A valid local path on the targeting VM."
  type        = string
  default     = null
}

variable "storage_location_storage_account_id" {
  description = "The ID of the storage account to save the packet capture session."
  type        = string
  default     = null
}

variable "filters" {
  description = "A list of filter blocks."
  type = list(object({
    protocol          = string
    local_ip_address  = optional(string)
    local_port        = optional(string)
    remote_ip_address = optional(string)
    remote_port       = optional(string)
  }))
  default = []
}

variable "machine_scope_include_instance_ids" {
  description = "A list of Virtual Machine Scale Set instance IDs which should be included for Packet Capture."
  type        = list(string)
  default     = null
}

variable "machine_scope_exclude_instance_ids" {
  description = "A list of Virtual Machine Scale Set instance IDs which should be excluded from running Packet Capture."
  type        = list(string)
  default     = null
}
