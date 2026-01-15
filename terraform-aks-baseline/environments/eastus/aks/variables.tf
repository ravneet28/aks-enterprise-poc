# ------------------------------------------------------------
# Context
# ------------------------------------------------------------

variable "prefix" {
  type        = string
  nullable    = false
}

variable "env" {
  type        = string
  nullable    = false
}

variable "location" {
  type        = string
  nullable    = false
}

variable "region_abbr" {
  type        = string
  nullable    = false
}

variable "tags" {
  type        = map(string)
  nullable    = false
}

# ------------------------------------------------------------
# AKS configuration
# ------------------------------------------------------------

variable "kubernetes_version" {
  type        = string
  nullable    = false
}

variable "system_node_pool" {
  type = object({
    vm_size    = string
    node_count = number
  })
  nullable = false
}

variable "user_node_pools" {
  type = map(object({
    vm_size    = string
    node_count = number
  }))
  default = {}
}

variable "tfstate_rg" {
  type        = string
  description = "Resource group containing Terraform state storage"
}

variable "tfstate_storage" {
  type        = string
  description = "Storage account name for Terraform state"
}

variable "tfstate_container" {
  type        = string
  description = "Blob container name for Terraform state"
}

variable "subscription_id" {
  description = "Azure subscription ID for this environment"
  type        = string
  nullable    = false
}

