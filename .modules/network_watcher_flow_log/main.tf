resource "azurerm_network_watcher_flow_log" "this" {
  name                 = var.name
  network_watcher_name = var.network_watcher_name
  resource_group_name  = var.resource_group_name
  target_resource_id   = var.target_resource_id
  storage_account_id   = var.storage_account_id
  enabled              = var.enabled
  version              = var.version

  retention_policy {
    enabled = var.retention_policy_enabled
    days    = var.retention_policy_days
  }

  dynamic "traffic_analytics" {
    for_each = var.traffic_analytics_enabled ? [1] : []
    content {
      enabled               = var.traffic_analytics_enabled
      workspace_id          = var.traffic_analytics_workspace_id
      workspace_region      = var.traffic_analytics_workspace_region
      workspace_resource_id = var.traffic_analytics_workspace_resource_id
      interval_in_minutes   = var.traffic_analytics_interval_in_minutes
    }
  }

  tags = var.tags
}
