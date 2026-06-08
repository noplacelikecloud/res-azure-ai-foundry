terraform {
  required_version = ">= 1.9.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

module "foundry" {
  source = "../.."

  name                = "aif-example-001"
  resource_group_name = "rg-example"
  location            = "westeurope"
}

output "endpoint" {
  value = module.foundry.endpoint
}

output "deployment_name" {
  value = module.foundry.deployment_name
}
