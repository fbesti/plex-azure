
resource "azurerm_resource_group" "plex_cert" {
  name     = var.resource_group_name
  location = var.location
}