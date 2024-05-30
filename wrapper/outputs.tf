output "resource_group_name" {
  description = "The name of the resource group"
  value       = data.azurerm_resource_group.rg-default.name
}

output "resource_group_id" {
  description = "The id of the resource group"
  value       = data.azurerm_resource_group.rg-default.id
}

output "virtual_network_name" {
  description = "The name of the virtual network"
  value       = module.hub_network.virtual_network_name
}

output "virtual_network_id" {
  description = "The id of the virtual network"
  value       = module.hub_network.virtual_network_id
}

output "virtual_network_address_space" {
  description = "List of address spaces that are used the virtual network."
  value       = module.hub_network.virtual_network_address_space
}

output "subnet_ids" {
  description = "List of IDs of subnets"
  value       = module.hub_network.subnet_ids
}

output "container_registry_id" {
  description = "Container Registry ID"
  value       = module.container_registry.id
}

output "container_registry_name" {
  description = "Container Registry Name"
  value       = module.container_registry.name
}

output "key_vault_id" {
  description = "Key Vault ID"
  value       = module.key_vault.id
}

output "log_analytics_workspace_id" {
  description = "Log Analytics Workspace ID"
  value       = module.azure_monitor.id
}