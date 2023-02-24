terraform {

  required_version = ">=0.12"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "hub-nva-rg" {
  name     = "${local.prefix-hub-nva}-rg"
  location = local.hub-nva-location

  tags = {
    environment = local.prefix-hub-nva
  }
}
resource "azurerm_resource_group" "hub-vnet-rg" {
  name     = local.hub-resource-group
  location = local.hub-location
}

resource "azurerm_resource_group" "spoke1-vnet-rg" {
  name     = local.spoke1-resource-group
  location = local.spoke1-location
}


resource "azurerm_resource_group" "spoke2-vnet-rg" {
  name     = local.spoke2-resource-group
  location = local.spoke2-location
}

module "firewall" {
  
  
}
