# Azure GitHub Action

This GitHub Action can be used to setup any infrastructure in Azure.
It uses Open Tofu as a primary tool.

## Prerequisites

Before using this action, you must have the following Azure resources and credentials:

*   An Azure subscription.
*   An Azure Service Principal. To adhere to the principle of least privilege, we recommend one of the following approaches:

    **Option 1: (Recommended)**
    1.  Manually create an Azure Resource Group to store the OpenTofu state files.
    2.  Assign the `Contributor` role to your Service Principal **only on this Resource Group**.
    3.  Manually create an Azure Storage Account inside this Resource Group.
    4.  Assign the `Storage Blob Data Contributor` role to your Service Principal **on this Storage Account**.

    **Option 2: (Most Secure)**
    If you require more granular control, you can create a custom role with the following permissions and assign it to your Service Principal at the subscription level. This will allow the action to create the backend infrastructure for you.

    ```json
    {
      "Name": "OpenTofu-GitHub-Action-Role",
      "IsCustom": true,
      "Description": "Custom role for the OpenTofu GitHub Action",
      "Actions": [
        "Microsoft.Resources/subscriptions/resourcegroups/read",
        "Microsoft.Resources/subscriptions/resourcegroups/write",
        "Microsoft.Storage/storageAccounts/read",
        "Microsoft.Storage/storageAccounts/write",
        "Microsoft.Storage/storageAccounts/blobServices/write",
        "Microsoft.Storage/storageAccounts/listkeys/action"
      ],
      "NotActions": [],
      "AssignableScopes": [
        "/subscriptions/YOUR_SUBSCRIPTION_ID"
      ]
    }
    ```

    **Important:** The above permissions are only for the `verify_backend` workflow. The `opentofu_apply` workflow will require additional permissions based on the resources you are deploying. You should add those permissions to the custom role as needed. For example, if you are deploying a Virtual Network, you would need to add `Microsoft.Network/virtualNetworks/write`.

## Configuration

### Secrets

To use this action, you will need to add the following secrets to your GitHub repository's `Settings > Secrets and variables > Actions` page:

*   `AZURE_CLIENT_ID`: The client ID of your Azure Service Principal.
*   `AZURE_TENANT_ID`: The tenant ID of your Azure subscription.
*   `AZURE_SUBSCRIPTION_ID`: Your Azure subscription ID.

### Variables

You must also configure the following repository variables in `Settings > Secrets and variables > Actions`:

*   `CLOUD_ENVIRONMENT`: The name of the GitHub Environment to use for the workflow. This allows for different sets of variables and secrets to be used for different environments (e.g., `development`, `staging`, `production`).
*   `TF_STATE_RG`: The name of the Azure Resource Group where the OpenTofu state will be stored.
*   `TF_STATE_SA`: The name of the Azure Storage Account where the OpenTofu state will be stored.
*   `TF_STATE_CONTAINER`: The name of the Blob Container within the Storage Account.
*   `TF_STATE_KEY`: The name of the OpenTofu state file (e.g., `terraform.tfstate`).
*   `AZURE_LOCATION`: The Azure region where the backend resources will be created (e.g., `eastus`).
*   `AZURE_SA_SKU`: The SKU for the backend Storage Account (e.g., `Standard_LRS`).
*   `AZURE_SA_KIND`: The kind for the backend Storage Account (e.g., `StorageV2`).
*   `AZURE_SA_TIER`: The access tier for the backend Storage Account (e.g., `Hot`).

### GitHub Environments

This workflow uses [GitHub Environments](https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment) to manage environment-specific variables and secrets. You will need to create an environment in your repository (e.g., `production`) and add the required variables to it. The `CLOUD_ENVIRONMENT` variable should contain the name of this environment.

### Example Workflow

Here is an example of how to use the reusable workflows in this repository to create your own CI/CD pipeline for Azure infrastructure. You can adapt this example to your needs.

