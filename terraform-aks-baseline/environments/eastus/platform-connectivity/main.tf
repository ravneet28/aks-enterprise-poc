module "platform_connectivity" {
  source = "../../../modules/platform-connectivity"

  prefix      = var.prefix
  env         = var.env
  location    = var.location
  region_abbr = var.region_abbr
  tags        = var.tags

  hub_vnet_address_space   = var.hub_vnet_address_space
  hub_subnets              = var.hub_subnets
  spoke_vnet_address_space = var.spoke_vnet_address_space
  spoke_subnets            = var.spoke_subnets
}
