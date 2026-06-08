output "id" {
  description = "Full Azure resource ID of the AI Foundry (Cognitive Services) account."
  value       = azurerm_cognitive_account.this.id
}

output "name" {
  description = "AI Foundry account name."
  value       = azurerm_cognitive_account.this.name
}

output "endpoint" {
  description = "Base endpoint URL of the AI Foundry account (e.g. https://<name>.cognitiveservices.azure.com/)."
  value       = azurerm_cognitive_account.this.endpoint
}

output "primary_access_key" {
  description = "Primary access key of the account. Sensitive."
  value       = azurerm_cognitive_account.this.primary_access_key
  sensitive   = true
}

output "deployment_name" {
  description = "Name of the model deployment."
  value       = azurerm_cognitive_deployment.this.name
}

output "principal_id" {
  description = "System-Assigned MI principal ID of the account."
  value       = azurerm_cognitive_account.this.identity[0].principal_id
}

output "private_endpoint_id" {
  description = "Resource ID of the private endpoint (null when none was created)."
  value       = length(azurerm_private_endpoint.this) > 0 ? azurerm_private_endpoint.this[0].id : null
}
