provider "azurerm" {
  features {}
  use_oidc = true
  # client_id, tenant_id, subscription_id will be read from environment variables
}
