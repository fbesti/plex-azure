output "resource_group_name" {
  description = "The name of the created resource group."
  value       = azurerm_resource_group.plex_cert.name
}

output "app_gateway_zones" {
  description = "The availability zones of the application gateway."
  value       = azurerm_application_gateway.app_gw_test.zones
}
