terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">4.3.0"
    }
  }
}

provider "azurerm" {
  features {}
  #subscription_id = ""
  #tenant_id       = ""
  #client_id       = ""
  #client_secret   = ""
}
