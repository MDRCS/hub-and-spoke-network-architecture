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
  name     = local.hub-nva-resource_group 
  location = var.location

  # tags = {
  #   environment = local.prefix-hub-nva
  # }
}
resource "azurerm_resource_group" "hub-vnet-rg" {
  name     = local.hub-vnet-resource-group
  location = var.location
}

resource "azurerm_resource_group" "spoke1-vnet-rg" {
  name     = local.spoke1-resource-group
  location = var.location
}


resource "azurerm_resource_group" "spoke2-vnet-rg" {
  name     = local.spoke2-resource-group
  location = var.location
}

module "firewall" {
  source = "./modules/firewall"
  resource_group_name = azurerm_resource_group.hub-vnet-rg.name
  location = var.location
}

module "virtual_network" {
  source = "./modules/virtual_network"
  resource_group_name = azurerm_resource_group.hub-vnet-rg.name
  location = var.location
}

module "virtual_machine" {
  source = "./modules/virtual_machine"
  hub_nva_resource_group_name = azurerm_resource_group.hub-nva-rg.name
  hub_vnet_resource_group_name = azurerm_resource_group.hub-vnet-rg.name
  location = var.location
  username = var.username
  password = var.password
}

