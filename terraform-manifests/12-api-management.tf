
# Create Api Management

resource "azurerm_api_management" "apim_service1" {
  name                = "${var.environment}-apim-service"
  location            = azurerm_resource_group.infra-rg.location
  resource_group_name = azurerm_resource_group.infra-rg.name
  publisher_name      = "Example Publisher"
  publisher_email     = "publisher@example.com"
  sku_name            = "Developer_1"

  virtual_network_type = "Internal" #Internal #External
  virtual_network_configuration {
    subnet_id = azurerm_subnet.apim-default.id
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    "environment" = var.environment
  }

  policy {
    xml_content = <<XML
    <policies>
      <inbound />
      <backend />
      <outbound />
      <on-error />
    </policies>
XML
  }
}

resource "azurerm_key_vault_access_policy" "key_vault_access_policy_apim" {
  key_vault_id = azurerm_key_vault.infra_keyvault.id #data.azurerm_key_vault.Keyvault_it.id
  tenant_id    = azurerm_api_management.apim_service1.identity.0.tenant_id
  object_id    = azurerm_api_management.apim_service1.identity.0.principal_id

  storage_permissions = []

  certificate_permissions = [
    "Get",
    "List",
  ]
  key_permissions = [
    "Get",
    "List",
  ]

  secret_permissions = [
    "Get",
    "List",
  ]
}

/*
#Se genera el certificado en el mismo APIM
resource "azurerm_api_management_certificate" "apimcertificate" {
  name                = "apimcertificate-cert"
  api_management_name = azurerm_api_management.apim_service1.name
  resource_group_name = azurerm_resource_group.infra-rg.name

  key_vault_secret_id = azurerm_key_vault_certificate.gatewayCert.secret_id
}

*/

resource "azurerm_api_management_custom_domain" "customdomain" {
  api_management_id = azurerm_api_management.apim_service1.id

  proxy {
    host_name    = var.gatewayHostname
    key_vault_id = azurerm_key_vault_certificate.gatewayCertSelf.secret_id
  }

  developer_portal {
    host_name    = var.portalHostname
    key_vault_id = azurerm_key_vault_certificate.gatewayCertSelf.secret_id
  }
  management {
    host_name    = var.managementHostname
    key_vault_id = azurerm_key_vault_certificate.gatewayCertSelf.secret_id #data.azurerm_key_vault_certificate.gatewayCert.secret_id
  }
}

resource "azurerm_api_management_api" "api" {
  name                = "${var.environment}-api"
  resource_group_name = azurerm_resource_group.infra-rg.name
  api_management_name = azurerm_api_management.apim_service1.name
  revision            = "1"
  display_name        = "${var.environment}-api"
  path                = "example"
  protocols           = ["https", "http"]
  description         = "An example API"
  #import {
  #content_format = var.open_api_spec_content_format
  #content_value  = var.open_api_spec_content_value
  #}
}

resource "azurerm_api_management_product" "product" {
  product_id            = "${var.environment}-product"
  resource_group_name   = azurerm_resource_group.infra-rg.name
  api_management_name   = azurerm_api_management.apim_service1.name
  display_name          = "${var.environment}-product"
  subscription_required = true
  approval_required     = false
  published             = true
  description           = "An example Product"
}

resource "azurerm_api_management_group" "group" {
  name                = "${var.environment}-group"
  resource_group_name = azurerm_resource_group.infra-rg.name
  api_management_name = azurerm_api_management.apim_service1.name
  display_name        = "${var.environment}-group"
  description         = "An example group"
}

resource "azurerm_api_management_product_api" "product_api" {
  resource_group_name = azurerm_resource_group.infra-rg.name
  api_management_name = azurerm_api_management.apim_service1.name
  product_id          = azurerm_api_management_product.product.product_id
  api_name            = azurerm_api_management_api.api.name
}

resource "azurerm_api_management_product_group" "product_group" {
  resource_group_name = azurerm_resource_group.infra-rg.name
  api_management_name = azurerm_api_management.apim_service1.name
  product_id          = azurerm_api_management_product.product.product_id
  group_name          = azurerm_api_management_group.group.name

}
