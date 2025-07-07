variable "gcp_project" {
  description = "GCP project ID"
  type        = string
}

variable "gcp_region" {
  description = "GCP region"
  type        = string
}

variable "gcp_zone" {
  description = "GCP zone"
  type        = string
}

variable "gcp_impersonated_sa" {
  description = "Email of the service account to impersonate via OIDC"
  type        = string
}

variable "gcp_machine_type" {
  description = "GCE machine type"
  type        = string
  default     = "e2-micro"
}

variable "gcp_boot_image" {
  description = "Boot image for the VM"
  type        = string
  default     = "debian-cloud/debian-11"
}
