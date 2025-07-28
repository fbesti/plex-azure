resource "azurerm_virtual_machine_packet_capture" "this" {
  name                                = var.name
  network_watcher_id                  = var.network_watcher_id
  virtual_machine_id                  = var.virtual_machine_id
  maximum_bytes_per_packet            = var.maximum_bytes_per_packet
  maximum_bytes_per_session           = var.maximum_bytes_per_session
  maximum_capture_duration_in_seconds = var.maximum_capture_duration_in_seconds

  storage_location {
    file_path          = var.storage_location_file_path
    storage_account_id = var.storage_location_storage_account_id
  }

  dynamic "filter" {
    for_each = var.filters
    content {
      protocol          = filter.value.protocol
      local_ip_address  = lookup(filter.value, "local_ip_address", null)
      local_port        = lookup(filter.value, "local_port", null)
      remote_ip_address = lookup(filter.value, "remote_ip_address", null)
      remote_port       = lookup(filter.value, "remote_port", null)
    }
  }
}
