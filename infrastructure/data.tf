data "terraform_remote_state" "foo" {
  backend = "azurerm"
  config = {
    resource_group_name  = "rg-terraform-states-prod"
    storage_account_name = "stofustatesprdfbesti8106"
    container_name       = "tofu-state"
    key                  = "plex-prod.terraform.tfstate"
    use_oidc             = true
    subscription_id      = "643ffd4e-7aaa-46b9-b411-45d836f5c628"
    tenant_id            = "0d7c675e-2aec-4a6b-b02d-d089194b2ea9"
  }
}