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

resource "azurerm_search_service" "srch" {
  count                         = 300
  name                          = "srch-${local.location}-${count.index}"
  resource_group_name           = local.resource_group_name
  location                      = local.location
  public_network_access_enabled = false
  sku                           = "standard"
  tags = {
    Application_Name        = "Azure Open AI",
    Application_Description = "Open AI for Project Bolt",
    Brand                   = "Ingenovis Health",
    Created_By              = "umesh.pagar.accion@ingenovishealth.com",
    Creation_Date           = "06/26/2024",
    Creation_Method         = "IaC-Terraform",
    Department              = "Tech Ops",
    Environment             = "Development",
    Requested_By            = "John Wittenbrook",
    Approved_By             = "Brian Manning",
    Resource_Support        = "Azure Team",
    App_Support             = "Azure Team"
  }
}