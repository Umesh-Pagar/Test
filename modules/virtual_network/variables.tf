variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which the virtual network will be created"
}

variable "location" {
  type        = string
  description = "The location/region where the virtual network will be created"
}

variable "tags" {
  type        = map(any)
  description = "A mapping of tags to assign to the resource"
}

variable "vnet_name" {
  type        = string
  description = "The name of the virtual network"
}

variable "address_space" {
  type        = string
  description = "The address space that is used the virtual network"
}

variable "dns_servers" {
  type        = list(string)
  description = "The DNS servers that will be used by the virtual network"
}

variable "subnets" {
  type = list(object({
    name           = string
    address_prefix = string
  }))
  description = "A list of subnets to create within the virtual network"
}