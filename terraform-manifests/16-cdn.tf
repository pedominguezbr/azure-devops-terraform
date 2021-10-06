# Create CDN
resource "azurerm_cdn_profile" "cdn_profile" {
  name                = "${var.environment}-cdn-profile"
  location            = azurerm_resource_group.infra-rg.location
  resource_group_name = azurerm_resource_group.infra-rg.name
  sku                 = "Standard_Microsoft" #Standard_Verizon

  tags = {
    "environment" = var.environment
  }
}

resource "azurerm_cdn_endpoint" "cdn_profile_endpoint" {
  name                = "${var.environment}-cdn-profile-endpoint"
  profile_name        = azurerm_cdn_profile.cdn_profile.name
  location            = azurerm_resource_group.infra-rg.location
  resource_group_name = azurerm_resource_group.infra-rg.name
  origin_host_header  = azurerm_storage_account.webstorage.primary_web_host

  origin {
    name = azurerm_storage_account.webstorage.name

    host_name  = azurerm_storage_account.webstorage.primary_web_host #azurerm_storage_account.webstorage.primary_blob_host
    http_port  = 80
    https_port = 443
  }

  tags = {
    "environment" = var.environment
  }

  delivery_rule {
    name  = "EnforceHTTPS"
    order = "1"

    request_scheme_condition {
      operator     = "Equal"
      match_values = ["HTTP"]
    }

    url_redirect_action {
      redirect_type = "Found"
      protocol      = "Https"
    }
  }

}

/*
resource "azurerm_cdn_endpoint_custom_domain" "example" {
  name            = "example-domain"
  cdn_endpoint_id = azurerm_cdn_endpoint.example.id
  host_name       = "${azurerm_dns_cname_record.example.name}.${data.azurerm_dns_zone.example.name}"
}

*/