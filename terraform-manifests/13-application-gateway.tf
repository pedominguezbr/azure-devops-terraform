resource "azurerm_key_vault_access_policy" "access_policiy_agw" {
  key_vault_id = azurerm_key_vault.infra_keyvault.id #data.azurerm_key_vault.Keyvault_it.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_user_assigned_identity.useridentityappgw.principal_id

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

resource "azurerm_application_gateway" "appgateway" {
  name                = "${var.environment}-appgateway"
  location            = azurerm_resource_group.infra-rg.location
  resource_group_name = azurerm_resource_group.infra-rg.name

  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "gatewayIP01"
    subnet_id = azurerm_subnet.appgw-default.id
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.useridentityappgw.id]
  }


  frontend_port {
    name = "port01"
    port = 443
  }

  frontend_ip_configuration {
    name                 = "frontend1"
    public_ip_address_id = azurerm_public_ip.infra_pip.id
  }

  ssl_certificate {
    name                = "sslcertificado"
    key_vault_secret_id = azurerm_key_vault_certificate.gatewayCertSelf.secret_id
  }

  http_listener {
    name                           = "gatewaylistener"
    host_name                      = var.appgatewayHostname
    frontend_ip_configuration_name = "frontend1"
    frontend_port_name             = "port01"
    protocol                       = "Https"
    ssl_certificate_name           = "sslcertificado"
  }

  probe {
    name                = "apimgatewayprobe"
    protocol            = "Https"
    host                = var.appgatewayHostname
    path                = "/status-0123456789abcdef"
    interval            = 30
    timeout             = 120
    unhealthy_threshold = 8
  }

  trusted_root_certificate {
    name = "whitelistcert1"
    data = filebase64(var.trustedRootCertCerPath) #file    
  }

  #Configuracion  http
  backend_http_settings {
    name                                = "apimPoolGatewaySetting"
    port                                = 443
    protocol                            = "Https"
    cookie_based_affinity               = "Disabled"
    probe_name                          = "apimgatewayprobe"
    trusted_root_certificate_names      = ["whitelistcert1"]
    pick_host_name_from_backend_address = true
  }

  backend_address_pool {
    name  = "gatewaybackend"
    fqdns = [var.appgatewayHostname]
  }

  request_routing_rule {
    name                       = "gatewayrule"
    rule_type                  = "Basic"
    http_listener_name         = "gatewaylistener"
    backend_address_pool_name  = "gatewaybackend"
    backend_http_settings_name = "apimPoolGatewaySetting"
  }
}




