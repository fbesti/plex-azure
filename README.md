# Azure GitHub Action

This GitHub Action can be used to setup any infrastructure in Azure.
It uses Open Tofu as a primary tool.

## Secure Permissions Model

This repository is designed to support a highly secure, multi-service-principal model that separates the management of your core IaC backend from your day-to-day application infrastructure.

*   **Backend Service Principal (`SP-Backend`):** A highly privileged principal used **only** for the initial setup of the OpenTofu state backend. Its credentials should be used sparingly and stored securely.
*   **Infrastructure Service Principal (`SP-Infra`):** A less privileged principal used for the daily `opentofu plan` and `opentofu apply` operations. It is explicitly denied access to the backend resources.

We highly recommend this two-principal approach. A simpler, single-principal manual setup is also provided as an alternative.

---

## Option 1: Automated Backend Bootstrap (Recommended)

This is the most secure and recommended approach. It involves two distinct steps and two service principals.

### Step 1.1: Create the Backend Service Principal (`SP-Backend`)

This principal will have just enough permission to create the Resource Group, Storage Account, and Blob Container for the state file.

1.  **Create a custom role** named `OpenTofu Backend Creator` with the following JSON. This role grants the minimum permissions required to create and configure the backend.

    ```json
    {
      "Name": "OpenTofu Backend Creator",
      "IsCustom": true,
      "Description": "Allows creation of Resource Group and Storage Account for OpenTofu backend.",
      "Actions": [
        "Microsoft.Resources/subscriptions/resourcegroups/read",
        "Microsoft.Resources/subscriptions/resourcegroups/write",
        "Microsoft.Storage/storageAccounts/read",
        "Microsoft.Storage/storageAccounts/write",
        "Microsoft.Storage/storageAccounts/blobServices/write"
      ],
      "NotActions": [],
      "DataActions": [
        "Microsoft.Storage/storageAccounts/blobServices/containers/read",
        "Microsoft.Storage/storageAccounts/blobServices/containers/write"
      ],
      "NotDataActions": [],
      "AssignableScopes": [
        "/subscriptions/YOUR_SUBSCRIPTION_ID"
      ]
    }
    ```

2.  **Create a new Service Principal** (`SP-Backend`).
3.  **Assign the `OpenTofu Backend Creator` role** to this new SP at the subscription scope.
4.  **Create GitHub Secrets** for this principal's credentials (e.g., `SP_BACKEND_AZURE_CLIENT_ID`, `SP_BACKEND_AZURE_TENANT_ID`, `SP_BACKEND_AZURE_SUBSCRIPTION_ID`).

### Step 1.2: Create the Infrastructure Service Principal (`SP-Infra`)

This principal will manage your application resources. Its permissions are carefully configured to allow it to *use* the backend state file while being blocked from damaging the backend resources themselves.

1.  **Create a second Service Principal** (`SP-Infra`).
2.  **Assign application infrastructure roles:** Grant this SP the necessary roles to manage your application resources (e.g., `Contributor` on a separate `app-resource-group`).
3.  **Assign data-plane access to the backend:** Grant the `Storage Blob Data Contributor` role to `SP-Infra` directly on the `TF_STATE_SA` Storage Account. This is critical as it allows the `plan/apply` jobs to read and write the state file.
4.  **Deny management-plane access to the backend:** Assign a Deny permission to `SP-Infra` on the `TF_STATE_RG` resource group. This prevents it from deleting the Storage Account or altering its configuration, providing a vital security boundary.
5.  **Create GitHub Secrets** for this principal's credentials (e.g., `SP_INFRA_AZURE_CLIENT_ID`, etc.).

---

## Option 2: Manual Backend Creation (Simpler Alternative)

If you prefer a simpler setup with a single Service Principal, you can manually create the backend resources and assign fine-grained permissions.

1.  **Manually create the following Azure resources:**
    *   An Azure Resource Group (e.g., `my-tofu-state-rg`).
    *   An Azure Storage Account inside that Resource Group.
2.  **Create a single Service Principal.**
3.  **Assign the following roles to your Service Principal directly on the Storage Account scope (NOT the Resource Group):**
    *   **`Storage Account Contributor`**: Allows the workflow to manage firewall rules and versioning on the Storage Account.
    *   **`Storage Blob Data Contributor`**: Allows the workflow to read/write the OpenTofu state file blobs.

This configuration ensures the Service Principal can manage the state file but cannot delete the Storage Account itself.

---

## Configuration

### GitHub Secrets

Based on the option you chose, add the corresponding secrets to your GitHub repository's `Settings > Secrets and variables > Actions` page. For the recommended two-principal approach, you would have:

*   `SP_BACKEND_AZURE_CLIENT_ID`
*   `SP_BACKEND_AZURE_TENANT_ID`
*   `SP_BACKEND_AZURE_SUBSCRIPTION_ID`
*   `SP_INFRA_AZURE_CLIENT_ID`
*   `SP_INFRA_AZURE_TENANT_ID`
*   `SP_INFRA_AZURE_SUBSCRIPTION_ID`

### GitHub Variables

You must also configure the following repository variables in `Settings > Secrets and variables > Actions`:

*   `CLOUD_ENVIRONMENT`: The name of the GitHub Environment to use (e.g., `production`).
*   `TF_STATE_RG`: The name of the Azure Resource Group for the backend.
*   `TF_STATE_SA`: The name of the Azure Storage Account for the backend.
*   `TF_STATE_CONTAINER`: The name of the Blob Container for the state file.
*   `TF_STATE_KEY`: The name of the OpenTofu state file (e.g., `terraform.tfstate`).
*   `AZURE_LOCATION`: The Azure region for the backend resources (e.g., `eastus`).
*   `AZURE_SA_SKU`: The SKU for the backend Storage Account (e.g., `Standard_LRS`).
*   `AZURE_SA_KIND`: The kind for the backend Storage Account (e.g., `StorageV2`).
*   `AZURE_SA_TIER`: The access tier for the backend Storage Account (e.g., `Hot`).

