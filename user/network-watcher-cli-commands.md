# Azure Network Watcher CLI Commands

This document provides examples of Azure CLI commands for Network Watcher tools that do not have dedicated Terraform providers.

## Topology

The `az network watcher show-topology` command provides a network-level view of resources and their relationships in a resource group.

### Get the topology of a resource group

```bash
az network watcher show-topology -g <resource-group-name>
```

### Get the topology of a virtual network

```bash
az network watcher show-topology -g <resource-group-name> --vnet <vnet-name-or-id>
```

### Get the topology of a subnet

```bash
az network watcher show-topology -g <resource-group-name> --vnet <vnet-name> --subnet <subnet-name-or-id>
```

## IP Flow Verify

The `az network watcher test-ip-flow` command verifies if a packet is allowed or denied to or from a virtual machine.

### Test outbound flow to a public IP

```bash
az network watcher test-ip-flow --direction 'outbound' --protocol 'TCP' --local '10.0.0.4:60000' --remote '13.107.21.200:80' --vm <vm-name-or-id> --nic <nic-name-or-id> -g <resource-group-name> --out 'table'
```

### Test inbound flow from a specific IP

```bash
az network watcher test-ip-flow --direction 'inbound' --protocol 'TCP' --local '10.0.0.4:80' --remote '10.1.1.1:60000' --vm <vm-name-or-id> --nic <nic-name-or-id> -g <resource-group-name> --out 'table'
```

## NSG Diagnostics

The `az network watcher run-configuration-diagnostic` command allows you to diagnose network security group (NSG) rules.

### Run NSG diagnostics on a virtual machine

```bash
az network watcher run-configuration-diagnostic --resource <vm-name-or-id> --resource-group <resource-group-name> --resource-type 'virtualMachines' --direction 'Inbound' --protocol 'TCP' --source '10.0.1.0/26' --destination '10.0.0.4' --port '*'
```

## Next Hop

The `az network watcher show-next-hop` command gets the next hop from a VM, which is useful for diagnosing routing issues.

### Get the next hop from a VM to a destination IP

```bash
az network watcher show-next-hop --dest-ip <destination-ip> --source-ip <source-ip> --vm <vm-name-or-id> -g <resource-group-name>
```

## Effective Security Rules

The `az network nic list-effective-nsg` command retrieves the effective security rules for a network interface.

### List effective security rules for a network interface

```bash
az network nic list-effective-nsg -g <resource-group-name> --name <nic-name>
```

## Connection Troubleshoot

The `az network watcher test-connectivity` command tests the connectivity between two endpoints.

### Test connectivity between two virtual machines

```bash
az network watcher test-connectivity -g <resource-group-name> --source-resource <source-vm-name-or-id> --dest-resource <destination-vm-name-or-id> --protocol 'TCP' --dest-port '3389'
```

### Test connectivity to a web address

```bash
az network watcher test-connectivity -g <resource-group-name> --source-resource <source-vm-name-or-id> --dest-address 'www.bing.com' --protocol 'TCP' --dest-port '443'
```

## VPN Troubleshoot

The `az network watcher troubleshooting start` and `az network watcher troubleshooting show` commands are used to troubleshoot VPN gateways and connections.

### Start troubleshooting a VPN gateway

```bash
az network watcher troubleshooting start -g <resource-group-name> --resource <gateway-name-or-id> --resource-type 'vnetGateway' --storage-account <storage-account-name-or-id> --storage-path <blob-container-url>
```

### Start troubleshooting a VPN connection

```bash
az network watcher troubleshooting start -g <resource-group-name> --resource <connection-name-or-id> --resource-type 'vpnConnection' --storage-account <storage-account-name-or-id> --storage-path <blob-container-url>
```

### Get the results of the last troubleshooting operation

```bash
az network watcher troubleshooting show -g <resource-group-name> --resource <gateway-or-connection-name-or-id>
```
