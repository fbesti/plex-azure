output "resource_group_name" {
  description = "The name of the created resource group."
  value       = azurerm_resource_group.plex_cert.name
}
