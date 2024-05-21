resource_group_name = "RG-UmeshPagar"
prefix              = "test"
environment         = "dev"
address_space       = "10.1.0.0/16"
dns_servers         = ["8.8.8.8", "8.8.4.4"]
subnets             = [
  {
    name                 = "subnet1"
    address_prefix     = "10.1.1.0/24"
  },
  {
    name                 = "subnet2"
    address_prefix     = "10.1.2.0/24"
  }
]