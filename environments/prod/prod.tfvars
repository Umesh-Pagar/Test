resource_group_name = "RG-UmeshPagar"
prefix              = "test"
environment         = "prod"
address_space       = "10.0.0.0/20"
dns_servers         = ["8.8.8.8", "8.8.4.4"]
subnets             = [
  {
    name                 = "subnet1"
    address_prefix     = "10.0.1.0/24"
  },
  {
    name                 = "subnet2"
    address_prefix     = "10.0.2.0/24"
  }
]