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
  subscription_id = "c50c6ff1-109a-44e6-bd8b-98f83005c440"
  tenant_id = "bdb54b97-e2d3-4bc3-b33a-dc2fbd397730"
}
