resource "azurerm_resource_group" "this" {
  name     = local.rg_name
  location = local.location
  tags     = local.tags
}

resource "azurerm_virtual_network" "hub" {
  name                = local.hub_vnet_name
  location            = local.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = var.hub_vnet_address_space
  tags                = local.tags
}

resource "azurerm_subnet" "hub" {
  for_each = local.hub_subnets

  name                 = each.key
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = each.value.address_prefixes
}

resource "azurerm_virtual_network" "spoke" {
  name                = local.spoke_vnet_name
  location            = local.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = var.spoke_vnet_address_space
  tags                = local.tags
}

resource "azurerm_subnet" "spoke" {
  for_each = locals.spoke_subnets

  name                 = each.key
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = each.value.address_prefixes

  dynamic "delegation" {
    for_each = each.value.delegation != null ? [each.value.delegation] : []

    content {
      name = "aks-${each.key}-delegation"

      service_delegation {
        name = delegation.value
        actions = [
          "Microsoft.Network/virtualNetworks/subnets/action"
        ]
      }
    }
  }
}

resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                      = "${local.hub_vnet_name}-to-${local.spoke_vnet_name}"
  resource_group_name       = azurerm_resource_group.this.name
  virtual_network_name      = azurerm_virtual_network.hub.name
  remote_virtual_network_id = azurerm_virtual_network.spoke.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
}

resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                      = "${local.spoke_vnet_name}-to-${local.hub_vnet_name}"
  resource_group_name       = azurerm_resource_group.this.name
  virtual_network_name      = azurerm_virtual_network.spoke.name
  remote_virtual_network_id = azurerm_virtual_network.hub.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  use_remote_gateways          = true
}
