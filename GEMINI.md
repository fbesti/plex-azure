# Project-Specific Information for Gemini CLI Agent

This `GEMINI.md` file contains important context and conventions for the `plex-azure` project, specifically regarding the GitHub Actions workflows for OpenTofu.

## GitHub Actions Workflow: `.github/workflows/infra.root.yaml`

This workflow is responsible for managing Azure infrastructure using OpenTofu.

### Key Jobs:

1.  **`setup_opentofu_backend`**:
    *   **Purpose**: Initializes and ensures the existence of the Azure Resource Group, Storage Account, and Blob Container used for storing OpenTofu state files.
    *   **Execution**: This job runs conditionally on `pull_request` events and `workflow_dispatch` (manual trigger). It is designed to set up the backend resources once and does not need to run on every `push` to `main`.

2.  **`opentofu_plan`**:
    *   **Purpose**: Generates an OpenTofu plan (`tfplan`) and uploads it as a workflow artifact. This plan represents the proposed infrastructure changes.
    *   **Execution**: This job runs exclusively on `pull_request` events.
    *   **Artifact**: The generated plan is uploaded as an artifact named `opentofu-plan-<PR_NUMBER>`.

3.  **`opentofu_apply`**:
    *   **Purpose**: Applies the OpenTofu plan to provision or update the Azure infrastructure.
    *   **Execution**: This job runs exclusively on `push` events to the `main` branch.
    *   **Plan Artifact Usage**: Instead of generating a new plan, this job downloads the `opentofu-plan` artifact from the corresponding pull request's workflow run. This ensures that the exact plan reviewed and approved during the pull request is applied.
    *   **Dependency**: This job depends on `setup_opentofu_backend` to ensure the state backend is configured, but it does *not* depend on `opentofu_plan` directly, allowing it to run even if `opentofu_plan` was skipped on the `main` branch push.
    *   **Tools Used**: `tofu init`, `tofu apply`, `dawidd6/action-download-artifact@v3` (for downloading the plan artifact).

### General Conventions:

*   **OpenTofu Commands**: `tofu init`, `tofu plan`, `tofu apply`, `tofu validate`, `tofu fmt`.
*   **Azure CLI**: Used for managing Azure resources (e.g., `az group create`, `az storage account create`).
*   **OIDC**: Azure login uses OpenID Connect (OIDC) for secure authentication.
*   **Working Directory**: OpenTofu commands are typically executed within the `./infrastructure` directory.
