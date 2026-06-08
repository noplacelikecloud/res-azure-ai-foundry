# res-azure-ai-foundry

Generic, organization-wide resource module that provisions an Azure AI
Foundry account (Cognitive Services account of kind `AIServices`)
together with one model deployment. Optional private endpoint and Log
Analytics diagnostic setting are included.

The deployed model is OpenAI-compatible and can be consumed by clients
such as Open WebUI via the standard `/openai/deployments/<name>` URL
prefix on the account endpoint.

## Usage

```hcl
module "foundry" {
  source  = "git::https://github.com/noplacelikecloud/res-azure-ai-foundry.git?ref=v1.0.0"

  name                = "aif-chatbot-prod"
  resource_group_name = "rg-chatbot-prod"
  location            = "westeurope"

  model = {
    name    = "gpt-4o-mini"
    version = "2024-07-18"
  }

  capacity = 30
}
```

## Inputs

| Name                                  | Type                                                                                                  | Default            | Description                                              |
| ------------------------------------- | ----------------------------------------------------------------------------------------------------- | ------------------ | -------------------------------------------------------- |
| name                                  | string                                                                                                | n/a                | Account name (2-64 lowercase chars).                     |
| resource_group_name                   | string                                                                                                | n/a                | Hosting resource group.                                  |
| location                              | string                                                                                                | n/a                | Azure region.                                            |
| sku_name                              | string                                                                                                | `S0`               | Cognitive Services SKU.                                  |
| model                                 | object({name?, version?, format?, deployment_name?})                                                  | `gpt-4o-mini`      | Model definition. `deployment_name` defaults to `name`.  |
| capacity                              | number                                                                                                | `10`               | Deployment capacity (TPM units).                         |
| deployment_sku                        | object({name?})                                                                                       | `{name="Standard"}`| Deployment SKU.                                          |
| public_network_access                 | string                                                                                                | `Enabled`          | `Enabled` or `Disabled`.                                 |
| private_endpoint                      | object({name?, subnet_id, private_dns_zone_ids?}) or null                                             | `null`             | Optional private endpoint.                               |
| diagnostic_log_analytics_workspace_id | string or null                                                                                        | `null`             | When set, creates a diagnostic setting.                  |
| tags                                  | map(string)                                                                                           | `{}`               | Tags.                                                    |

## Outputs

| Name                | Description                                                                  |
| ------------------- | ---------------------------------------------------------------------------- |
| id                  | Full Azure resource ID.                                                      |
| name                | Account name.                                                                |
| endpoint            | Base endpoint URL.                                                           |
| primary_access_key  | Primary access key (sensitive).                                              |
| deployment_name     | Model deployment name.                                                       |
| principal_id        | System-Assigned MI principal ID.                                             |
| private_endpoint_id | Private endpoint ID, or null when not created.                               |

## Tests

```bash
terraform init -backend=false
terraform test
```
