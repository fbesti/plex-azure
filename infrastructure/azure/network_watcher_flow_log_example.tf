module "network_watcher_flow_log" {
  source = "../../.modules/network_watcher_flow_log"

  name                 = "example-flow-log"
  network_watcher_name = "example-watcher"
  resource_group_name  = "example-resources"
  target_resource_id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-resources/providers/Microsoft.Network/networkSecurityGroups/example-nsg"
  storage_account_id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-resources/providers/Microsoft.Storage/storageAccounts/examplestorage"
  enabled              = true
  version              = 2

  retention_policy_enabled = true
  retention_policy_days    = 7

  traffic_analytics_enabled               = true
  traffic_analytics_workspace_id          = "00000000-0000-0000-0000-000000000000"
  traffic_analytics_workspace_region      = "West Europe"
  traffic_analytics_workspace_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-resources/providers/Microsoft.OperationalInsights/workspaces/example-workspace"
  traffic_analytics_interval_in_minutes   = 10


  tags = {
    environment = "production"
  }
}
