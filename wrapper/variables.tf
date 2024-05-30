variable "resource_group_name" {
  type        = string
  description = "(Required) Specifies the resource group where the resource exists. Changing this forces a new resource to be created"
}

variable "location" {
  type        = string
  description = "(Required) Specifies the location of the resource group where the resource exists. Changing this forces a new resource to be created"
  default     = null
}

variable "brand" {
  type        = string
  description = "(Optional) The brand of the application."
  default     = "ing"
}

variable "application" {
  type        = string
  description = "(Optional) The name of the application."
  default     = "blt"
}

variable "tags" {
  type = object({
    Application_Name = optional(string)
    Application_Type = optional(string)
    Brand            = optional(string)
    Owner            = optional(string)
    Created_By       = optional(string)
    Creation_Date    = optional(string)
    Creation_Method  = optional(string)
    Department       = optional(string)
    Environment      = optional(string)
    Requested_By     = optional(string)
    Support_Team     = optional(string)
  })
  description = "(Optional) A mapping of tags to assign to the resource."
  default = {
    Application_Name = "bolt"
    Application_Type = "AI"
    Brand            = "Ingenovis Health"
    Owner            = "Ingenovis Health"
    Created_By       = "Terraform"
    Creation_Date    = "MM/DD/YYYY"
    Creation_Method  = "Terraform"
    Department       = "Tech Ops"
    Environment      = "dev"
    Requested_By     = "Bolt"
    Support_Team     = "Azure Team"
  }
}

variable "environment" {
  type        = string
  description = "(Optional) The environment in which the application is deployed."
  default     = "gbl"

  validation {
    condition     = var.environment == "dev" || var.environment == "qa" || var.environment == "prod" || var.environment == "gbl"
    error_message = "Only dev, qa, prod and gbl are allowed"
  }
}

variable "hub_vnet_name" {
  description = "Specifies the name of the hub virtual virtual network"
  default     = null
  type        = string
}

variable "hub_address_space" {
  description = "Specifies the address space of the hub virtual virtual network"
  default     = ["10.1.0.0/16"]
  type        = list(string)
}

variable "hub_subnets" {
  description = "Specifies the subnets of the hub virtual virtual network"
  default     = {}
}

variable "create_firewall" {
  type        = bool
  description = "Specifies whether to create a firewall"
  default     = false
}

variable "firewall_name" {
  description = "Specifies the name of the Azure Firewall"
  default     = null
  type        = string
}

variable "firewall_sku_name" {
  description = "(Required) SKU name of the Firewall. Possible values are AZFW_Hub and AZFW_VNet. Changing this forces a new resource to be created."
  default     = "AZFW_VNet"
  type        = string

  validation {
    condition     = contains(["AZFW_Hub", "AZFW_VNet"], var.firewall_sku_name)
    error_message = "The value of the sku name property of the firewall is invalid."
  }
}

variable "firewall_sku_tier" {
  description = "(Required) SKU tier of the Firewall. Possible values are Premium, Standard, and Basic."
  default     = "Premium"
  type        = string

  validation {
    condition     = contains(["Premium", "Standard", "Basic"], var.firewall_sku_tier)
    error_message = "The value of the sku tier property of the firewall is invalid."
  }
}

variable "firewall_threat_intel_mode" {
  description = "(Optional) The operation mode for threat intelligence-based filtering. Possible values are: Off, Alert, Deny. Defaults to Alert."
  default     = "Alert"
  type        = string

  validation {
    condition     = contains(["Off", "Alert", "Deny"], var.firewall_threat_intel_mode)
    error_message = "The threat intel mode is invalid."
  }
}

variable "firewall_zones" {
  description = "Specifies the availability zones of the Azure Firewall"
  default     = ["1", "2", "3"]
  type        = list(string)
}

variable "storage_account_name" {
  type        = string
  description = "(Required) Specifies the name of the storage account. Only lowercase Alphanumeric characters allowed. Changing this forces a new resource to be created."
  default     = null
}

variable "storage_account_advanced_threat_protection_enabled" {
  description = "(Optional) Specifies whether advanced threat protection is enabled for the storage account"
  type        = bool
  default     = true
}

variable "storage_account_containers" {
  description = "(Optional) A list of containers to create in the storage account"
  type = list(object({
    name        = string
    access_type = string
  }))
  default = []
}

variable "storage_account_file_shares" {
  description = "List of containers to create and their access levels."
  type        = list(object({ name = string, quota = number }))
  default     = []
}

variable "storage_account_queues" {
  description = "List of storages queues"
  type        = list(string)
  default     = []
}

