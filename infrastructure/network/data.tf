data "terraform_remote_state" "foo" {
  backend = "azurerm"
  config = {
    resource_group_name  = "rg-terraform-states-prod"
    storage_account_name = "stofustatesprdfbesti8106"
    container_name       = "tofu-state"
    key                  = "plex-prod.terraform.tfstate"
    use_oidc             = true
    subscription_id      = var.remote_state_subscription_id
    tenant_id            = var.remote_state_tenant_id
  }
}