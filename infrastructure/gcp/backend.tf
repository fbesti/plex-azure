terraform {
  backend "gcs" {
    bucket  = "your-terraform-state-bucket"
    prefix  = "env/project-name"
  }
  required_providers {
    google = {
      project = "seraphic-vertex-359008"
      region  = "europe-north1"
    }
  }
  required_version = ">= 1.0"
}