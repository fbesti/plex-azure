# Your main infrastructure code
resource "azurerm_resource_group" "example" {
  name     = "rg-example"
  location = "North Europe"
}