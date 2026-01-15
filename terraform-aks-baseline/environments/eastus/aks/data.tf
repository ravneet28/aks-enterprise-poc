# ------------------------------------------------------------
# Platform Connectivity (Networking)
# ------------------------------------------------------------

data "terraform_remote_state" "platform_connectivity" {
  backend = "azurerm"

  config = {
    resource_group_name  = var.tfstate_rg
    storage_account_name = var.tfstate_storage
    container_name       = var.tfstate_container
    key                  = "platform-connectivity.tfstate"
  }
}

# ------------------------------------------------------------
# Platform Management (Monitoring)
# ------------------------------------------------------------

data "terraform_remote_state" "platform_management" {
  backend = "azurerm"

  config = {
    resource_group_name  = var.tfstate_rg
    storage_account_name = var.tfstate_storage
    container_name       = var.tfstate_container
    key                  = "platform-management.tfstate"
  }
}
