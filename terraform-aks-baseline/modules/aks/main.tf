# ------------------------------------------------------------
# User-assigned managed identity for AKS
# ------------------------------------------------------------

resource "azurerm_user_assigned_identity" "aks" {
  name                = "${local.aks_name}-uami"
  location            = local.location
  resource_group_name = var.resource_group_name
  tags                = local.tags
}

# ------------------------------------------------------------
# AKS Cluster (Baseline-compliant)
# ------------------------------------------------------------

resource "azurerm_kubernetes_cluster" "this" {
  name                = local.aks_name
  location            = local.location
  resource_group_name = var.resource_group_name
  dns_prefix          = local.aks_name

  kubernetes_version = var.kubernetes_version

  # ----------------------------------------------------------
  # Identity (MANDATORY: user-assigned)
  # ----------------------------------------------------------
  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks.id]
  }

  # ----------------------------------------------------------
  # Private cluster configuration (MANDATORY)
  # ----------------------------------------------------------
  private_cluster_enabled = true

  api_server_access_profile {
    subnet_id = var.apiserver_subnet_id
  }

  # ----------------------------------------------------------
  # Azure AD & RBAC (MANDATORY)
  # ----------------------------------------------------------
  azure_active_directory_role_based_access_control {
    tenant_id          = var.tenant_id
    azure_rbac_enabled = true
  }

  local_account_disabled = true

  # ----------------------------------------------------------
  # Default (system) node pool
  # ----------------------------------------------------------
  default_node_pool {
    name                 = local.system_node_pool_name
    vm_size              = var.system_node_pool.vm_size
    node_count           = var.system_node_pool.node_count
    vnet_subnet_id       = var.node_subnet_id
    orchestrator_version = var.kubernetes_version
    type                 = "VirtualMachineScaleSets"
    node_labels = {
      "nodepool-type" = "system"
    }
  }

  # ----------------------------------------------------------
  # Networking (Baseline defaults)
  # ----------------------------------------------------------
  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
    outbound_type  = "loadBalancer"
  }

  # ----------------------------------------------------------
  # Monitoring (Azure Monitor / Container Insights)
  # ----------------------------------------------------------
  oms_agent {
    log_analytics_workspace_id = var.log_analytics_workspace_id
  }

  tags = local.tags
}
