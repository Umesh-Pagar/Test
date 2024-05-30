data "azurerm_subscription" "primary" {}
data "azurerm_client_config" "current" {}
data "azuread_user" "current_user" {
  object_id = data.azurerm_client_config.current.object_id
}

data "azurerm_resource_group" "rg-default" {
  name = var.resource_group_name
}

# data "azurerm_ssh_public_key" "aks_key" {
#   name                = var.aks_ssh_public_key
#   resource_group_name = var.resource_group_name
# }