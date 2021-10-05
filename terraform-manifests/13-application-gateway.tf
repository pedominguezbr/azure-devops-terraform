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
  zones               = var.zones
  firewall_policy_id  = azurerm_web_application_firewall_policy.wafpolicy.id

  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
    capacity = 2
  }

  /*
  autoscale_configuration {
    min_capacity = var.capacity.min
    max_capacity = var.capacity.max
  }
*/
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
    require_sni                    = true
    firewall_policy_id             = azurerm_web_application_firewall_policy.wafpolicy.id #Add al Waf policy
  }

  http_listener {
    name                           = "portallistener"
    host_name                      = var.portalHostname
    frontend_ip_configuration_name = "frontend1"
    frontend_port_name             = "port01"
    protocol                       = "Https"
    ssl_certificate_name           = "sslcertificado"
    require_sni                    = true
    firewall_policy_id             = azurerm_web_application_firewall_policy.wafpolicy.id #Add al Waf policy
  }

  http_listener {
    name                           = "managementlistener"
    host_name                      = var.managementHostname
    frontend_ip_configuration_name = "frontend1"
    frontend_port_name             = "port01"
    protocol                       = "Https"
    ssl_certificate_name           = "sslcertificado"
    require_sni                    = true
    firewall_policy_id             = azurerm_web_application_firewall_policy.wafpolicy.id #Add al Waf policy
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

  probe {
    name                = "apimportalprobe"
    protocol            = "Https"
    host                = var.portalHostname
    path                = "/signin"
    interval            = 60
    timeout             = 300
    unhealthy_threshold = 8
  }

  probe {
    name                = "apimmanagementprobe"
    protocol            = "Https"
    host                = var.managementHostname
    path                = "/ServiceStatus"
    interval            = 60
    timeout             = 300
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
    request_timeout                     = 180
  }

  backend_http_settings {
    name                                = "apimPoolPortalSetting"
    port                                = 443
    protocol                            = "Https"
    cookie_based_affinity               = "Disabled"
    probe_name                          = "apimportalprobe"
    trusted_root_certificate_names      = ["whitelistcert1"]
    pick_host_name_from_backend_address = true
    request_timeout                     = 180
  }

  backend_http_settings {
    name                                = "apimPoolManagementSetting"
    port                                = 443
    protocol                            = "Https"
    cookie_based_affinity               = "Disabled"
    probe_name                          = "apimmanagementprobe"
    trusted_root_certificate_names      = ["whitelistcert1"]
    pick_host_name_from_backend_address = true
    request_timeout                     = 180
  }

  backend_address_pool {
    name  = "gatewaybackend"
    fqdns = [var.appgatewayHostname]
  }

  backend_address_pool {
    name  = "portalbackend"
    fqdns = [var.portalHostname]
  }

  backend_address_pool {
    name  = "managementbackend"
    fqdns = [var.managementHostname]
  }

  request_routing_rule {
    name                       = "gatewayrule"
    rule_type                  = "Basic"
    http_listener_name         = "gatewaylistener"
    backend_address_pool_name  = "gatewaybackend"
    backend_http_settings_name = "apimPoolGatewaySetting"
  }

  request_routing_rule {
    name                       = "portalrule"
    rule_type                  = "Basic"
    http_listener_name         = "portallistener"
    backend_address_pool_name  = "portalbackend"
    backend_http_settings_name = "apimPoolPortalSetting"
  }

  request_routing_rule {
    name                       = "managementrule"
    rule_type                  = "Basic"
    http_listener_name         = "managementlistener"
    backend_address_pool_name  = "managementbackend"
    backend_http_settings_name = "apimPoolManagementSetting"
  }

  waf_configuration {
    enabled          = true
    firewall_mode    = "Prevention" #Detection 
    rule_set_type    = "OWASP"
    rule_set_version = "3.0" #Possible values are 2.2.9, 3.0, and 3.1
  }

}


resource "azurerm_web_application_firewall_policy" "wafpolicy" {
  name                = "${var.environment}-wafpolicy"
  location            = azurerm_resource_group.infra-rg.location
  resource_group_name = azurerm_resource_group.infra-rg.name

  tags = {
    "environment" = var.environment
  }

  policy_settings {
    enabled                     = true
    file_upload_limit_in_mb     = coalesce(var.waf_configuration != null ? var.waf_configuration.file_upload_limit_mb : null, 100)
    max_request_body_size_in_kb = coalesce(var.waf_configuration != null ? var.waf_configuration.max_request_body_size_kb : null, 128)
    mode                        = coalesce(var.waf_configuration != null ? var.waf_configuration.firewall_mode : null, "Prevention")
    request_body_check          = true
  }

  managed_rules {
    managed_rule_set {
      type    = coalesce(var.waf_configuration != null ? var.waf_configuration.rule_set_type : null, "OWASP")
      version = coalesce(var.waf_configuration != null ? var.waf_configuration.rule_set_version : null, "3.0")

      #aqui continua
    }
  }

}