### GitHub Environments

This workflow uses [GitHub Environments](https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment) to manage environment-specific variables and secrets. You will need to create an environment in your repository (e.g., `production`) and add the required variables and secrets to it.

### Example Workflow

Here is an example of how to use the reusable workflows, adapted for the recommended two-service-principal model.

```yaml
name: Azure Open Tofu Resources CI/CD Workflow

on:
  pull_request:
    types: [opened, synchronize, reopened]
    paths:
      - '.github/workflows/infra.root.yaml'
      - 'infrastructure/azure/**'
  push:
    branches:
      - main
    paths:
      - '.github/workflows/infra.root.yaml'
      - 'infrastructure/azure/**'

permissions:
  id-token: write
  contents: read
  actions: read

jobs:
  setup:
    runs-on: ubuntu-latest
    environment: ${{ vars.CLOUD_ENVIRONMENT }}
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
        run: echo "Sourced variables from the ${{ vars.CLOUD_ENVIRONMENT }} environment."

  verify_backend:
    if: github.event_name == 'pull_request' || github.event_name == 'workflow_dispatch'
    needs: setup
    uses: fbesti/ot-azure/.github/workflows/reusable-verify-backend.yaml@main
    secrets:
      # Use the highly privileged SP-Backend credentials ONLY for this job
      AZURE_CLIENT_ID: ${{ secrets.SP_BACKEND_AZURE_CLIENT_ID }}
      AZURE_TENANT_ID: ${{ secrets.SP_BACKEND_AZURE_TENANT_ID }}
      AZURE_SUBSCRIPTION_ID: ${{ secrets.SP_BACKEND_AZURE_SUBSCRIPTION_ID }}
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
    uses: fbesti/ot-azure/.github/workflows/reusable-opentofu-plan.yaml@main
    secrets:
      # Use the less privileged SP-Infra for daily plan/apply operations
      AZURE_CLIENT_ID: ${{ secrets.SP_INFRA_AZURE_CLIENT_ID }}
      AZURE_TENANT_ID: ${{ secrets.SP_INFRA_AZURE_TENANT_ID }}
      AZURE_SUBSCRIPTION_ID: ${{ secrets.SP_INFRA_AZURE_SUBSCRIPTION_ID }}
    with:
      CLOUD_ENVIRONMENT: ${{ needs.setup.outputs.CLOUD_ENVIRONMENT }}
      TF_STATE_RG: ${{ needs.setup.outputs.TF_STATE_RG }}
      TF_STATE_SA: ${{ needs.setup.outputs.TF_STATE_SA }}
      TF_STATE_CONTAINER: ${{ needs.setup.outputs.TF_STATE_CONTAINER }}
      TF_STATE_KEY: ${{ needs.setup.outputs.TF_STATE_KEY }}
      PULL_REQUEST_NUMBER: ${{ github.event.pull_request.number }}
      WORKING_DIR: ./infrastructure/azure

  opentofu_apply:
    if: github.event_name == 'push' && github.ref == 'refs/heads/main'
    needs: setup
    uses: fbesti/ot-azure/.github/workflows/reusable-opentofu-apply.yaml@main
    secrets:
      # Use the less privileged SP-Infra for daily plan/apply operations
      AZURE_CLIENT_ID: ${{ secrets.SP_INFRA_AZURE_CLIENT_ID }}
      AZURE_TENANT_ID: ${{ secrets.SP_INFRA_AZURE_TENANT_ID }}
      AZURE_SUBSCRIPTION_ID: ${{ secrets.SP_INFRA_AZURE_SUBSCRIPTION_ID }}
    with:
      CLOUD_ENVIRONMENT: ${{ needs.setup.outputs.CLOUD_ENVIRONMENT }}
      TF_STATE_RG: ${{ needs.setup.outputs.TF_STATE_RG }}
      TF_STATE_SA: ${{ needs.setup.outputs.TF_STATE_SA }}
      TF_STATE_CONTAINER: ${{ needs.setup.outputs.TF_STATE_CONTAINER }}
      TF_STATE_KEY: ${{ needs.setup.outputs.TF_STATE_KEY }}
      HEAD_COMMIT_MESSAGE: ${{ github.event.head_commit.message }}
      WORKING_DIR: ./infrastructure/azure
```

### Workflow Explained

*   **`setup`**: This initial job is responsible for sourcing all the necessary variables from the specified GitHub Environment. **It is critical that this job includes the `environment:` key.** This key tells the job which GitHub Environment to connect to, allowing it to access the environment-specific variables (defined in `vars`) and pass them to the downstream jobs. Without it, all variables will be empty, and the workflow will fail.
*   **`verify_backend`**: This job initializes and ensures the existence of the Azure Resource Group, Storage Account, and Blob Container used for storing OpenTofu state files. It should be run with the highly privileged `SP-Backend` credentials.
*   **`opentofu_plan`**: This job generates an OpenTofu plan (`tfplan`) and uploads it as a workflow artifact. This and the `apply` job should use the less-privileged `SP-Infra` credentials.
*   **`opentofu_apply`**: This job applies the OpenTofu plan to provision or update the Azure infrastructure. It downloads the plan artifact from the pull request and applies it, ensuring that the exact plan that was reviewed is applied.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request with your changes.
