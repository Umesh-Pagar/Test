terraform {
  required_providers {
    azapi = {
      source  = "Azure/azapi"
      version = "1.13.1"
    }
  }
}

resource "azurerm_key_vault" "key_vault" {
  name                            = var.name
  location                        = var.location
  resource_group_name             = var.resource_group_name
  tenant_id                       = var.tenant_id
  sku_name                        = var.sku_name
  tags                            = var.tags
  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_template_deployment = var.enabled_for_template_deployment
  enable_rbac_authorization       = var.enable_rbac_authorization
  purge_protection_enabled        = var.purge_protection_enabled
  soft_delete_retention_days      = var.soft_delete_retention_days

  timeouts {
    delete = "60m"
  }

  network_acls {
    bypass                     = var.bypass
    default_action             = var.default_action
    ip_rules                   = var.ip_rules
    virtual_network_subnet_ids = var.virtual_network_subnet_ids
  }

  access_policy {
    tenant_id               = var.tenant_id
    object_id               = var.object_id
    secret_permissions      = var.secret_permissions
    key_permissions         = var.key_permissions
    certificate_permissions = var.certificate_permissions
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azapi_update_resource" "enable_soft_delete" {
  type        = "Microsoft.KeyVault/vaults@2023-07-01"
  resource_id = azurerm_key_vault.key_vault.id
  body = jsonencode({
    properties = {
      enableSoftDelete          = var.enable_soft_delete
      softDeleteRetentionInDays = var.soft_delete_retention_days
    }
  })
}

resource "azurerm_monitor_diagnostic_setting" "settings" {
  name                       = "DiagnosticsSettings"
  target_resource_id         = azurerm_key_vault.key_vault.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "AuditEvent"
  }

  enabled_log {
    category = "AzurePolicyEvaluationDetails"
  }

  metric {
    category = "AllMetrics"
  }
}
