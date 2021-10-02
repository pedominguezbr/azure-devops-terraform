
# 1. Terraform Settings Block
terraform {
  # 1. Required Version Terraform
  required_version = ">= 0.13"
  # 2. Required Terraform Providers  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.78"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.4"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
  }

  # Terraform State Storage to Azure Storage Container
  # Values commento to Pipeline
  backend "azurerm" {
    resource_group_name  = "terraform-storage-rg"
    storage_account_name = "terraformstatexlrwdpmdb"
    container_name       = "tfstatefiles"
    key                  = "dev2.terraform.tfstate"
  }
}



# 2. Terraform Provider Block for AzureRM
provider "azurerm" {
  features {

  }
}

# 3. Terraform Resource Block: Define a Random Pet Resource
resource "random_pet" "aksrandom" {

}

