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
      "Create",
      "Delete",
      "DeleteIssuers",
      "Get",
      "GetIssuers",
      "Import",
      "List",
      "Purge",
      "Recover",
      "Restore",
      "ListIssuers",
      "ManageContacts",
      "ManageIssuers",
      "SetIssuers",
      "Update",
    ]

    key_permissions = [
      "Backup",
      "Create",
      "Decrypt",
      "Delete",
      "Encrypt",
      "Get",
      "Import",
      "List",
      "Purge",
      "Recover",
      "Restore",
      "Sign",
      "UnwrapKey",
      "Update",
      "Verify",
      "WrapKey",
    ]

    secret_permissions = [
      "Backup",
      "Delete",
      "Get",
      "List",
      "Purge",
      "Recover",
      "Restore",
      "Set",
      "Purge",
    ]
  }
}

/*
#Cargar Certificado tipo PFX
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

*/
#Create Certificate Seft Script - Autofirmado
resource "azurerm_key_vault_certificate" "gatewayCertSelf" {
  name         = "gatewayCert-Self"
  key_vault_id = azurerm_key_vault.infra_keyvault.id

  tags = {
    "prueba" = "1"
  }

  certificate_policy {
    issuer_parameters {
      name = "Self"
    }

    key_properties {
      exportable = true
      key_size   = 2048
      key_type   = "RSA"
      reuse_key  = true
    }

    lifetime_action {
      action {
        action_type = "AutoRenew"
      }

      trigger {
        days_before_expiry = 30
      }
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }

    x509_certificate_properties {
      key_usage = [
        "cRLSign",
        "dataEncipherment",
        "digitalSignature",
        "keyAgreement",
        "keyCertSign",
        "keyEncipherment",
      ]

      subject            = "CN=devapi.pdominguez.com"
      validity_in_months = 12

      subject_alternative_names {
        dns_names = [
          "devapi.pdominguez.com",
          "devportal.pdominguez.com",
          "devmanagement.pdominguez.com",
          "devrancher.pdominguez.com",
          "devappgw.pdominguez.com",
        ]
      }
    }
  }
}
