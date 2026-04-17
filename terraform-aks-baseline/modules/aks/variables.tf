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

  nullable = false
}

variable "region_abbr" {
  description = "Region abbreviation"
  type        = string

  nullable = false
}

variable "tags" {
  description = "Base tags"
  type        = map(string)
  nullable    = false
}

# ------------------------------------------------------------
# Networking (from platform-connectivity)
# ------------------------------------------------------------

variable "node_subnet_id" {
  description = "Subnet ID for AKS node pools"
  type        = string
  nullable    = false
}

# variable "apiserver_subnet_id" {
#   description = "Subnet ID for AKS API server VNet integration"
#   type        = string
#   nullable    = false
# }

# ------------------------------------------------------------
# Monitoring (from platform-management)
# ------------------------------------------------------------

variable "log_analytics_workspace_id" {
  description = "Log Analytics workspace ID for AKS monitoring"
  type        = string
  nullable    = false
}

# ------------------------------------------------------------
# AKS configuration (minimal, baseline-safe)
# ------------------------------------------------------------

variable "resource_group_name" {
  description = "Resource group where AKS will be deployed"
  type        = string
  nullable    = false
}

variable "admin_group_object_ids" {
  description = "Microsoft Entra group object IDs that receive AKS cluster admin access."
  type        = list(string)
  default     = []
  nullable    = false
}

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

# ------------------------------------------------------------
# User node pools
# ------------------------------------------------------------

variable "user_node_pools" {
  description = "Map of user node pool configurations"
  type = map(object({
    vm_size    = string
    node_count = number
  }))
  default = {}
}
