# AI Assistant Guidelines for ot-azure Repository

## Overview

This repository provides reusable GitHub Actions workflows for managing Azure infrastructure using both OpenTofu and Terraform. The project is designed to be reusable, efficient, and secure for developers and SRE engineers to provision resources in Microsoft Azure, Google Cloud Platform, and Amazon.

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


## Workflow Architecture

### OPEN TOFU Workflow: `opentofu-infra-rg.yaml`

This workflow manages Azure infrastructure using OpenTofu with four key steps:

1. **`setup`**
   - Purpose: Initialize and validate GitHub UI environment variables
   - Execution: Runs unconditionally

2. **`verify_backend`**
   - Purpose: Initialize Azure Resource Group, Storage Account, and Blob Container for OpenTofu state files
   - Execution: Runs on `pull_request` and `workflow_dispatch` events
   - Dependencies: Requires successful `setup` step
   - Conditional logic: Creates resources only if they don't exist

3. **`opentofu_plan`**
   - Purpose: Generate OpenTofu plan and upload as workflow artifact
   - Execution: Runs exclusively on `pull_request` events
   - Artifact: Uploaded as `opentofu-plan-<PR_NUMBER>`

4. **`opentofu_apply`**
   - Purpose: Apply the OpenTofu plan to provision/update Azure infrastructure
   - Execution: Runs exclusively on `push` to `main` branch
   - Dependencies: Downloads plan artifact from corresponding PR workflow
   - Tools: `tofu init`, `tofu apply`, `dawidd6/action-download-artifact@v3`

### Reusable Open Tofu Workflows
- **`reusable-verify-backend.yaml`** - Backend storage verification and creation
- **`reusable-opentofu-plan.yaml`** - Plan generation and artifact upload
- **`reusable-opentofu-apply.yaml`** - Plan application and infrastructure deployment

### Making Changes to Core Workflows

When modifying reusable workflows:
1. **Analyze Dependencies** - Understand impact on other workflows
2. **Plan Holistically** - Consider all workflow interdependencies
3. **Update Documentation** - Maintain accurate README.md

## Response Guidelines

- Use specific language code blocks (```powershell, ```bash, ```python, ```hcl)
- Provide practical, executable solutions
- Ask for clarification on ambiguous questions
- Provide logical debugging sequences
- Keep responses concise but comprehensive
- Include relevant Azure CLI/PowerShell commands when discussing Azure resources
- Wait for user confirmation on numbered task plans and adjust as requested