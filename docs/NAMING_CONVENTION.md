# AKS Baseline Landing Zone – Naming Convention

This document defines the **official naming convention** for the AKS Baseline Landing Zone implementation.

It is aligned with:

* Microsoft Cloud Adoption Framework (CAF)
* AKS Baseline Reference Architecture
* AKS Well-Architected Framework
* mspnp/aks-baseline GitHub repository

This convention is designed to be:

* Production-grade
* Terraform-friendly
* Azure DevOps–friendly
* Cost-aware (safe for sandbox / free credits)
* Scalable without refactoring

---

## 1. Design Principles (Microsoft-Aligned)

The naming convention follows these principles derived from Microsoft guidance:

* Names must express **purpose and ownership**
* Names must be **deterministic and automation-safe**
* Resource Groups are the **primary organizational boundary**
* Names must scale across:

  * Environments
  * Regions
  * Subscriptions
  * Multiple AKS clusters

---

## 2. Global Naming Pattern

All resources follow this canonical pattern:

```
<prefix>-<workload>-<component>-<env>-<region>-<instance>
```

### Segment Definitions

| Segment     | Description                        | Example              |
| ----------- | ---------------------------------- | -------------------- |
| `prefix`    | Platform / organization identifier | `aksblz`             |
| `workload`  | Logical workload or platform       | `platform`, `aks`    |
| `component` | Resource function or type          | `law`, `vnet`, `aks` |
| `env`       | Environment                        | `sbx`, `dev`, `prod` |
| `region`    | Azure region (short code)          | `eus`                |
| `instance`  | Numeric identifier                 | `01`                 |

---

## 3. Environment Codes

| Environment          | Code   |
| -------------------- | ------ |
| Sandbox / Playground | `sbx`  |
| Development          | `dev`  |
| Production           | `prod` |

Current implementation uses:

```
env = sbx
```

---

## 4. Region Codes

| Azure Region | Code  |
| ------------ | ----- |
| East US      | `eus` |

Current implementation uses:

```
region = eastus        # For Azure API usage (e.g., Terraform, Azure CLI)
region_abbr = eus      # For resource naming patterns
```

---

## 5. Resource Group Naming (Authoritative)

**Pattern**

```
rg-<prefix>-<workload>-<component>-<env>-<region>
```

**Examples**

```
rg-aksblz-platform-mgmt-sbx-eus
rg-aksblz-platform-net-sbx-eus
rg-aksblz-aks-workload-sbx-eus
```

Rationale:

* Resource Groups define ownership and lifecycle
* Aligns with CAF governance recommendations

---

## 6. Log Analytics Workspace

**Pattern**

```
<prefix>-<workload>-law-<env>-<region>-<instance>
```

**Example**

```
aksblz-platform-law-sbx-eus-01
```

---

## 7. Virtual Networks

**Pattern**

```
<prefix>-<workload>-vnet-<env>-<region>-<instance>
```

**Examples**

```
aksblz-platform-vnet-sbx-eus-01
aksblz-aks-vnet-sbx-eus-01
```

---

## 8. Subnet Naming

Subnets use a simplified pattern as recommended by Microsoft.

**Pattern**

```
snet-<purpose>
```

**Examples**

```
snet-hub-fw
snet-aks-system
snet-aks-user
snet-appgw
```

---

## 9. AKS Cluster Naming

**Pattern**

```
<prefix>-<workload>-aks-<env>-<region>-<instance>
```

**Example**

```
aksblz-aks-aks-sbx-eus-01
```

Note:

* The double `aks` is intentional
* First indicates workload, second indicates resource type

---

## 10. Managed Identity Naming

**Pattern**

```
<prefix>-<workload>-id-<purpose>-<env>-<region>
```

**Examples**

```
aksblz-aks-id-controlplane-sbx-eus
aksblz-aks-id-kubelet-sbx-eus
```

---

## 11. Azure DevOps Pipeline Naming

**Pattern**

```
<workload>-<component>-<env>
```

**Examples**

```
platform-management-sbx
platform-connectivity-sbx
aks-workload-sbx
```

---

## 12. Mandatory Resource Tags

All resources must include the following tags:

```
environment = sbx
workload    = aks-baseline
owner       = ""
managed-by  = terraform
```

Tags are defined centrally using Terraform locals to ensure consistency.

---

## 13. Terraform Implementation Standard

### Global Locals

```hcl
locals {
  prefix       = "aksblz"
  env          = "sbx"
  region       = "eastus"
  region_abbr  = "eus"

  tags = {
    environment = local.env
    workload    = "aks-baseline"
    owner       = ""
    managed-by  = "terraform"
  }
}
```

### Example Usage

```hcl
name = "${local.prefix}-platform-law-${local.env}-${local.region_abbr}-01"
```

---

## 14. Future-Proofing

This naming convention supports:

* Multiple environments
* Multiple regions
* Multiple AKS clusters
* Multi-subscription landing zones
* Enterprise-scale adoption

No renaming or refactoring will be required as the platform evolves.

---

## 15. Status

**Approved for use in the AKS Baseline Landing Zone implementation.**
