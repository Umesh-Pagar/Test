module "virtual_network" {
  source              = "../modules/virtual_network"
  resource_group_name = local.resource_group_name
  location            = local.location
  vnet_name           = local.vnet_name
  address_space       = var.address_space
  dns_servers         = var.dns_servers
  subnets             = var.subnets

  tags = local.tags
}

resource "azurerm_user_assigned_identity" "acr_identity" {
  resource_group_name = local.resource_group_name
  location            = local.location
  name                = "acr-identity"
}

resource "azurerm_container_registry" "acr" {
  name                          = "acractions${local.location}"
  resource_group_name           = local.resource_group_name
  location                      = local.location
  sku                           = "Standard"
  public_network_access_enabled = true
  admin_enabled                 = true
  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.acr_identity.id
    ]
  }
  tags = local.tags
}

# resource "azapi_update_resource" "enable_soft_delete" {
#   resource_id = azurerm_container_registry.acr.id
#   type        = "Microsoft.ContainerRegistry/registries@2023-01-01-preview"
#   body = jsonencode({
#     properties = {
#       policies = {
#         softDeletePolicy = {
#           retentionDays = var.soft_delete_retention_days
#           status        = var.soft_delete_enabled ? "Enabled" : "Disabled"
#         }
#       }
#     }
#   })
# }

resource "azurerm_search_service" "srch" {
  name                = "srch-${local.location}"
  resource_group_name = local.resource_group_name
  location            = local.location
  public_network_access_enabled = false
  sku                 = "standard"
}