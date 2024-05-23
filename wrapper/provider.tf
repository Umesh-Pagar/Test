terraform {
  required_providers {
    azurerm = {
      version = "3.98.0"
    }

    azapi = {
      source = "Azure/azapi"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azapi" {
  
}
