module "virtual_machine_scale_set_packet_capture" {
  source = "../../.modules/virtual_machine_scale_set_packet_capture"

  name                                = "example-vmss-capture"
  network_watcher_id                  = "example-watcher-id"
  virtual_machine_scale_set_id        = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-resources/providers/Microsoft.Compute/virtualMachineScaleSets/example-vmss"
  storage_location_storage_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-resources/providers/Microsoft.Storage/storageAccounts/examplestorage"
  storage_location_file_path          = "/path/to/capture.cap"

  filters = [{
    protocol    = "Any"
    remote_port = "443"
  }]

  machine_scope_include_instance_ids = ["0", "1"]
}
