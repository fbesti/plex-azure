resource "azurerm_resource_group" "network" {
  name     = var.resource_group_name
  location = var.location
}

module "vnet" {
  source = "../../../modules/vnet"

  vnet_name           = "vnet-production"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.network.name
  tags = {
    environment = "production"
  }
}

module "network_watcher" {
  source = "../../../modules/network_watcher"

  name                = "network-watcher"
  location            = var.location
  resource_group_name = azurerm_resource_group.network.name
  tags = {
    environment = "production"
  }
}
