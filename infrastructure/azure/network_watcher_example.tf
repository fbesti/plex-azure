module "network_watcher" {
  source = "../../.modules/network_watcher"

  name                = "example-watcher"
  location            = "West Europe"
  resource_group_name = "example-resources"
  tags = {
    environment = "production"
  }
}
