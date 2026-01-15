output "resource_group_name" {
  description = "Resource group name for platform management"
  value       = azurerm_resource_group.this.name
}

output "log_analytics_workspace_id" {
  description = "Log Analytics Workspace ID"
  value       = azurerm_log_analytics_workspace.this.id
}
