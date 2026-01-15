# ------------------------------------------------------------
# Platform Connectivity
# ------------------------------------------------------------

module "platform_connectivity" {
  source = "../../platform-connectivity"

  prefix      = var.prefix
  env         = var.env
  location    = var.location
  region_abbr = var.region_abbr
  tags        = var.tags

  # Networking shape
  hub_vnet_address_space   = var.hub_vnet_address_space
  hub_subnets              = var.hub_subnets
  spoke_vnet_address_space = var.spoke_vnet_address_space
  spoke_subnets            = var.spoke_subnets
}

# ------------------------------------------------------------
# Platform Management
# ------------------------------------------------------------

module "platform_management" {
  source = "../../../modules/platform-management"

  prefix      = var.prefix
  env         = var.env
  location    = var.location
  region_abbr = var.region_abbr
  tags        = var.tags
}


# ------------------------------------------------------------
# AKS
# ------------------------------------------------------------

module "aks" {
  source = "../../../modules/aks"

  # Context
  prefix      = var.prefix
  env         = var.env
  location    = var.location
  region_abbr = var.region_abbr
  tags        = var.tags

  # Placement
  resource_group_name = data.terraform_remote_state.platform_connectivity.outputs.resource_group_name

  # Networking
  node_subnet_id = data.terraform_remote_state.platform_connectivity.outputs.spoke_subnet_ids["snet-aks-nodes"]

  apiserver_subnet_id = data.terraform_remote_state.platform_connectivity.outputs.spoke_subnet_ids["snet-apiserver"]

  # Monitoring
  log_analytics_workspace_id = data.terraform_remote_state.platform_management.outputs.log_analytics_workspace_id

  # AKS config
  kubernetes_version = var.kubernetes_version
  system_node_pool   = var.system_node_pool
  user_node_pools    = var.user_node_pools
}

