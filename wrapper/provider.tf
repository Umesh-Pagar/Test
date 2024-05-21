terraform {
  required_providers {
    azurerm = {
      version = "3.98.0"
    }
  }
}

provider "azurerm" {
  features {}

  client_id       = "862bd8cf-4634-4cef-8828-19b62119bcc1"
  client_secret   = "pQ.8Q~J3yvDzaDlXSb7CiF4wfJYAe4aMbN__NcAW"
  tenant_id       = "fd41ee0d-0d97-4102-9a50-c7c3c5470454"
  subscription_id = "df7ed44c-e98a-43c4-af18-241e33567262"
}