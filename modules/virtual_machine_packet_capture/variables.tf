variable "name" {
  description = "The name to use for this Network Packet Capture."
  type        = string
}

variable "network_watcher_id" {
  description = "The resource ID of the Network Watcher."
  type        = string
}

variable "virtual_machine_id" {
  description = "The resource ID of the target Virtual Machine to capture packets from."
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
  description = "A valid local path on the target Virtual Machine."
  type        = string
  default     = null
}

variable "storage_location_storage_account_id" {
  description = "The ID of the storage account where the packet capture sessions should be saved to."
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
