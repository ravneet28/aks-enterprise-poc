# ------------------------------------------------------------
# Resource Group
# ------------------------------------------------------------

output "resource_group_name" {
  description = "Resource group containing platform connectivity resources"
  value       = azurerm_resource_group.this.name
}

# ------------------------------------------------------------
# Virtual Networks
# ------------------------------------------------------------

output "hub_vnet_id" {
  description = "ID of the hub virtual network"
  value       = azurerm_virtual_network.hub.id
}

output "spoke_vnet_id" {
  description = "ID of the AKS spoke virtual network"
  value       = azurerm_virtual_network.spoke.id
}

# ------------------------------------------------------------
# Hub Subnets
# ------------------------------------------------------------

output "hub_subnet_ids" {
  description = "Map of hub subnet names to subnet IDs"
  value = {
    for subnet_name, subnet in azurerm_subnet.hub :
    subnet_name => subnet.id
  }
}

# ------------------------------------------------------------
# Spoke (AKS) Subnets
# ------------------------------------------------------------

output "spoke_subnet_ids" {
  description = "Map of spoke subnet names to subnet IDs"
  value = {
    for subnet_name, subnet in azurerm_subnet.spoke :
    subnet_name => subnet.id
  }
}
