module "platform_management" {
  source = "../../../modules/platform-management"

  prefix      = var.prefix
  env         = var.env
  location    = var.location
  region_abbr = var.region_abbr
  tags        = var.tags
}
