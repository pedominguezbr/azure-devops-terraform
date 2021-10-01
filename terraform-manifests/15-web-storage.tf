# Create Web Storage
resource "azurerm_storage_account" "webstorage" {
  name                      = "${var.environment}webstaticinfrapd"
  resource_group_name       = azurerm_resource_group.infra-rg.name
  location                  = azurerm_resource_group.infra-rg.location
  account_kind              = "StorageV2"
  account_tier              = "Standard"
  account_replication_type  = "LRS" #GRS
  enable_https_traffic_only = true
  min_tls_version           = "TLS1_0"
  static_website {
    index_document = "index.html"
  }

  tags = {
    "environment" = var.environment
  }

}