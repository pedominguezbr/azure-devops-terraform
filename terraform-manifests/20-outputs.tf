# Create Outputs
# 1. Resource Group Location
# 2. Resource Group Id
# 3. Resource Group Name

# Resource Group Outputs
output "location" {
  value = azurerm_resource_group.infra-rg.location
}

output "resource_group_id" {
  value = azurerm_resource_group.infra-rg.id
}

output "resource_group_name" {
  value = azurerm_resource_group.infra-rg.name
}

# Azure AKS Versions Datasource
output "versions" {
  value = data.azurerm_kubernetes_service_versions.current.versions
}

output "latest_version" {
  value = data.azurerm_kubernetes_service_versions.current.latest_version
}

# Datasource to access the configuration of the AzureRM provider
output "account_id" {
  value = data.azurerm_client_config.current.client_id
}

# Azure AD Group Object Id
output "azure_ad_group_id" {
  value = azuread_group.aks_administrators.id
}
output "azure_ad_group_objectid" {
  value = azuread_group.aks_administrators.object_id
}


# Azure AKS Outputs

/*
output "aks_cluster_id" {
  value = azurerm_kubernetes_cluster.aks_cluster.id
}

output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.aks_cluster.name
}

output "aks_cluster_kubernetes_version" {
  value = azurerm_kubernetes_cluster.aks_cluster.kubernetes_version
}
*/



output "apim_service1_id" {
  description = "The ID of the API Management Service created"
  value       = azurerm_api_management.apim_service1.id
}

output "apim_service1_gateway_url" {
  description = "The URL of the Gateway for the API Management Service"
  value       = azurerm_api_management.apim_service1.gateway_url
}

output "apim_service1_public_ip_addresses" {
  description = "The Public IP addresses of the API Management Service"
  value       = azurerm_api_management.apim_service1.public_ip_addresses
}

output "apim_service1_api_outputs" {
  description = "The IDs, state, and version outputs of the APIs created"
  value = {
    id             = azurerm_api_management_api.api.id
    is_current     = azurerm_api_management_api.api.is_current
    is_online      = azurerm_api_management_api.api.is_online
    version        = azurerm_api_management_api.api.version
    version_set_id = azurerm_api_management_api.api.version_set_id
  }
}

output "apim_service1_group_id" {
  description = "The ID of the API Management Group created"
  value       = azurerm_api_management_group.group.id
}

output "apim_service1_product_ids" {
  description = "The ID of the Product created"
  value       = azurerm_api_management_product.product.id
}

output "apim_service1_product_api_ids" {
  description = "The ID of the Product/API association created"
  value       = azurerm_api_management_product_api.product_api.id
}

output "apim_service1_product_group_ids" {
  description = "The ID of the Product/Group association created"
  value       = azurerm_api_management_product_group.product_group.id
}

output "access_policy_key_permissions_apim" {
  value = azurerm_key_vault_access_policy.key_vault_access_policy_apim.certificate_permissions
}

output "access_policy_key_permissions_appgw" {
  value = azurerm_key_vault_access_policy.key_vault_access_policy_appgw.certificate_permissions
}