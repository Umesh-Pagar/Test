module "hub_network" {
  source = "github.com/ingenovishealth/iac-ing-core//modules/virtual_network?ref=feature/BOLT-52-core-modules"
  name                = local.hub_vnet_name
  resource_group_name = local.resource_group_name
  location            = local.location
  vnet_address_space  = var.hub_address_space
  subnets             = local.hub_subnets

  tags = local.tags
}

module "storage" {
  source = "github.com/ingenovishealth/iac-ing-core//modules/storage_account?ref=feature/BOLT-52-core-modules"

  resource_group_name                  = local.resource_group_name
  location                             = local.location
  storage_account_name                 = local.storage_account_name
  account_kind                         = var.storage_account_kind
  access_tier                          = var.storage_account_tier
  enable_https_traffic_only            = var.storage_account_enable_https_traffic_only
  min_tls_version                      = var.storage_account_min_tls_version
  enable_versioning                    = var.storage_account_enable_versioning
  last_access_time_enabled             = var.last_access_time_enabled
  enable_advanced_threat_protection    = var.storage_account_advanced_threat_protection_enabled
  containers_list                      = var.storage_account_containers
  file_shares                          = var.storage_account_file_shares
  tables                               = var.storage_account_tables
  queues                               = var.storage_account_queues
  network_rules                        = var.storage_account_network_rules
  private_endpoint_enabled             = var.storage_account_private_endpoint_enabled
  private_endpoint_name                = local.storage_account_private_endpoint_name
  private_dns_zone_name                = var.storage_account_private_dns_zone_name
  virtual_network_id                   = module.hub_network.virtual_network_id
  subnet_id                            = [for id in module.hub_network.subnet_ids : id if strcontains(id, "pe")][0]
  change_feed_enabled                  = var.change_feed_enabled
  container_soft_delete_retention_days = var.container_soft_delete_retention_days
  blob_soft_delete_retention_days      = var.blob_soft_delete_retention_days
  managed_identity_type                = var.storage_account_managed_identity_type
  lifecycles                           = var.storage_account_lifecycles
  tags                                 = local.tags
}

module "container_registry" {
  source                        = "github.com/ingenovishealth/iac-ing-core//modules/container_registry?ref=feature/BOLT-52-core-modules"
  name                          = local.container_registry_name
  resource_group_name           = local.resource_group_name
  location                      = local.location
  sku                           = var.acr_sku
  admin_enabled                 = var.acr_admin_enabled
  public_network_access_enabled = var.acr_public_network_access_enabled
  soft_delete_enabled           = var.acr_soft_delete_enabled
  soft_delete_retention_days    = var.acr_soft_delete_retention_days
  georeplication_locations      = var.acr_georeplication_locations
  log_analytics_workspace_id    = module.azure_monitor.id
  private_endpoint_enabled      = var.acr_private_endpoint_enabled
  private_endpoint_name         = local.acr_private_endpoint_name
  private_dns_zone_name         = var.acr_private_dns_zone_name
  virtual_network_id            = module.hub_network.virtual_network_id
  subnet_id                     = [for id in module.hub_network.subnet_ids : id if strcontains(id, "pe")][0]
  tags                          = local.tags
}

module "key_vault" {
  source                          = "github.com/ingenovishealth/iac-ing-core//modules/key_vault?ref=feature/BOLT-52-core-modules"
  key_vault_name                  = local.key_vault_name
  resource_group_name             = local.resource_group_name
  location                        = local.location
  key_vault_sku_pricing_tier      = lower(var.key_vault_sku_name)
  enabled_for_deployment          = var.key_vault_enabled_for_deployment
  enabled_for_disk_encryption     = var.key_vault_enabled_for_disk_encryption
  enabled_for_template_deployment = var.key_vault_enabled_for_template_deployment
  enable_rbac_authorization       = var.key_vault_enable_rbac_authorization
  enable_soft_delete              = var.key_vault_enabled_soft_delete
  purge_protection_enabled        = var.key_vault_purge_protection_enabled
  soft_delete_retention_days      = var.key_vault_soft_delete_retention_days
  private_endpoint_enabled        = var.key_vault_private_endpoint_enabled
  private_endpoint_name           = local.key_vault_private_endpoint_name
  private_dns_zone_name           = var.key_vault_private_dns_zone_name
  virtual_network_id              = module.hub_network.virtual_network_id
  subnet_id                       = [for id in module.hub_network.subnet_ids : id if strcontains(id, "pe")][0]
  access_policies                 = var.key_vault_access_policies
  secrets                         = var.key_vault_secrets
  log_analytics_workspace_id      = module.azure_monitor.id
  tags                            = var.tags
}

