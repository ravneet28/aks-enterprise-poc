# ------------------------------------------------------------
# Context
# ------------------------------------------------------------

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
