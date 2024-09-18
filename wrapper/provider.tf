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
  skip_provider_registration = true
  features {}
}

provider "azapi" {
  skip_provider_registration = true
}
