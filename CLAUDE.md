# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This repository provides reusable GitHub Actions workflows for managing Azure infrastructure using both OpenTofu and Terraform. It implements a secure, multi-service-principal model for separating backend state management from application infrastructure management. The project is designed to be reusable, efficient, and secure for developers and SRE engineers to provision resources in Microsoft Azure, Google Cloud Platform, and Amazon.

## Core Principles

### 1. Security First
- **Never expose secrets** - Use inputs for required tokens and keys via workflow secrets
- **Principle of Least Privilege** - Recommend minimum permissions necessary for functionality
- **OIDC Authentication** - Azure login uses OpenID Connect for secure authentication

### 2. User Experience
- **Clear Documentation** - Keep README.md updated with changes to inputs, outputs, and permissions
- **Informative Logging** - Produce clear log output for troubleshooting
- **Graceful Failure** - Exit with meaningful error messages and non-zero status codes

### 3. Best Practices
- Emphasis on Infrastructure as Code (IaC)
- Strong preference for automation over manual processes
- Follow CI/CD best practices for rapid and reliable deployments

## Key Commands

### OpenTofu/Terraform Operations
- **Format check**: `tofu fmt -check -recursive` or `terraform fmt -check -recursive`
- **Initialize**: `tofu init` or `terraform init` (with backend config parameters)
- **Validate**: `tofu validate` or `terraform validate`
- **Plan**: `tofu plan -out=tfplan` or `terraform plan -out=tfplan`
- **Apply**: `tofu apply tfplan` or `terraform apply tfplan`

## Architecture

### Security Model
The repository implements a dual service principal approach:
- **SP-Backend**: Highly privileged principal for initial backend setup only
- **SP-Infra**: Less privileged principal for daily plan/apply operations, explicitly denied access to backend resources

### Directory Structure
```
infrastructure/
├── azure/          # Main Azure infrastructure modules
│   ├── network/    # Network-related resources
│   ├── network_watcher/  # Network monitoring
│   ├── subnet/     # Subnet configurations
│   └── vnet/       # Virtual network setups
├── aws/            # AWS infrastructure (basic setup)
└── gcp/            # GCP infrastructure (basic setup)

.modules/           # Reusable Terraform modules
├── network_watcher/
├── network_watcher_flow_log/
├── subnet/
├── virtual_machine_packet_capture/
├── virtual_machine_scale_set_packet_capture/
└── vnet/

.github/workflows/  # GitHub Actions workflows
├── later                       # Disabled workflows
├── reusable-opentofu-*.yaml    # OpenTofu reusable workflows
├── reusable-terraform-*.yaml   # Terraform reusable workflows
├── opentofu-*.yaml               # Infrastructure OpenTofu workflows
├── terraform-*.yaml               # Infrastructure Terraform specific workflows

infor/ # User Folder with md files for the User
```

### Reusable Workflows
The repository provides three main reusable workflow types:
1. **Backend Verification** (`reusable-verify-backend.yaml`): Bootstraps and verifies backend storage
2. **Plan Workflows** (`reusable-*-plan.yaml`): Generates and uploads plans for review
3. **Apply Workflows** (`reusable-*-apply.yaml`): Applies approved plans to infrastructure

### Workflow Architecture Details

#### OpenTofu/Terraform Workflow Steps:

1. **`setup`**
   - Purpose: Initialize and validate GitHub UI environment variables
   - Execution: Runs unconditionally

2. **`verify_backend`**
   - Purpose: Initialize Azure Resource Group, Storage Account, and Blob Container for state files
   - Execution: Runs on `pull_request` and `workflow_dispatch` events
   - Dependencies: Requires successful `setup` step
   - Conditional logic: Creates resources only if they don't exist

3. **`plan`**
   - Purpose: Generate plan and upload as workflow artifact
   - Execution: Runs exclusively on `pull_request` events
   - Artifact: Uploaded as `plan-<PR_NUMBER>`

4. **`apply`**
   - Purpose: Apply the plan to provision/update Azure infrastructure
   - Execution: Runs exclusively on `push` to `main` branch
   - Dependencies: Downloads plan artifact from corresponding PR workflow
   - Tools: `tofu init`/`terraform init`, `tofu apply`/`terraform apply`, artifact download actions

#### Making Changes to Core Workflows

When modifying reusable workflows:
1. **Analyze Dependencies** - Understand impact on other workflows
2. **Plan Holistically** - Consider all workflow interdependencies
3. **Update Documentation** - Maintain accurate README.md

### State Management
- Backend state stored in Azure Storage Account with blob container
- Automatic firewall rule management for GitHub runner IP access
- Remote state configuration injected via backend-config parameters

### Module Pattern
All infrastructure components are organized as reusable modules in `.modules/` with consistent structure:
- `main.tf`: Resource definitions
- `variables.tf`: Input parameters
- `outputs.tf`: Exported values

## GitHub Configuration Requirements

### Required Secrets
- `SP_BACKEND_AZURE_CLIENT_ID`, `SP_BACKEND_AZURE_TENANT_ID`, `SP_BACKEND_AZURE_SUBSCRIPTION_ID`
- `SP_INFRA_AZURE_CLIENT_ID`, `SP_INFRA_AZURE_TENANT_ID`, `SP_INFRA_AZURE_SUBSCRIPTION_ID`

### Required Variables
- `CLOUD_ENVIRONMENT`: GitHub Environment name
- `TF_STATE_RG`: Backend resource group name
- `TF_STATE_SA`: Backend storage account name
- `TF_STATE_CONTAINER`: Backend blob container name
- `TF_STATE_KEY`: State file name
- `AZURE_LOCATION`: Azure region for backend resources
- `AZURE_SA_SKU`, `AZURE_SA_KIND`, `AZURE_SA_TIER`: Storage account configuration

## Development Workflow

1. **Pull Requests**: Trigger plan workflows for code review
2. **Plan Generation**: Creates and uploads plan artifacts for review
3. **Apply on Merge**: Applies approved plans when merged to main branch
4. **State Security**: Backend resources protected by separate service principal permissions

## Response Guidelines

When working with this repository, follow these communication guidelines:

- Use specific language code blocks (```powershell, ```bash, ```python, ```hcl)
- Provide practical, executable solutions
- Ask for clarification on ambiguous questions
- Provide logical debugging sequences
- Keep responses concise but comprehensive
- Include relevant Azure CLI/PowerShell commands when discussing Azure resources
- Wait for user confirmation on numbered task plans and adjust as requested

