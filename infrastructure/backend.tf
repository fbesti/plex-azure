terraform {
    backend "azurerm" {
      resource_group_name  = "rg-terraform-states-prod"
      storage_account_name = "stofustatesprdfbesti8106"
      container_name       = "tofu-state"
      key                  = "terraform.tfstate"
    }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  required_version = ">= 1.0"
}