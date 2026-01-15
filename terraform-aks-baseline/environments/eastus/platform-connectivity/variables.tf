variable "subscription_id" {
  description = "Azure subscription ID where resources will be deployed"
  type        = string
  nullable    = false
}

# ------------------------------------------------------------
# Context / identity
# ------------------------------------------------------------

variable "prefix" {
  description = "Naming prefix used across all resources"
  type        = string
  nullable    = false
}

variable "env" {
  description = "Environment code (sbx, dev, prod)"
  type        = string
  nullable    = false
}

variable "location" {
  description = "Azure region where resources will be deployed"
  type        = string
  nullable    = false
}

variable "region_abbr" {
  description = "Short region code (e.g. eus)"
  type        = string
  nullable    = false
}

variable "tags" {
  description = "Base tags applied to all resources"
  type        = map(string)
  nullable    = false
}

# ------------------------------------------------------------
# Hub network configuration
# ------------------------------------------------------------

variable "hub_vnet_address_space" {
  description = "Address space for the hub virtual network"
  type        = list(string)
  nullable    = false
}

variable "hub_subnets" {
  description = "Subnets for the hub virtual network"
  type = map(object({
    address_prefixes = list(string)
  }))
  nullable = false
}

# ------------------------------------------------------------
# Spoke (AKS) network configuration
# ------------------------------------------------------------

variable "spoke_vnet_address_space" {
  description = "Address space for the AKS spoke virtual network"
  type        = list(string)
  nullable    = false
}

variable "spoke_subnets" {
  description = "Subnets for the AKS spoke virtual network"
  type = map(object({
    address_prefixes = list(string)
    delegation       = optional(string)
  }))
  nullable = false
}

# ------------------------------------------------------------
# Optional platform features (future evolution)
# ------------------------------------------------------------

variable "enable_bastion" {
  description = "Whether to deploy Azure Bastion in the hub network"
  type        = bool
  default     = false
}

variable "enable_firewall" {
  description = "Whether to deploy Azure Firewall (introduced later)"
  type        = bool
  default     = false
}
