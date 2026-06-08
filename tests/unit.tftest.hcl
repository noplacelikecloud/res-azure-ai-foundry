mock_provider "azurerm" {}

variables {
  name                = "aif-unit-test"
  resource_group_name = "rg-unit-test"
  location            = "westeurope"
}

run "plan_defaults" {
  command = plan

  assert {
    condition     = azurerm_cognitive_account.this.kind == "AIServices"
    error_message = "Account kind must be AIServices."
  }

  assert {
    condition     = azurerm_cognitive_account.this.sku_name == "S0"
    error_message = "Default SKU should be S0."
  }

  assert {
    condition     = azurerm_cognitive_account.this.custom_subdomain_name == "aif-unit-test"
    error_message = "custom_subdomain_name should match the account name."
  }

  assert {
    condition     = azurerm_cognitive_deployment.this.name == "gpt-4o-mini"
    error_message = "Deployment name should default to model.name (gpt-4o-mini)."
  }

  assert {
    condition     = azurerm_cognitive_deployment.this.model[0].name == "gpt-4o-mini"
    error_message = "Default model name should be gpt-4o-mini."
  }

  assert {
    condition     = azurerm_cognitive_deployment.this.sku[0].capacity == 10
    error_message = "Default capacity should be 10."
  }

  assert {
    condition     = length(azurerm_private_endpoint.this) == 0
    error_message = "No private endpoint should be created by default."
  }
}

run "plan_custom_deployment_name" {
  command = plan

  variables {
    name                = "aif-custom"
    resource_group_name = "rg-unit-test"
    location            = "westeurope"
    model = {
      name            = "gpt-4o-mini"
      version         = "2024-07-18"
      deployment_name = "primary"
    }
    capacity = 30
  }

  assert {
    condition     = azurerm_cognitive_deployment.this.name == "primary"
    error_message = "Explicit deployment_name should override the default."
  }

  assert {
    condition     = azurerm_cognitive_deployment.this.sku[0].capacity == 30
    error_message = "Capacity override should be propagated."
  }
}

run "plan_with_diagnostics" {
  command = plan

  variables {
    name                                  = "aif-diag"
    resource_group_name                   = "rg-unit-test"
    location                              = "westeurope"
    diagnostic_log_analytics_workspace_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.OperationalInsights/workspaces/law"
  }

  assert {
    condition     = length(azurerm_monitor_diagnostic_setting.this) == 1
    error_message = "Diagnostic setting should be created when a workspace ID is provided."
  }
}
