terraform {
  required_version = ">= 1.5.0"  

  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.57.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  subscription_id = var.subscription_id
}