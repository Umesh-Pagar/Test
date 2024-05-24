variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which the resources will be created."
}

variable "environment" {
  type        = string
  description = "The environment in which the resources will be created"
}

variable "prefix" {
  type        = string
  description = "The prefix to be used for all resources"
}

variable "tags" {
  type        = map(any)
  description = "A mapping of tags to assign to the resource"
  default     = {}
}

variable "vnet_name" {
  type        = string
  description = "The name of the virtual network"
  default     = null
}

variable "address_space" {
  type        = string
  description = "The address space that is used the virtual network"
}

variable "dns_servers" {
  type        = list(string)
  description = "The DNS servers that will be used by the virtual network"
  default     = []
}

variable "subnets" {
  type = list(object({
    name           = string
    address_prefix = string
  }))
  description = "A list of subnets to create within the virtual network"
}

variable "soft_delete_retention_days" {
  type        = number
  description = "The number of days to retain soft deleted resources"
  default     = 7
}

variable "soft_delete_enabled" {
  type        = bool
  description = "Whether or not to enable soft delete"
  default     = true
}