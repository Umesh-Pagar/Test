locals {

  location            = var.location == null ? data.azurerm_resource_group.rg-default.location : var.location
  resource_group_name = data.azurerm_resource_group.rg-default.name == null ? "rg-${var.brand}-${var.application}-${var.environment}-${local.location}" : data.azurerm_resource_group.rg-default.name
  resource_group_id   = data.azurerm_resource_group.rg-default.id

  hub_vnet_name = var.hub_vnet_name == null ? "vnet-${var.brand}-${var.application}-${var.environment}-${local.location}" : var.hub_vnet_name
  hub_subnets = {
    for subnet_name, v in var.hub_subnets : subnet_name => merge(v, {
      subnet_name = subnet_name == "GatewaySubnet" || subnet_name == "AzureFirewallSubnet" ? subnet_name : "snet-${var.brand}-${var.application}-${var.environment}-${subnet_name}-${local.location}",
      nsg_name    = subnet_name == "GatewaySubnet" || subnet_name == "AzureFirewallSubnet" ? null : "nsg-${var.brand}-${var.application}-${var.environment}-${subnet_name}-${local.location}"
    })
  }

  aks_cluster_name                              = var.aks_cluster_name == null ? "aks-${var.brand}-${var.application}-${var.environment}-${local.location}" : var.aks_cluster_name
  storage_account_name                          = var.storage_account_name == null ? "stg${var.brand}${var.application}${var.environment}${local.location}01" : var.storage_account_name
  key_vault_name                                = var.key_vault_name == null ? "kv-${var.brand}-${var.application}-${var.environment}-${local.location}-02" : var.key_vault_name
  container_registry_name                       = var.acr_name == null ? "cr${var.brand}${var.application}${var.environment}${local.location}" : var.acr_name
  acr_private_endpoint_name                     = var.acr_private_endpoint_name == null ? "pec-${var.brand}-${var.application}-${var.environment}-cr-${local.location}" : var.acr_private_endpoint_name
  key_vault_private_endpoint_name               = var.key_vault_private_endpoint_name == null ? "pec-${var.brand}-${var.application}-${var.environment}-kv-${local.location}" : var.key_vault_private_endpoint_name
  storage_account_private_endpoint_name         = var.storage_account_private_endpoint_name == null ? "pec-${var.brand}-${var.application}-${var.environment}-stg-${local.location}" : var.storage_account_private_endpoint_name
  log_analytics_workspace_private_endpoint_name = var.log_analytics_workspace_private_endpoint_name == null ? "pec-${var.brand}-${var.application}-${var.environment}-law-${local.location}" : var.log_analytics_workspace_private_endpoint_name
  firewall_name                                 = var.firewall_name == null ? "fw-${var.brand}-${var.application}-${var.environment}-${local.location}" : var.firewall_name

  log_analytics_workspace_name = var.log_analytics_workspace_name == null ? "law-${var.brand}-${var.application}-${var.environment}-${local.location}" : var.log_analytics_workspace_name

  tags = merge(
    var.tags,
    {
      Created_By    = data.azuread_user.current_user.user_principal_name
      Creation_Date = formatdate("MM/DD/YYYY", timestamp())
      Environment   = var.environment
    }
  )
}