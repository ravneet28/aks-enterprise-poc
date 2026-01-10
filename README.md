# AKS Baseline Landing Zone

> **A Microsoft-aligned, cost-aware, Terraform-based implementation of the AKS Baseline Architecture using Azure DevOps**

---

## 1. Purpose of This Repository

This repository implements a **minimal yet production-grade Azure Landing Zone** and **AKS Baseline architecture** using:

* **Terraform** (Infrastructure as Code)
* **Azure DevOps** (CI/CD pipelines)
* **Microsoft AKS Baseline Reference Architecture**
* **Azure Well-Architected Framework for AKS**

The primary goal is **deep architectural understanding**, not just deployment.

This implementation is intentionally:

* **Baseline-compliant** (per Microsoft documentation)
* **Cost-aware** (safe for Azure playgrounds and $200 free credits)
* **Incremental** (build → validate → destroy)
* **Enterprise-scalable** (no refactoring required later)

---

## 2. Authoritative References (Must-Read)

This repository strictly adheres to the following Microsoft sources:

* **AKS Baseline Reference Architecture**
  [https://learn.microsoft.com/en-us/azure/architecture/reference-architectures/containers/aks/baseline-aks](https://learn.microsoft.com/en-us/azure/architecture/reference-architectures/containers/aks/baseline-aks)

* **AKS Well-Architected Framework**
  [https://learn.microsoft.com/en-us/azure/well-architected/service-guides/azure-kubernetes-service](https://learn.microsoft.com/en-us/azure/well-architected/service-guides/azure-kubernetes-service)

* **Microsoft AKS Baseline Reference Implementation (mspnp)**
  [https://github.com/mspnp/aks-baseline](https://github.com/mspnp/aks-baseline)

Any design choice made in this repository can be traced back to one or more of the above sources.

---

## 3. Architectural Philosophy

### 3.1 AKS Is a Workload, Not a Platform

Per Microsoft guidance, AKS is treated as a **landing-zone workload**, not a foundational service.

This means:

* Networking, identity, monitoring, and governance are **pre-existing platform capabilities**
* AKS **consumes** these capabilities

This repository therefore builds:

1. A **Landing Zone foundation**
2. An **AKS workload** on top of it

---

## 4. Scope and Constraints

### 4.1 Landing Zone Scope (Option A)

This implementation follows a **Minimal Baseline Landing Zone**:

* Single Azure subscription
* No management groups (tenant-safe)
* Logical separation using:

  * Resource Groups
  * Terraform layers
* Fully aligned with Microsoft baseline intent

This approach is ideal for:

* Learning environments
* Personal subscriptions
* Proof-of-concepts
* Cost-constrained scenarios

---

## 5. High-Level Architecture Overview

```
Azure Subscription
│
├── Platform Management
│   └── Log Analytics, Monitoring, Diagnostics
│
├── Platform Connectivity
│   └── Hub VNet (Firewall added later)
│
└── AKS Workload
    ├── Spoke VNet
    ├── AKS Cluster (Private)
    ├── Ingress
    └── Observability Integration
```

This mirrors the **hub-and-spoke topology** described in the AKS Baseline Architecture.

---

## 6. Repository Structure

```
terraform-aks-baseline/
├── README.md
├── NAMING_CONVENTION.md
├── modules/
│   ├── platform-management/
│   ├── platform-connectivity/
│   └── aks/
├── environments/
│   └── eastus/
│       ├── platform-management/
│       ├── platform-connectivity/
│       └── aks/
├── pipelines/
│   ├── platform-management.yml
│   ├── platform-connectivity.yml
│   └── aks-workload.yml
```

### Separation of Concerns

* **Modules**: Reusable, environment-agnostic Terraform code
* **Environments**: Region- and environment-specific orchestration
* **Pipelines**: One pipeline per architectural layer

This structure aligns with Microsoft’s platform vs workload team model.

---

## 7. Naming Convention (Mandatory)

All resources follow a **strict, documented naming convention** defined in:

```
NAMING_CONVENTION.md
```

Key characteristics:

* CAF-aligned
* Deterministic
* Terraform-driven (locals-based)
* Scalable across environments and regions

No resource names are hardcoded.

---

## 8. Terraform Standards

### 8.1 Terraform Version

* Terraform CLI: **>= 1.5 (latest stable)**
* AzureRM Provider: **~> 3.x**

### 8.2 State Management

* Remote backend using **Azure Storage Account**
* Separate state per architectural layer

Example states:

* platform-management.tfstate
* platform-connectivity.tfstate
* aks.tfstate

This enables safe, partial destruction and cost control.

---

## 9. Azure DevOps Integration

Azure DevOps is used for:

* Source control
* Terraform plan/apply
* Environment separation

### Pipeline Design Principles

* One pipeline per layer
* `terraform plan` on PRs
* `terraform apply` only on main branch
* No automatic resource creation without review

This prevents accidental cost leakage.

---

## 10. Cost Management Strategy

This repository is intentionally designed to be **credit-safe**:

* No Azure Firewall initially
* No Application Gateway initially
* Minimal node counts for AKS
* Reduced Log Analytics retention
* Build → validate → destroy workflow

More expensive components are introduced **only when architecturally required**.

---

## 11. Build Phases

### Phase 1 – Platform Management

* Log Analytics Workspace
* Diagnostic foundations

### Phase 2 – Platform Connectivity

* Hub VNet
* Spoke VNet
* Peering

### Phase 3 – AKS Workload

* Private AKS cluster
* Managed identities
* Baseline security

### Phase 4 – Ingress & Egress

* Application Gateway (WAF)
* Azure Firewall
* Forced tunneling

### Phase 5 – Observability & Governance

* Azure Monitor
* Defender for Containers
* Azure Policy enforcement

Each phase builds on the previous one.

---

## 12. Target Audience

This repository is designed for:

* Platform Engineers
* Cloud Architects
* SRE / DevOps Engineers
* Product Leads seeking architectural depth

It assumes:

* Basic Azure knowledge
* Familiarity with Terraform concepts
* Desire to understand **why**, not just **how**

---

## 13. Status

This repository represents a **living implementation**.

It will evolve incrementally while maintaining:

* Microsoft baseline alignment
* Architectural correctness
* Cost discipline

---

## 14. Disclaimer

This repository is for **learning and reference purposes**.

It is not an official Microsoft product, but it strictly follows Microsoft’s published architecture guidance.
