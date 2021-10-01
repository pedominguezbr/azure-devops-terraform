resource "azurerm_key_vault" "infra_keyvault" {
  name                = "${var.environment}-keyvault-it-demo1"
  resource_group_name = azurerm_resource_group.infra-rg.name
  location            = azurerm_resource_group.infra-rg.location
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    certificate_permissions = [
      "create",
      "delete",
      "deleteissuers",
      "get",
      "getissuers",
      "import",
      "list",
      "listissuers",
      "managecontacts",
      "manageissuers",
      "setissuers",
      "update",
    ]

    key_permissions = [
      "backup",
      "create",
      "decrypt",
      "delete",
      "encrypt",
      "get",
      "import",
      "list",
      "purge",
      "recover",
      "restore",
      "sign",
      "unwrapKey",
      "update",
      "verify",
      "wrapKey",
    ]

    secret_permissions = [
      "backup",
      "delete",
      "get",
      "list",
      "purge",
      "recover",
      "restore",
      "set",
    ]
  }
}

resource "azurerm_key_vault_access_policy" "key_vault_access_policy" {
  key_vault_id = azurerm_key_vault.infra_keyvault.id
  tenant_id    = azurerm_api_management.apim_service1.identity.0.tenant_id
  object_id    = azurerm_api_management.apim_service1.identity.0.principal_id

  key_permissions = [
    "get",
  ]

  secret_permissions = [
    "get",
  ]
}

resource "azurerm_key_vault_certificate" "gatewayCert" {
  name         = "gatewayCert-cert"
  key_vault_id = azurerm_key_vault.infra_keyvault.id

  certificate {
    contents = filebase64(var.gatewayCertPfxPath)
    password = var.gatewayCertPfxPassword
  }

  certificate_policy {
    issuer_parameters {
      name = "Self"
    }

    key_properties {
      exportable = true
      key_size   = 2048
      key_type   = "RSA"
      reuse_key  = false
    }

    secret_properties {
      content_type = "application/x-pkcs12" #"application/x-pkcs12"
    }
  }
}

