resource "azurerm_resource_group" "plex_cert" {
  name     = var.resource_group_name
  location = var.location
}


resource "azurerm_resource_group" "plex_test" {
  name     = var.resource_group_name_test
  location = var.location
}