```yaml
name: Deploy Azure Infrastructure

on:
  pull_request:
    types: [opened, synchronize, reopened]
    paths:
      - 'infrastructure/**' # Adjust to your infrastructure directory
  push:
    branches:
      - main
    paths:
      - 'infrastructure/**' # Adjust to your infrastructure directory

permissions:
  id-token: write
  contents: read
  actions: read

jobs:
  setup:
    runs-on: ubuntu-latest
    environment: production # Or your target environment
    outputs:
      TF_STATE_RG: ${{ vars.TF_STATE_RG }}
      TF_STATE_SA: ${{ vars.TF_STATE_SA }}
      TF_STATE_CONTAINER: ${{ vars.TF_STATE_CONTAINER }}
      TF_STATE_KEY: ${{ vars.TF_STATE_KEY }}
      AZURE_LOCATION: ${{ vars.AZURE_LOCATION }}
      AZURE_SA_SKU: ${{ vars.AZURE_SA_SKU }}
      AZURE_SA_KIND: ${{ vars.AZURE_SA_KIND }}
      AZURE_SA_TIER: ${{ vars.AZURE_SA_TIER }}
      CLOUD_ENVIRONMENT: ${{ vars.CLOUD_ENVIRONMENT }}
    steps:
      - name: Output environment variables
        run: echo "Sourced variables from the environment."

  verify_backend:
    if: github.event_name == 'pull_request' || github.event_name == 'workflow_dispatch'
    needs: setup
    uses: fbesti/plex-azure/.github/workflows/reusable-verify-backend.yaml@main
    secrets:
      AZURE_CLIENT_ID: ${{ secrets.AZURE_CLIENT_ID }}
      AZURE_TENANT_ID: ${{ secrets.AZURE_TENANT_ID }}
      AZURE_SUBSCRIPTION_ID: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
    with:
      CLOUD_ENVIRONMENT: ${{ needs.setup.outputs.CLOUD_ENVIRONMENT }}
      TF_STATE_RG: ${{ needs.setup.outputs.TF_STATE_RG }}
      TF_STATE_SA: ${{ needs.setup.outputs.TF_STATE_SA }}
      TF_STATE_CONTAINER: ${{ needs.setup.outputs.TF_STATE_CONTAINER }}
      TF_STATE_KEY: ${{ needs.setup.outputs.TF_STATE_KEY }}
      AZURE_LOCATION: ${{ needs.setup.outputs.AZURE_LOCATION }}
      AZURE_SA_SKU: ${{ needs.setup.outputs.AZURE_SA_SKU }}
      AZURE_SA_KIND: ${{ needs.setup.outputs.AZURE_SA_KIND }}
      AZURE_SA_TIER: ${{ needs.setup.outputs.AZURE_SA_TIER }}

  opentofu_plan:
    if: github.event_name == 'pull_request'
    needs: [setup, verify_backend]
    uses: fbesti/plex-azure/.github/workflows/reusable-opentofu-plan.yaml@main
    secrets:
      AZURE_CLIENT_ID: ${{ secrets.AZURE_CLIENT_ID }}
      AZURE_TENANT_ID: ${{ secrets.AZURE_TENANT_ID }}
      AZURE_SUBSCRIPTION_ID: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
    with:
      CLOUD_ENVIRONMENT: ${{ needs.setup.outputs.CLOUD_ENVIRONMENT }}
      TF_STATE_RG: ${{ needs.setup.outputs.TF_STATE_RG }}
      TF_STATE_SA: ${{ needs.setup.outputs.TF_STATE_SA }}
      TF_STATE_CONTAINER: ${{ needs.setup.outputs.TF_STATE_CONTAINER }}
      TF_STATE_KEY: ${{ needs.setup.outputs.TF_STATE_KEY }}
      PULL_REQUEST_NUMBER: ${{ github.event.pull_request.number }}
      WORKING_DIR: ./infrastructure/azure # Adjust to your working directory

  opentofu_apply:
    if: github.event_name == 'push' && github.ref == 'refs/heads/main'
    needs: setup
    uses: fbesti/plex-azure/.github/workflows/reusable-opentofu-apply.yaml@main
    secrets:
      AZURE_CLIENT_ID: ${{ secrets.AZURE_CLIENT_ID }}
      AZURE_TENANT_ID: ${{ secrets.AZURE_TENANT_ID }}
      AZURE_SUBSCRIPTION_ID: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
    with:
      CLOUD_ENVIRONMENT: ${{ needs.setup.outputs.CLOUD_ENVIRONMENT }}
      TF_STATE_RG: ${{ needs.setup.outputs.TF_STATE_RG }}
      TF_STATE_SA: ${{ needs.setup.outputs.TF_STATE_SA }}
      TF_STATE_CONTAINER: ${{ needs.setup.outputs.TF_STATE_CONTAINER }}
      TF_STATE_KEY: ${{ needs.setup.outputs.TF_STATE_KEY }}
      HEAD_COMMIT_MESSAGE: ${{ github.event.head_commit.message }}
      WORKING_DIR: ./infrastructure/azure # Adjust to your working directory
```

### Workflow Explained

*   **`verify_backend`**: This job initializes and ensures the existence of the Azure Resource Group, Storage Account, and Blob Container used for storing OpenTofu state files.
*   **`opentofu_plan`**: This job generates an OpenTofu plan (`tfplan`) and uploads it as a workflow artifact. This plan represents the proposed infrastructure changes.
*   **`opentofu_apply`**: This job applies the OpenTofu plan to provision or update the Azure infrastructure. It downloads the plan artifact from the pull request and applies it, ensuring that the exact plan that was reviewed is applied.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request with your changes.
