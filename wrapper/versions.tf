terraform {
  required_providers {
    azurerm = {
      version = "3.98.0"
    }

    azuread = {
      version = "2.50.0"
    }

    azapi = {
      source = "Azure/azapi"
      # version = "1.13.1"
    }
  }
}
