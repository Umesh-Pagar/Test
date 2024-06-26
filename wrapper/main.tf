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

resource "azapi_update_resource" "enable_soft_delete" {
  resource_id = azurerm_container_registry.acr.id
  type        = "Microsoft.ContainerRegistry/registries@2023-01-01-preview"
  body = jsonencode({
    properties = {
      policies = {
        softDeletePolicy = {
          retentionDays = var.soft_delete_retention_days
          status        = var.soft_delete_enabled ? "Enabled" : "Disabled"
        }
      }
    }
  })
}

resource "azurerm_user_assigned_identity" "aks_identity" {
  resource_group_name = local.resource_group_name
  location            = local.location
  name                = "aks-identity"
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                    = "aks-${local.location}"
  location                = local.location
  resource_group_name     = local.resource_group_name
  dns_prefix              = "aks-${local.location}"
  private_cluster_enabled = false

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.aks_identity.id
    ]
  }

  tags = local.tags
}

resource "azurerm_kubernetes_cluster_extension" "extensions" {
  name = "flux"
  cluster_id = azurerm_kubernetes_cluster.aks.id
  extension_type = "microsoft.flux"

  configuration_settings = {
    "helm-controller.enabled" : "true"
    "source-controller.enabled" : "true"
    "kustomize-controller.enabled" : "true"
    "notification-controller.enabled" : "true"
    "image-automation-controller.enabled" : "true"
    "image-reflector-controller.enabled" : "true"
  }
}


resource "azurerm_role_assignment" "acr_pull" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}
