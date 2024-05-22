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