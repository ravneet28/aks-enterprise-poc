variable "subscription_id" {
  description = "Azure subscription ID where resources will be deployed"
  type        = string
  nullable    = false
}

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