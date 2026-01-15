locals {
  prefix      = var.prefix
  env         = var.env
  location    = var.location
  region_abbr = var.region_abbr

  module_name = "aks"

  base_tags = merge(var.tags, {
    environment = local.env
    region      = local.region_abbr
  })

  tags = merge(local.base_tags, {
    component = local.module_name
  })

  aks_name = "${local.prefix}-aks-${local.env}-${local.region_abbr}-01"

  system_node_pool_name = "system"
}
