#!/usr/bin/env bash

set -euo pipefail

REPO_NAME="terraform-aks-baseline"
REGION="eastus"

echo "Initializing AKS Baseline Terraform repository structure..."
echo "Repository: ${REPO_NAME}"
echo "Region: ${REGION}"
echo

# Create repo root
mkdir -p "${REPO_NAME}"
cd "${REPO_NAME}"

# -------------------------
# Root-level documentation
# -------------------------
touch README.md
touch NAMING_CONVENTION.md

# -------------------------
# Terraform modules
# -------------------------

# Platform Management
mkdir -p modules/platform-management
touch modules/platform-management/main.tf
touch modules/platform-management/variables.tf
touch modules/platform-management/locals.tf
touch modules/platform-management/outputs.tf
touch modules/platform-management/README.md

# Platform Connectivity
mkdir -p modules/platform-connectivity
touch modules/platform-connectivity/main.tf
touch modules/platform-connectivity/variables.tf
touch modules/platform-connectivity/locals.tf
touch modules/platform-connectivity/outputs.tf
touch modules/platform-connectivity/README.md

# AKS Module (intentionally split by concern)
mkdir -p modules/aks
touch modules/aks/main.tf
touch modules/aks/nodepools.tf
touch modules/aks/identities.tf
touch modules/aks/networking.tf
touch modules/aks/addons.tf
touch modules/aks/variables.tf
touch modules/aks/locals.tf
touch modules/aks/outputs.tf
touch modules/aks/README.md

# -------------------------
# Environment structure
# -------------------------

mkdir -p "environments/${REGION}"

# Platform Management environment
mkdir -p "environments/${REGION}/platform-management"
touch "environments/${REGION}/platform-management/main.tf"
touch "environments/${REGION}/platform-management/backend.tf"
touch "environments/${REGION}/platform-management/terraform.tfvars"

# Platform Connectivity environment
mkdir -p "environments/${REGION}/platform-connectivity"
touch "environments/${REGION}/platform-connectivity/main.tf"
touch "environments/${REGION}/platform-connectivity/backend.tf"
touch "environments/${REGION}/platform-connectivity/terraform.tfvars"

# AKS environment
mkdir -p "environments/${REGION}/aks"
touch "environments/${REGION}/aks/main.tf"
touch "environments/${REGION}/aks/backend.tf"
touch "environments/${REGION}/aks/terraform.tfvars"

# -------------------------
# Azure DevOps pipelines
# -------------------------
mkdir -p pipelines
touch pipelines/platform-management.yml
touch pipelines/platform-connectivity.yml
touch pipelines/aks-workload.yml

# -------------------------
# Git hygiene
# -------------------------
touch .gitignore

cat <<EOF > .gitignore
# Terraform
.terraform/
*.tfstate
*.tfstate.*
*.tfvars
.crash.log

# Azure DevOps
.azure-pipelines/

# IDEs
.vscode/
.idea/

# OS
.DS_Store
EOF

echo "Repository structure created successfully."
echo
echo "Next steps:"
echo "1. Add README.md and NAMING_CONVENTION.md content"
echo "2. Initialize git and push to Azure DevOps"
echo "3. Start coding Terraform module-by-module"
