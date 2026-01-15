# ------------------------------------------------------------
# Resource Group
# ------------------------------------------------------------

resource "azurerm_resource_group" "this" {
  name     = local.rg_name
  location = local.location
  tags     = local.tags
}

# ------------------------------------------------------------
# Log Analytics Workspace (Baseline mandatory)
# ------------------------------------------------------------

resource "azurerm_log_analytics_workspace" "this" {
  name                = local.log_analytics_name
  location            = local.location
  resource_group_name = azurerm_resource_group.this.name

  sku               = "PerGB2018"
  retention_in_days = 30

  tags = local.tags
}
