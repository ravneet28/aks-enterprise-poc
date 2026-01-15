locals {
  # ------------------------------------------------------------
  # Context (from variables)
  # ------------------------------------------------------------
  prefix      = var.prefix
  env         = var.env
  location    = var.location
  region_abbr = var.region_abbr

  # ------------------------------------------------------------
  # Module identity
  # ------------------------------------------------------------
  module_name = "platform-connectivity"

  # ------------------------------------------------------------
  # Base and module-specific tags
  # ------------------------------------------------------------
  base_tags = merge(var.tags, {
    environment = local.env
    region      = local.region_abbr
    workload    = "aks-baseline"
  })

  tags = merge(local.base_tags, {
    component = local.module_name
  })

  # ------------------------------------------------------------
  # Resource naming
  # ------------------------------------------------------------
  rg_name = "rg-${local.prefix}-platform-connectivity-${local.env}-${local.region_abbr}"
  hub_vnet_name   = "${local.prefix}-platform-vnet-hub-${local.env}-${local.region_abbr}-01"
  spoke_vnet_name = "${local.prefix}-aks-vnet-spoke-${local.env}-${local.region_abbr}-01"
  hub_subnets   = var.hub_subnets
  spoke_subnets = var.spoke_subnets
  
  # Optional helper for consistent naming later
  name_prefix = "${local.prefix}-${local.env}-${local.region_abbr}"
}