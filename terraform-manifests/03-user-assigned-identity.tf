resource "azurerm_user_assigned_identity" "useridentityappgw" {
  name                = "${var.environment}-useridentity-appgw"
  location            = azurerm_resource_group.infra-rg.location
  resource_group_name = azurerm_resource_group.infra-rg.name
}