variable "storage_account_tables" {
  description = "List of storage tables."
  type        = list(string)
  default     = []
}
variable "storage_account_lifecycles" {
  description = "Configure Azure Storage firewalls and virtual networks"
  type        = list(object({ prefix_match = set(string), tier_to_cool_after_days = number, tier_to_archive_after_days = number, delete_after_days = number, snapshot_delete_after_days = number }))
  default     = []
}

variable "storage_account_managed_identity_type" {
  description = "The type of Managed Identity which should be assigned to the Linux Virtual Machine. Possible values are `SystemAssigned`, `UserAssigned` and `SystemAssigned, UserAssigned`"
  default     = null
  type        = string
}

variable "storage_account_managed_identity_ids" {
  description = "A list of User Managed Identity ID's which should be assigned to the storage account."
  default     = null
  type        = list(string)
}

variable "storage_account_network_rules" {
  description = "Network rules restricing access to the storage account."
  type        = object({ bypass = list(string), ip_rules = list(string), subnet_ids = list(string) })
  default     = null
}

variable "storage_account_private_endpoint_enabled" {
  type        = bool
  description = "Manages a Private Endpoint to the Storage Account"
  default     = true
}

variable "storage_account_private_endpoint_name" {
  type        = string
  description = "The name of the Private Endpoint to create for the storage account."
  default     = null
}

variable "storage_account_private_dns_zone_name" {
  type        = string
  description = "The name of the Private DNS Zone for storage account. Must be a valid domain name. Changing this forces a new resource to be created."
  default     = "privatelink.blob.core.windows.net"
}





variable "storage_account_enable_https_traffic_only" {
  description = "Allows https traffic only to storage service. Default to `true`"
  default     = true
  type        = bool
}

variable "storage_account_min_tls_version" {
  description = "The minimum supported TLS version for the storage account"
  default     = "TLS1_2"
  type        = string
}

variable "blob_soft_delete_retention_days" {
  description = "Specifies the number of days that the blob should be retained, between `1` and `365` days. Defaults to `7`"
  default     = 7
  type        = number
}

variable "container_soft_delete_retention_days" {
  description = "Specifies the number of days that the blob should be retained, between `1` and `365` days. Defaults to `7`"
  default     = 7
  type        = number
}

variable "storage_account_enable_versioning" {
  description = "Is versioning enabled? Default to `false`"
  default     = false
  type        = bool
}

variable "last_access_time_enabled" {
  description = "Is the last access time based tracking enabled? Default to `false`"
  default     = false
  type        = bool
}

variable "change_feed_enabled" {
  description = "Is the blob service properties for change feed events enabled?"
  default     = false
  type        = bool
}

variable "storage_account_kind" {
  description = "(Optional) Specifies the account kind of the storage account"
  default     = "StorageV2"
  type        = string

  validation {
    condition     = contains(["Storage", "StorageV2"], var.storage_account_kind)
    error_message = "The account kind of the storage account is invalid."
  }
}

variable "storage_account_tier" {
  description = "(Optional) Specifies the account tier of the storage account"
  default     = "premium"
  type        = string

  validation {
    condition     = contains(["standard", "premium"], var.storage_account_tier)
    error_message = "The account tier of the storage account is invalid."
  }
}

variable "acr_name" {
  description = "Specifies the name of the container registry"
  type        = string
  default     = null
}

variable "acr_private_endpoint_name" {
  type        = string
  description = "The name of the private endpoint for the Azure Container Registry"
  default     = null
}

variable "acr_pdns_vnet_link_name" {
  type        = string
  description = "The name of the virtual network link for the Azure Container Registry"
  default     = null
}

variable "acr_sku" {
  description = "Specifies the name of the container registry"
  type        = string
  default     = "Premium"

  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.acr_sku)
    error_message = "The container registry sku is invalid."
  }
}

variable "acr_admin_enabled" {
  description = "Specifies whether admin is enabled for the container registry"
  type        = bool
  default     = true
}

variable "acr_public_network_access_enabled" {
  description = "Specifies whether public network access is enabled for the container registry"
  type        = bool
  default     = false
}

variable "acr_private_endpoint_enabled" {
  type        = bool
  description = "Specifies whether to enable private endpoint connection to the container registry"
  default     = true
}

variable "acr_soft_delete_enabled" {
  description = "Specifies whether soft delete is enabled for the container registry"
  type        = bool
  default     = true
}

variable "acr_soft_delete_retention_days" {
  description = "Specifies the number of days to retain soft deleted resources"
  type        = number
  default     = 7
}

variable "acr_private_dns_zone_name" {
  type        = string
  description = "(Required) The name of the Private DNS Zone for container registry. Must be a valid domain name. Changing this forces a new resource to be created."
  default     = "privatelink.azurecr.io"
}

variable "acr_existing_private_dns_zone_name" {
  type        = string
  description = "(Optional) The name of an existing Private DNS Zone to link to the Virtual Network. Changing this forces a new resource to be created."
  default     = ""
}

