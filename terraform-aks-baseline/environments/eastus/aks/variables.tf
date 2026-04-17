# ------------------------------------------------------------
# Context
# ------------------------------------------------------------

variable "subscription_id" {
  description = "Azure subscription ID for this environment"
  type        = string
  nullable    = false
}

variable "tenant_id" {
  description = "Azure tenant ID used for AKS Azure AD integration"
  type        = string
  nullable    = false
}

variable "prefix" {
  description = "Naming prefix"
  type        = string
  nullable    = false
}

variable "env" {
  description = "Environment code"
  type        = string
  nullable    = false
}

variable "location" {
  description = "Azure region"
  type        = string
  nullable    = false
}

variable "region_abbr" {
  description = "Region abbreviation"
  type        = string
  nullable    = false
}

variable "tags" {
  description = "Base tags"
  type        = map(string)
  nullable    = false
}

# ------------------------------------------------------------
# Remote state
# ------------------------------------------------------------

variable "tfstate_rg" {
  description = "Resource group containing Terraform state storage"
  type        = string
  nullable    = false
}

variable "tfstate_storage" {
  description = "Storage account name for Terraform state"
  type        = string
  nullable    = false
}

variable "tfstate_container" {
  description = "Blob container name for Terraform state"
  type        = string
  nullable    = false
}

# ------------------------------------------------------------
# AKS configuration
# ------------------------------------------------------------

variable "kubernetes_version" {
  description = "AKS Kubernetes version"
  type        = string

  validation {
    condition     = can(regex("^1\\.(2[7-9]|3[0-9])", var.kubernetes_version))
    error_message = "Kubernetes version must be 1.27 or higher."
  }
}

variable "system_node_pool" {
  description = "System node pool configuration"
  type = object({
    vm_size    = string
    node_count = number
  })

  validation {
    condition     = var.system_node_pool.node_count >= 1
    error_message = "System node pool must have at least 1 node."
  }
}

variable "user_node_pools" {
  description = "Map of user node pool configurations"
  type = map(object({
    vm_size    = string
    node_count = number
  }))
  default = {}
}
