module "subnet" {
  source = "../../.modules/subnet"

  subnet_name          = "example-subnet"
  resource_group_name  = "example-resources"
  virtual_network_name = "example-vnet"
  address_prefixes     = ["10.0.1.0/24"]
  service_endpoints    = ["Microsoft.Storage"]

  delegation = [{
    name = "delegation"
    service_delegation = {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
    }
  }]

  network_security_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-resources/providers/Microsoft.Network/networkSecurityGroups/example-nsg"
  route_table_id            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-resources/providers/Microsoft.Network/routeTables/example-rt"
}
