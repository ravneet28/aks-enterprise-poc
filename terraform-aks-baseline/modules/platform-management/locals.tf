locals {
  prefix      = var.prefix
  env         = var.env
  location    = var.location
  region_abbr = var.region_abbr

  module_name = "platform-management"

  base_tags = merge(var.tags, {
    environment = local.env
    region      = local.region_abbr
  })

  tags = merge(local.base_tags, {
    component = local.module_name
  })

  rg_name = "rg-${local.prefix}-platform-management-${local.env}-${local.region_abbr}"

  log_analytics_name = "${local.prefix}-law-${local.env}-${local.region_abbr}-01"
}
