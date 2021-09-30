# Create Api Management

resource "azurerm_api_management" "apim_service" {
  name                 = "${var.environment}-apim-service"
  location             = azurerm_resource_group.infra-rg.location
  resource_group_name  = azurerm_resource_group.infra-rg.name
  publisher_name       = "Example Publisher"
  publisher_email      = "publisher@example.com"
  sku_name             = "Developer_1"
  virtual_network_type = "Internal"
  virtual_network_configuration {
    subnet_id = azurerm_subnet.apim-default.id
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

resource "azurerm_api_management_api" "api" {
  name                = "${var.environment}-api"
  resource_group_name = azurerm_resource_group.infra-rg.name
  api_management_name = azurerm_api_management.apim_service.name
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
  api_management_name   = azurerm_api_management.apim_service.name
  display_name          = "${var.environment}-product"
  subscription_required = true
  approval_required     = false
  published             = true
  description           = "An example Product"
}

resource "azurerm_api_management_group" "group" {
  name                = "${var.environment}-group"
  resource_group_name = azurerm_resource_group.infra-rg.name
  api_management_name = azurerm_api_management.apim_service.name
  display_name        = "${var.environment}-group"
  description         = "An example group"
}

resource "azurerm_api_management_product_api" "product_api" {
  resource_group_name = azurerm_resource_group.infra-rg.name
  api_management_name = azurerm_api_management.apim_service.name
  product_id          = azurerm_api_management_product.product.product_id
  api_name            = azurerm_api_management_api.api.name
}

resource "azurerm_api_management_product_group" "product_group" {
  resource_group_name = azurerm_resource_group.infra-rg.name
  api_management_name = azurerm_api_management.apim_service.name
  product_id          = azurerm_api_management_product.product.product_id
  group_name          = azurerm_api_management_group.group.name

}