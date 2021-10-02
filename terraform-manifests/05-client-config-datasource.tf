# Documentation Reference: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config
# Datasource to access the configuration of the AzureRM provider.
data "azurerm_client_config" "current" {

}

/*
data "azurerm_key_vault" "Keyvault_it" {
  name                = "${var.environment}-keyvault-it-demo1"
  resource_group_name = azurerm_resource_group.infra-rg.name
}

data "azurerm_key_vault_certificate" "gatewayCert" {
  name         = "gatewayCert-Self"
  key_vault_id = data.azurerm_key_vault.Keyvault_it.id
}

*/