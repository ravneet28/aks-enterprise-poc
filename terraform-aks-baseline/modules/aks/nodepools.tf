resource "azurerm_kubernetes_cluster_node_pool" "user" {
  for_each = var.user_node_pools

  kubernetes_cluster_id = azurerm_kubernetes_cluster.this.id
  name                  = each.key
  vm_size               = each.value.vm_size
  node_count            = each.value.node_count

  mode                 = "User"
  orchestrator_version = var.kubernetes_version
  vnet_subnet_id       = var.node_subnet_id
  os_type              = "Linux"

  node_labels = {
    "nodepool-type" = "user"
    "pool-name"     = each.key
  }

  tags = local.tags
}
