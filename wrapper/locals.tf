locals {
  resource_group_name = data.azurerm_resource_group.rg-default.name
  location            = data.azurerm_resource_group.rg-default.location

  vnet_name = var.vnet_name == null ? "vn-${var.prefix}-${var.environment}" : var.vnet_name

  tags = {
    environment = var.environment
    created_by  = "Terraform"
  }
}