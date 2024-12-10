output "search_service_id" {
  value = azurerm_search_service.srch.id
}

output "search_service_name" {
  value = azurerm_search_service.srch.name
}
 
output "rg_name" {
  value = data.azurerm_resource_group.rg-default.name
}