module "aks_cluster" {
  source                                   = "github.com/ingenovishealth/iac-ing-core//modules/aks?ref=feature/BOLT-52-core-modules"
  name                                     = local.aks_cluster_name
  location                                 = local.location
  resource_group_name                      = local.resource_group_name
  resource_group_id                        = local.resource_group_id
  kubernetes_version                       = var.kubernetes_version
  dns_prefix                               = lower(local.aks_cluster_name)
  private_cluster_enabled                  = var.private_cluster_enabled
  automatic_channel_upgrade                = var.automatic_channel_upgrade
  sku_tier                                 = var.sku_tier
  container_registry_id                    = module.container_registry.id
  default_node_pool_name                   = var.default_node_pool_name
  default_node_pool_vm_size                = var.default_node_pool_vm_size
  vnet_subnet_id                           = [for id in module.hub_network.subnet_ids : id if strcontains(id, "aks")][0]
  default_node_pool_availability_zones     = var.default_node_pool_availability_zones
  default_node_pool_node_labels            = var.default_node_pool_node_labels
  default_node_pool_enable_auto_scaling    = var.default_node_pool_enable_auto_scaling
  default_node_pool_enable_host_encryption = var.default_node_pool_enable_host_encryption
  default_node_pool_enable_node_public_ip  = var.default_node_pool_enable_node_public_ip
  default_node_pool_max_pods               = var.default_node_pool_max_pods
  default_node_pool_max_count              = var.default_node_pool_max_count
  default_node_pool_min_count              = var.default_node_pool_min_count
  default_node_pool_node_count             = var.default_node_pool_node_count
  default_node_pool_os_disk_type           = var.default_node_pool_os_disk_type
  network_dns_service_ip                   = var.network_dns_service_ip
  network_plugin                           = var.network_plugin
  network_policy                           = var.network_policy
  load_balancer_sku                        = var.load_balancer_sku
  outbound_type                            = var.outbound_type
  network_service_cidr                     = var.network_service_cidr
  log_analytics_workspace_id               = module.azure_monitor.id
  role_based_access_control_enabled        = var.role_based_access_control_enabled
  tenant_id                                = data.azurerm_client_config.current.tenant_id
  admin_group_object_ids                   = var.admin_group_object_ids
  admin_username                           = var.admin_username
  ssh_public_key                           = data.azurerm_ssh_public_key.aks_key.public_key
  keda_enabled                             = var.keda_enabled
  vertical_pod_autoscaler_enabled          = var.vertical_pod_autoscaler_enabled
  workload_identity_enabled                = var.workload_identity_enabled
  oidc_issuer_enabled                      = var.oidc_issuer_enabled
  key_vault_secrets_provider               = var.key_vault_secrets_provider
  key_vault_id                             = module.key_vault.id
  open_service_mesh_enabled                = var.open_service_mesh_enabled
  image_cleaner_enabled                    = var.image_cleaner_enabled
  azure_policy_enabled                     = var.azure_policy_enabled
  http_application_routing_enabled         = var.http_application_routing_enabled

  tags = merge(local.tags, { Application_Type = "AKS", Application_Code = "Bolt", Infra_As_Code = "Terraform" })

  depends_on = [
    module.hub_network
  ]
}

module "azure_monitor" {
  source                       = "github.com/ingenovishealth/iac-ing-core//modules/azure_monitor?ref=feature/BOLT-52-core-modules"
  log_analytics_workspace_name = local.log_analytics_workspace_name
  resource_group_name          = local.resource_group_name
  location                     = local.location
  solutions                    = var.solutions
  application_insights         = var.application_insights

  tags = local.tags
}

