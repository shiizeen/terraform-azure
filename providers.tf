terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>4.23"
    }
  }
}

provider "azurerm" {
  features{}
  subscription_id = ""
  tenant_id = ""
}
