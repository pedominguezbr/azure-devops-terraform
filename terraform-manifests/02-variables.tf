# Define Input Variables
# 1. Azure Location (CentralUS)
# 2. Azure Resource Group Name 
# 3. Azure AKS Environment Name (Dev, QA, Prod)

# Azure Location
variable "location" {
  type        = string
  description = "Azure Region where all these resources will be provisioned"
  default     = "eastus2"
}

# Azure Resource Group Name
variable "resource_group_name" {
  type        = string
  description = "This variable defines the Resource Group"
  default     = "terraform-aks"
}

variable "zones" {
  description = "A collection of availability zones to spread the Application Gateway over."
  type        = list(string)
  default     = [] #[1, 2, 3]
}


# Azure AKS Environment Name
variable "environment" {
  type        = string
  description = "This variable defines the Environment"
  default     = "dev2" #Comentado para Pipeline
}


# AKS Input Variables

# SSH Public Key for Linux VMs
variable "ssh_public_key" {
  default     = "~/.ssh/aks-prod-sshkeys-terraform/aksprodsshkey.pub" #Comentado para Pipeline
  description = "This variable defines the SSH Public Key for Linux k8s Worker nodes"
}

# Windows Admin Username for k8s worker nodes
variable "windows_admin_username" {
  type        = string
  default     = "azureuser"
  description = "This variable defines the Windows admin username k8s Worker nodes"
}

# Windows Admin Password for k8s worker nodes
variable "windows_admin_password" {
  type        = string
  default     = "P@ssw0rd1234.ab"
  description = "This variable defines the Windows admin password k8s Worker nodes"
}

variable "waf_configuration" {
  description = "Configuration block for WAF."
  type = object({
    firewall_mode            = string
    rule_set_type            = string
    rule_set_version         = string
    file_upload_limit_mb     = number
    max_request_body_size_kb = number
  })
  default = null
}

#Capacity Autoscaling appgw
variable "capacity" {
  description = "Min and max capacity for auto scaling"
  type = object({
    min = number
    max = number
  })
  default = null
}

# My Domain
variable "GeneralDomain" {
  type        = string
  default     = "pdominguez.com"
  description = "API gateway host"
}

# Api SubDomain
variable "ApiSubDomain" {
  type        = string
  default     = "devapi"
  description = "API SubDomain."
}

# Portal SubDomain
variable "PortalSubDomain" {
  type        = string
  default     = "devportal"
  description = "Portal SubDomain."
}

# Management  SubDomain
variable "ManagementSubDomain" {
  type        = string
  default     = "devmanagement"
  description = "Management SubDomain."
}

# API gateway host
variable "gatewayHostname" {
  type        = string
  default     = "devapi.pdominguez.com"
  description = "API gateway host"
}

# API developer portal host
variable "portalHostname" {
  type        = string
  default     = "devportal.pdominguez.com"
  description = "API developer portal host"
}

# API management endpoint host
variable "managementHostname" {
  type        = string
  default     = "devmanagement.pdominguez.com"
  description = "API management endpoint host"
}

# APP gateway host
variable "appgatewayHostname" {
  type        = string
  default     = "devappgw.pdominguez.com"
  description = "APP gateway host"
}

# Full Path Certificate api.PFX
variable "gatewayCertPfxPath" {
  default     = "~/certificados/certchain.pfx" #Comentado para Pipeline
  description = "full path to api.dominio .pfx file"
}

# password for api.PFX certificate
variable "gatewayCertPfxPassword" {
  default     = "Casma.2019" #Comentado para Pipeline, empty sin pass 
  description = "password for api.PFX certificate"
}

## full path to contoso.net trusted root .cer file
variable "trustedRootCertCerPath" {
  default     = "~/certificados/gatewayCert-Self.cer" #Comentado para Pipeline, empty sin pass  "C:\\certificacion\\gatewayCert-Self.cer" #default
  description = "full path to contoso.net trusted root .cer file"
}

