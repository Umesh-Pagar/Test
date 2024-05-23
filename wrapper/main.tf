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

resource "null_resource" "acr_soft_delete" {
  triggers = {
    acr_id = azurerm_container_registry.acr.id
  }

  provisioner "local-exec" {
    command = "az acr config soft-delete update -r ${azurerm_container_registry.acr.name} --days 7 --status enabled"
  }

  depends_on = [azurerm_container_registry.acr]
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
}

resource "azurerm_role_assignment" "acr_pull" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}