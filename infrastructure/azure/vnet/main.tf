module "vnet" {
  source = "../../../.modules/vnet"

  vnet_name           = "example-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = "West Europe"
  resource_group_name = "example-resources"
  tags = {
    environment = "production"
  }
}
