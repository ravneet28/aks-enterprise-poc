# ------------------------------------------------------------
# AKS Cluster
# ------------------------------------------------------------

output "aks_name" {
  description = "Name of the AKS cluster"
  value       = azurerm_kubernetes_cluster.this.name
}

output "aks_id" {
  description = "Resource ID of the AKS cluster"
  value       = azurerm_kubernetes_cluster.this.id
}

# ------------------------------------------------------------
# Node resource group
# ------------------------------------------------------------

output "node_resource_group" {
  description = "Resource group containing AKS node pool resources"
  value       = azurerm_kubernetes_cluster.this.node_resource_group
}

# ------------------------------------------------------------
# Managed identities
# ------------------------------------------------------------

output "kubelet_identity" {
  description = "Kubelet managed identity details"
  value = {
    client_id = azurerm_kubernetes_cluster.this.kubelet_identity[0].client_id
    object_id = azurerm_kubernetes_cluster.this.kubelet_identity[0].object_id
  }
}

# ------------------------------------------------------------
# OIDC (for workload identity - future use)
# ------------------------------------------------------------

output "oidc_issuer_url" {
  description = "OIDC issuer URL for AKS workload identity"
  value       = azurerm_kubernetes_cluster.this.oidc_issuer_url
}
