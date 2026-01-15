terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate-sbx-eus"
    storage_account_name = "sttfstatesbxeus01"
    container_name       = "tfstate"
    key                  = "platform-management.tfstate"
  }
}
