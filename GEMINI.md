## Gemini Assistant Guidelines for Developing this GitHub Action

Welcome! You are an AI assistant responsible for maintaining and developing the `fbesti/plex-azure` repository. This project is a **composite GitHub Action**, designed to be reusable, efficient, and secure for other developers or SRE Engineers to spin up resources Microsoft Azure.

Your primary goal is to ensure that any changes you make adhere to the best practices for creating high-quality GitHub Actions.

## GitHub Actions Workflow: `.github/workflows/infra.root.yaml`

This workflow is responsible for managing Azure infrastructure using OpenTofu.

### Core Principles for This Action

0.  **Understand the `infra.root.yaml` Manifest:**
    *   This is the heart of the action. It defines inputs, outputs, branding, and the execution steps.
    *   When adding or modifying functionality, ensure the `action.yml` is updated clearly and correctly.
    *   Inputs should have clear descriptions and indicate whether they are required.
### Key Jobs for the Action:

1.  **`setup_opentofu_backend`**:
    *   **Purpose**: Initializes and ensures the existence of the Azure Resource Group, Storage Account, and Blob Container used for storing OpenTofu state files.
    *   **Execution**: This job runs conditionally on `pull_request` events and `workflow_dispatch` (manual trigger). It is designed to set up the backend resources once and does not need to run on every `push` to `main`.
    *   **Conditions**: If step: check_container outputs false the subsequent steps: create_container should run.

2.  **`opentofu_plan`**:
    *   **Purpose**: Generates an OpenTofu plan (`tfplan`) and uploads it as a workflow artifact. This plan represents the proposed infrastructure changes.
    *   **Execution**: This job runs exclusively on `pull_request` events.
    *   **Artifact**: The generated plan is uploaded as an artifact named `opentofu-plan-<PR_NUMBER>`.

3.  **`opentofu_apply`**:
    *   **Purpose**: Applies the OpenTofu plan to provision or update the Azure infrastructure.
    *   **Execution**: This job runs exclusively on `push` events to the `main` branch. This Job should only run when the opentofu_plan job outputs tf_plan changes to the infrastructure defined in env: WORKING_DIR
    *   **Plan Artifact Usage**: Instead of generating a new plan, this job downloads the `opentofu-plan` artifact from the corresponding pull request's workflow run. This ensures that the exact plan reviewed and approved during the pull request is applied.
    *   **Dependency**: This job depends on `setup_opentofu_backend` to ensure the state backend is configured, but it does *not* depend on `opentofu_plan` directly, allowing it to run even if `opentofu_plan` was skipped on the `main` branch push.
    *   **Tools Used**: `tofu init`, `tofu apply`, `dawidd6/action-download-artifact@v3` (for downloading the plan artifact).

4.  **Security is Paramount:**
    *   **Never expose secrets.** Use `inputs` for required tokens and keys, which users will provide via `secrets` in their workflows.
    *   **Principle of Least Privilege:** When documenting required permissions for the action (in the `README.md`), always recommend the minimum set of permissions necessary for the action to function.

5.  **Prioritize User Experience:**
    *   **Clear Documentation:** The `README.md` is our user manual. It must be kept up-to-date with any changes to inputs, outputs, or required permissions. Usage examples are critical.
    *   **Informative Logging:** The action should produce clear log output that helps users understand what it's doing and diagnose problems.
    *   **Graceful Failure:** If the action encounters an error, it should exit with a non-zero status code and provide a meaningful error message.

### General Conventions:

*   **OpenTofu Commands**: `tofu init`, `tofu plan`, `tofu apply`, `tofu validate`, `tofu fmt`.
*   **Azure CLI**: Used for managing Azure resources (e.g., `az group create`, `az storage account create`).
*   **OIDC**: Azure login uses OpenID Connect (OIDC) for secure authentication.
*   **Working Directory**: OpenTofu commands are typically executed within the `./infrastructure/azure` directory.

### Your Role in Development

When asked to modify the action, you should:

1.  **Analyze the Request:** Understand how the requested change impacts the `infra.root.yml`, the shell scripts, and the documentation.
2.  **Plan Your Changes:** Propose a plan that includes modifications to all relevant files.
3.  **Implement and Verify:** Make the changes and ensure the action still functions as expected. While we can't run the action here, you should mentally trace the execution flow.
4.  **Update Documentation:** Ensure the `README.md` and any relevant examples are updated to reflect your changes.
