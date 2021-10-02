resource "azurerm_public_ip" "infra_pip" {
  name                = "${var.environment}-pip"
  resource_group_name = azurerm_resource_group.infra-rg.name
  location            = azurerm_resource_group.infra-rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
}