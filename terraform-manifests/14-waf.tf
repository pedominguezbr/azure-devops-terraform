
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