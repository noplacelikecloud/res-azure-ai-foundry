variable "name" {
  description = "Name of the AI Foundry (Cognitive Services AIServices) account. Used as the custom_subdomain_name as well."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]{2,64}$", var.name))
    error_message = "name must be 2-64 lowercase alphanumeric characters or hyphens."
  }
}

variable "resource_group_name" {
  description = "Resource group in which the account is created."
  type        = string
}

variable "location" {
  description = "Azure region for the account."
  type        = string
}

variable "sku_name" {
  description = "Cognitive Services SKU."
  type        = string
  default     = "S0"
}

variable "model" {
  description = "Model deployment configuration."
  type = object({
    name            = optional(string, "gpt-4o-mini")
    version         = optional(string, "2024-07-18")
    format          = optional(string, "OpenAI")
    deployment_name = optional(string)
  })
  default = {}
}

variable "capacity" {
  description = "Deployment capacity (TPM units / quota)."
  type        = number
  default     = 10

  validation {
    condition     = var.capacity > 0
    error_message = "capacity must be greater than zero."
  }
}

variable "deployment_sku" {
  description = "SKU object for the model deployment."
  type = object({
    name = optional(string, "Standard")
  })
  default = {}
}

variable "public_network_access" {
  description = "Whether public network access is Enabled or Disabled."
  type        = string
  default     = "Enabled"

  validation {
    condition     = contains(["Enabled", "Disabled"], var.public_network_access)
    error_message = "public_network_access must be 'Enabled' or 'Disabled'."
  }
}

variable "private_endpoint" {
  description = <<-EOT
    Optional private endpoint configuration. When set, a private
    endpoint targeting the 'account' subresource is created.
  EOT
  type = object({
    name                 = optional(string)
    subnet_id            = string
    private_dns_zone_ids = optional(list(string), [])
  })
  default = null
}
variable "enable_diagnostic_settings" {
  description = <<-EOT
    Whether to create the diagnostic setting. When null (the default),
    creation is derived from whether diagnostic_log_analytics_workspace_id
    is set. Set this explicitly to true/false when the workspace ID is
    computed (e.g. another module's output) and therefore unknown at
    plan time, so Terraform can determine the resource count.
  EOT
  type        = bool
  default     = null
}

variable "diagnostic_log_analytics_workspace_id" {
  description = "Optional Log Analytics workspace ID. When set, a diagnostic setting is created."
  type        = string
  default     = null
}

variable "tags" {
  description = "Map of tags applied to the account."
  type        = map(string)
  default     = {}
}
