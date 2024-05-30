resource_group_name = "RG-UmeshPagar"
environment         = "gbl"
brand               = "ing"
application         = "blt"

tags = {
  Application_Name = "Bolt",
  Application_Type = "AI",
  Brand            = "Ingenovis Health",
  Owner            = "Ingenovis Health",
  Created_By       = "Terraform",
  Creation_Method  = "Terraform",
  Department       = "Tech Ops",
  Environment      = "gbl",
  Requested_By     = "Bolt",
  Support_Team     = "Azure Team"
}

hub_address_space = ["10.153.0.0/16"]
hub_subnets = {
  AzureFirewallSubnet = {
    subnet_address_prefix = ["10.153.4.0/23"]
  }

  GatewaySubnet = {
    subnet_address_prefix = ["10.153.6.0/23"]
  }
  pe = {
    subnet_address_prefix                         = ["10.153.8.0/28"]
    private_endpoint_network_policies_enabled     = false
    private_link_service_network_policies_enabled = false
  }
  aks = {
    subnet_address_prefix = ["10.153.0.0/22"]
  }
}

default_node_pool_vm_size               = "Standard_DS3_v2"
default_node_pool_max_pods              = 250
default_node_pool_max_count             = 3
default_node_pool_min_count             = 2
default_node_pool_node_count            = 2