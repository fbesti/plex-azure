module "virtual_machine_packet_capture" {
  source = "../../../.modules/virtual_machine_packet_capture"

  name                         = "example-vm-capture"
  network_watcher_id           = "example-watcher-id"
  virtual_machine_id           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-resources/providers/Microsoft.Compute/virtualMachines/example-vm"
  storage_location_storage_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-resources/providers/Microsoft.Storage/storageAccounts/examplestorage"
  storage_location_file_path   = "/path/to/capture.cap"

  filters = [{
    protocol          = "TCP"
    local_port        = "80"
    remote_ip_address = "1.2.3.4"
  }]
}
