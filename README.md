# Azure GitHub Action

This GitHub Action can be used to setup any infrastructure in Azure.
It uses Open Tofu as a primary tool.

## Prerequisites

Before using this action, you must have the following Azure resources and credentials:

*   An Azure subscription
*   An Azure Service Principal with the `Contributor` role assigned at the subscription level.

## Configuration

### Secrets

To use this action, you will need to add the following secrets to your GitHub repository's `Settings > Secrets and variables > Actions` page:

*   `AZURE_CLIENT_ID`: The client ID of your Azure Service Principal.
*   `AZURE_TENANT_ID`: The tenant ID of your Azure subscription.
*   `AZURE_SUBSCRIPTION_ID`: Your Azure subscription ID.

### Variables

You must also configure the following repository variables in `Settings > Secrets and variables > Actions`:

*   `TF_STATE_RG`: The name of the Azure Resource Group where the OpenTofu state will be stored.
*   `TF_STATE_SA`: The name of the Azure Storage Account where the OpenTofu state will be stored.
*   `TF_STATE_CONTAINER`: The name of the Blob Container within the Storage Account.
*   `TF_STATE_KEY`: The name of the OpenTofu state file (e.g., `terraform.tfstate`).
*   `AZURE_LOCATION`: The Azure region where the backend resources will be created (e.g., `eastus`).
*   `AZURE_SA_SKU`: The SKU for the backend Storage Account (e.g., `Standard_LRS`).
*   `AZURE_SA_KIND`: The kind for the backend Storage Account (e.g., `StorageV2`).
*   `AZURE_SA_TIER`: The access tier for the backend Storage Account (e.g., `Hot`).

### Example Workflow

Here is an example of how to use this action in your own workflow:

```yaml
name: Deploy Azure Infrastructure

on:
  pull_request:
    types: [opened, synchronize, reopened]
  push:
    branches:
      - main

jobs:
  deploy:
    uses: fbesti/plex-azure/.github/workflows/infra.root.yaml@main
    secrets:
      AZURE_CLIENT_ID: ${{ secrets.AZURE_CLIENT_ID }}
      AZURE_TENANT_ID: ${{ secrets.AZURE_TENANT_ID }}
      AZURE_SUBSCRIPTION_ID: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
```

## Contributing

Contributions are welcome! Please open an issue or submit a pull request with your changes.
