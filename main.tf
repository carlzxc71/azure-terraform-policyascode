terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.6.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "your-subscription-id"
}

locals {
  subscription_to_assign_policy = "/subscriptions/${var.subscription_id}"
}

data "azurerm_client_config" "current" {}

data "azurerm_policy_definition" "this" {
  name = "f8d36e2f-389b-4ee4-898d-21aeb69a0f45"
}

resource "azurerm_subscription_policy_assignment" "this" {
  name                 = data.azurerm_policy_definition.this.display_name
  policy_definition_id = data.azurerm_policy_definition.this.id
  subscription_id      = local.subscription_to_assign_policy
  parameters = jsonencode({
    "Effect" = {
      "value" = "AuditIfNotExists"
    }
    "requiredRetentionDays" = {
      "value" = "90"
    }
  })
}

