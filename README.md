# Azure GitHub Action

This GitHub Action can be used to setup any infrastructure in Azure.
It uses Open Tofu as a primary tool.

## Prerequisites

Before using this action, you must have the following Azure resources and credentials:

*   An Azure subscription
*   An Azure Service Principal with the `Contributor` role assigned at the subscription level.

## Usage

To use this action, you will need to add the following secrets to your GitHub repository:

*   `AZURE_CLIENT_ID`: The client ID of your Azure Service Principal.
*   `AZURE_TENANT_ID`: The tenant ID of your Azure subscription.
*   `AZURE_SUBSCRIPTION_ID`: Your Azure subscription ID.

These secrets should be added to your repository's `Settings > Secrets and variables > Actions` page.

### Example Workflow

```yaml
name: Deploy Azure Infrastructure

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Run Azure Action
        uses: fbesti/plex-azure@main
        with:
          AZURE_CLIENT_ID: ${{ secrets.AZURE_CLIENT_ID }}
          AZURE_TENANT_ID: ${{ secrets.AZURE_TENANT_ID }}
          AZURE_SUBSCRIPTION_ID: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
```

## Contributing

Contributions are welcome! Please open an issue or submit a pull request with your changes.
