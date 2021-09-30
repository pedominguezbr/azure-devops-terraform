# Create Virtual Network
resource "azurerm_virtual_network" "infravnet" {
  name                = "${var.environment}-aks-network"
  location            = azurerm_resource_group.infra-rg.location
  resource_group_name = azurerm_resource_group.infra-rg.name
  address_space       = ["192.168.0.0/21"]
}

# Create a Subnet for AKS
resource "azurerm_subnet" "aks-default" {
  name                 = "${var.environment}-aks-default-subnet"
  virtual_network_name = azurerm_virtual_network.infravnet.name
  resource_group_name  = azurerm_resource_group.infra-rg.name
  address_prefixes     = ["192.168.0.0/22"]
}

# Create a Subnet for APIM
resource "azurerm_subnet" "apim-default" {
  name                 = "${var.environment}-apim-default-subnet"
  virtual_network_name = azurerm_virtual_network.infravnet.name
  resource_group_name  = azurerm_resource_group.infra-rg.name
  address_prefixes     = ["192.168.5.0/24"]
}

# Create a Subnet for appGw
resource "azurerm_subnet" "appgw-default" {
  name                 = "${var.environment}-appgw-default-subnet"
  virtual_network_name = azurerm_virtual_network.infravnet.name
  resource_group_name  = azurerm_resource_group.infra-rg.name
  address_prefixes     = ["192.168.6.0/24"]
}
