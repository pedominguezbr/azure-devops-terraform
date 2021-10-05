# Create Private DNS zones
resource "azurerm_private_dns_zone" "private_dns_zone" {
  name                = var.GeneralDomain
  resource_group_name = azurerm_resource_group.infra-rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "virtual_network_link" {
  name                  = "${var.environment}-virtual-network-link"
  resource_group_name   = azurerm_resource_group.infra-rg.name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone.name
  virtual_network_id    = azurerm_virtual_network.infravnet.id
}

resource "azurerm_private_dns_a_record" "p_dns_r_api" {
  name                = var.ApiSubDomain
  zone_name           = azurerm_private_dns_zone.private_dns_zone.name
  resource_group_name = azurerm_resource_group.infra-rg.name
  ttl                 = 3600
  records             = [azurerm_api_management.apim_service1.private_ip_addresses.0]
}

resource "azurerm_private_dns_a_record" "p_dns_r_portal" {
  name                = var.PortalSubDomain
  zone_name           = azurerm_private_dns_zone.private_dns_zone.name
  resource_group_name = azurerm_resource_group.infra-rg.name
  ttl                 = 3600
  records             = [azurerm_api_management.apim_service1.private_ip_addresses.0]
}

resource "azurerm_private_dns_a_record" "p_dns_r_management" {
  name                = var.ManagementSubDomain
  zone_name           = azurerm_private_dns_zone.private_dns_zone.name
  resource_group_name = azurerm_resource_group.infra-rg.name
  ttl                 = 3600
  records             = [azurerm_api_management.apim_service1.private_ip_addresses.0]
}