variable "acr_georeplication_locations" {
  description = "(Optional) A list of Azure locations where the container registry should be geo-replicated."
  type        = list(string)
  default     = []
}

variable "key_vault_name" {
  description = "Specifies the name of the key vault."
  type        = string
  default     = null
}

variable "key_vault_private_endpoint_name" {
  type        = string
  description = "The name of the private endpoint for the Azure Key Vault"
  default     = null
}

variable "key_vault_private_dns_zone_name" {
  type        = string
  description = "(Required) The name of the Private DNS Zone for key vault. Must be a valid domain name. Changing this forces a new resource to be created."
  default     = "privatelink.vaultcore.azure.net"
}

variable "key_vault_existing_private_dns_zone_name" {
  type        = string
  description = "(Optional) The name of an existing Private DNS Zone to link to the Virtual Network. Changing this forces a new resource to be created."
  default     = ""
}

variable "key_vault_existing_private_dns_zone_id" {
  type        = string
  description = "(Optional) The ID of an existing Private DNS Zone."
  default     = null
}

variable "key_vault_pdz_vnet_link_name" {
  type        = string
  description = "The name of the virtual network link for the Azure Key Vault"
  default     = null
}

variable "key_vault_sku_name" {
  description = "(Required) The Name of the SKU used for this Key Vault. Possible values are standard and premium."
  type        = string
  default     = "Premium"

  validation {
    condition     = contains(["standard", "premium"], var.key_vault_sku_name)
    error_message = "The sku name of the key vault is invalid."
  }
}

variable "key_vault_access_policies" {
  type        = list(any)
  description = "List of access policies for the Key Vault."
  default     = []
}

variable "key_vault_secrets" {
  type        = map(string)
  description = "A map of secrets for the Key Vault."
  default     = {}
}

variable "key_vault_enabled_for_deployment" {
  description = "(Optional) Boolean flag to specify whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the key vault. Defaults to true."
  type        = bool
  default     = true
}

variable "key_vault_enabled_for_disk_encryption" {
  description = " (Optional) Boolean flag to specify whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys. Defaults to true."
  type        = bool
  default     = true
}

variable "key_vault_enabled_for_template_deployment" {
  description = "(Optional) Boolean flag to specify whether Azure Resource Manager is permitted to retrieve secrets from the key vault. Defaults to true."
  type        = bool
  default     = true
}

variable "key_vault_enable_rbac_authorization" {
  description = "(Optional) Boolean flag to specify whether Azure Key Vault uses Role Based Access Control (RBAC) for authorization of data actions. Defaults to true."
  type        = bool
  default     = true
}

variable "key_vault_enabled_soft_delete" {
  type        = bool
  description = "(Optional)Specifies whether soft delete is enabled for this Key Vault. Possible values are 'true' or 'false'."
  default     = true
}

variable "key_vault_purge_protection_enabled" {
  description = "(Optional) Is Purge Protection enabled for this Key Vault? Defaults to true."
  type        = bool
  default     = true
}

variable "key_vault_private_endpoint_enabled" {
  type        = bool
  description = "Specifies whether to enable private endpoint connection to the key vault"
  default     = true
}

variable "key_vault_soft_delete_retention_days" {
  description = "(Optional) The number of days that items should be retained for once soft-deleted. This value can be between 7 and 90 (the default) days."
  type        = number
  default     = 30
}

variable "key_vault_bypass" {
  description = "(Required) Specifies which traffic can bypass the network rules. Possible values are AzureServices and None."
  type        = string
  default     = "AzureServices"

  validation {
    condition     = contains(["AzureServices", "None"], var.key_vault_bypass)
    error_message = "The valut of the bypass property of the key vault is invalid."
  }
}

variable "key_vault_default_action" {
  description = "(Required) The Default Action to use when no rules match from ip_rules / virtual_network_subnet_ids. Possible values are Allow and Deny."
  type        = string
  default     = "Deny"

  validation {
    condition     = contains(["Allow", "Deny"], var.key_vault_default_action)
    error_message = "The value of the default action property of the key vault is invalid."
  }
}

variable "log_analytics_workspace_name" {
  description = "Specifies the name of the log analytics workspace"
  default     = null
  type        = string
}

variable "log_analytics_workspace_private_endpoint_name" {
  type        = string
  description = "The name of the private endpoint for the Log Analytics Workspace"
  default     = null
}

variable "log_analytics_workspace_pdns_vnet_link_name" {
  type        = string
  description = "The name of the virtual network link for the Log Analytics Workspace"
  default     = null
}

variable "solutions" {
  type        = list(map(string))
  description = "Map for log analytics solutions"
  default     = []
}

variable "application_insights" {
  type        = list(map(string))
  description = "Map for log application insights"
  default     = []
}