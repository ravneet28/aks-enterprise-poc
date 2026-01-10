# Terraform Structure & Best Practices

This document explains the **Terraform repository structure**, design decisions, and **best practices** used in this project.

It is intentionally aligned with:

* Microsoft Cloud Adoption Framework (CAF)
* AKS Baseline Reference Architecture
* AKS Well-Architected Framework
* Real-world platform engineering practices

This README is meant to be read **before writing Terraform code**.

---

## 1. Guiding Principles

This Terraform codebase follows these non-negotiable principles:

1. **Architecture first, resources second**
   Terraform modules represent *architectural responsibilities*, not individual Azure resources.

2. **Separation of concerns**
   Platform concerns (networking, monitoring) are separated from workload concerns (AKS).

3. **Safe-by-default**
   The structure enables partial deploys and destroys to avoid unnecessary Azure costs.

4. **Microsoft-aligned**
   All decisions map back to Microsoft AKS Baseline and Well-Architected guidance.

---

## 2. High-Level Repository Layout

```
terraform-aks-baseline/
├── modules/
├── environments/
├── pipelines/
├── README.md
├── NAMING_CONVENTION.md
```

### Directory Responsibilities

| Directory              | Responsibility                                   |
| ---------------------- | ------------------------------------------------ |
| `modules/`             | Reusable, environment-agnostic Terraform modules |
| `environments/`        | Environment & region-specific orchestration      |
| `pipelines/`           | Azure DevOps CI/CD pipelines                     |
| `README.md`            | Architectural overview                           |
| `NAMING_CONVENTION.md` | Authoritative naming standard                    |

---

## 3. Modules Directory (`modules/`)

### Purpose

Modules encapsulate **one architectural responsibility**.

Examples:

* Platform management (monitoring, logs)
* Platform connectivity (networking)
* AKS workload (cluster, identities, addons)

Modules:

* Contain **no environment-specific values**
* Are reusable across environments and regions
* Are designed for long-term stability

---

### 3.1 Module File Structure (Standard)

Each module follows this baseline structure:

```
module-name/
├── main.tf
├── variables.tf
├── locals.tf
├── outputs.tf
└── README.md
```

#### File Responsibilities

| File           | Purpose                                             |
| -------------- | --------------------------------------------------- |
| `main.tf`      | Core resource definitions and orchestration         |
| `variables.tf` | Module inputs (no defaults for env-specific values) |
| `locals.tf`    | Naming logic, tags, derived values                  |
| `outputs.tf`   | Explicit contract to other layers                   |
| `README.md`    | Module-level documentation                          |

---

### 3.2 When to Split Files Further

Large or complex modules (e.g., AKS) are split **by concern**, not by resource:

```
aks/
├── main.tf          # AKS cluster
├── nodepools.tf    # Node pools
├── identities.tf   # Managed identities
├── networking.tf   # Subnet and routing integration
├── addons.tf       # Monitoring, policy, security addons
```

This improves:

* Readability
* Reviewability
* Mapping to baseline architecture controls

---

## 4. Environments Directory (`environments/`)

### Purpose

The `environments/` directory wires modules together for a **specific region and environment**.

It is the *only* place where:

* Regions
* Environment codes
* Backend configuration
* Variable values

are defined.

---

### 4.1 Environment Structure

```
environments/eastus/
├── platform-management/
├── platform-connectivity/
└── aks/
```

Each subdirectory:

* Maps to **one Terraform state**
* Can be deployed or destroyed independently

---

### 4.2 Environment File Responsibilities

```
platform-management/
├── main.tf
├── backend.tf
└── terraform.tfvars
```

| File               | Purpose                                |
| ------------------ | -------------------------------------- |
| `main.tf`          | Calls modules and passes configuration |
| `backend.tf`       | Remote state configuration             |
| `terraform.tfvars` | Environment-specific values            |

No Azure resources are defined directly in environment files.

---

## 5. Terraform State Management

### Principles

* **Remote state only** (Azure Storage Account)
* **One state per architectural layer**
* Never share state across unrelated concerns

### Benefits

* Partial `terraform destroy`
* Reduced blast radius
* Cost control
* Easier troubleshooting

---

## 6. Naming & Tagging Standards

All naming follows the rules defined in:

```
NAMING_CONVENTION.md
```

### Key Rules

* No hardcoded names
* All names generated via `locals.tf`
* Mandatory tags applied to all resources

This ensures governance consistency and auditability.

---

## 7. Variables & Defaults Best Practices

### Variables

* Variables represent **configuration**, not logic
* Required variables have no defaults
* Optional variables have safe defaults

### Defaults

Defaults must:

* Be cost-aware
* Be safe for sandbox environments
* Never assume production scale

---

## 8. Azure DevOps Pipelines (`pipelines/`)

### Pipeline Philosophy

* One pipeline per architectural layer
* Terraform commands are pipeline-driven
* No manual local applies for shared environments

### Pipeline Responsibilities

* `terraform init`
* `terraform validate`
* `terraform plan`
* `terraform apply` (controlled)

This aligns with Microsoft’s recommendation for repeatable infrastructure delivery.

---

## 9. Cost Management Best Practices

This structure is intentionally designed to prevent cost overruns:

* Independent layers can be destroyed safely
* Expensive services are introduced incrementally
* No always-on premium services by default

Cost discipline is treated as a **design requirement**, not an afterthought.

---

## 10. Common Anti-Patterns to Avoid

Do **not**:

* Create one Terraform file per Azure resource
* Hardcode names or regions
* Define resources in environment folders
* Share Terraform state across layers
* Mix platform and workload concerns

These anti-patterns lead to fragile and unmaintainable codebases.

---

## 11. How This Structure Evolves

This structure supports:

* Additional environments (`dev`, `prod`)
* Additional regions
* Management Groups (later)
* Enterprise-scale adoption

No refactoring is required as complexity increases.

---

## 12. Intended Audience

This Terraform structure is designed for:

* Platform engineers
* Cloud architects
* SRE / DevOps engineers

It assumes familiarity with Terraform basics and Azure fundamentals.

---

## 13. Status

This document defines the **authoritative Terraform structure and best practices** for this repository.

All Terraform code must comply with the guidance described here.
