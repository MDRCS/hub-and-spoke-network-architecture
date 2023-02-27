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

  tags = merge(
    tomap({ ResourceGroupe = local.prefix-hub-nva }),
    local.default_tags
  )
}
resource "azurerm_resource_group" "hub-vnet-rg" {
  name     = local.hub-vnet-resource-group
  location = var.location

  tags = merge(
    tomap({ ResourceGroupe = local.prefix-hub-vnet }),
    local.default_tags
  )
}

resource "azurerm_resource_group" "spoke1-vnet-rg" {
  name     = local.spoke1-resource-group
  location = var.location

  tags = merge(
    tomap({ ResourceGroupe = local.prefix-spoke1 }),
    local.default_tags
  )
}

resource "azurerm_resource_group" "spoke2-vnet-rg" {
  name     = local.spoke2-resource-group
  location = var.location

  tags = merge(
    tomap({ ResourceGroupe = local.prefix-spoke2 }),
    local.default_tags
  )
}

module "firewall" {
  source              = "./modules/firewall"
  hub_vnet_resource_group_name    = azurerm_resource_group.hub-vnet-rg.name
  spoke1_vnet_resource_group_name = azurerm_resource_group.spoke1-vnet-rg.name
  spoke2_vnet_resource_group_name = azurerm_resource_group.spoke2-vnet-rg.name
  location            = var.location
  my_ip                           = data.external.my_ip.result.ip
}

module "vpn_gateway" {
  source                       = "./modules/vpn_gateway"
  hub_vnet_resource_group_name    = azurerm_resource_group.hub-vnet-rg.name
  spoke1_vnet_resource_group_name = azurerm_resource_group.spoke1-vnet-rg.name
  spoke2_vnet_resource_group_name = azurerm_resource_group.spoke2-vnet-rg.name
  location                     = var.location
}

module "virtual_network" {
  source                          = "./modules/virtual_network"
  hub_vnet_resource_group_name    = azurerm_resource_group.hub-vnet-rg.name
  spoke1_vnet_resource_group_name = azurerm_resource_group.spoke1-vnet-rg.name
  spoke2_vnet_resource_group_name = azurerm_resource_group.spoke2-vnet-rg.name
  location                        = var.location
}

module "virtual_network_peering" {
  source                          = "./modules/virtual_network_peering"
  hub_vnet_resource_group_name    = azurerm_resource_group.hub-vnet-rg.name
  spoke1_vnet_resource_group_name = azurerm_resource_group.spoke1-vnet-rg.name
  spoke2_vnet_resource_group_name = azurerm_resource_group.spoke2-vnet-rg.name
  location                        = var.location
}

module "routing" {
  source                          = "./modules/routing"
  hub_nva_resource_group_name     = azurerm_resource_group.hub-nva-rg.name
  hub_vnet_resource_group_name    = azurerm_resource_group.hub-vnet-rg.name
  spoke1_vnet_resource_group_name = azurerm_resource_group.spoke1-vnet-rg.name
  spoke2_vnet_resource_group_name = azurerm_resource_group.spoke2-vnet-rg.name
  location                        = var.location
}

module "virtual_machine" {
  source                          = "./modules/virtual_machine"
  hub_nva_resource_group_name     = azurerm_resource_group.hub-nva-rg.name
  hub_vnet_resource_group_name    = azurerm_resource_group.hub-vnet-rg.name
  spoke1_vnet_resource_group_name = azurerm_resource_group.spoke1-vnet-rg.name
  spoke2_vnet_resource_group_name = azurerm_resource_group.spoke2-vnet-rg.name
  location                        = var.location
  username                        = var.username
  password                        = var.password
  my_ip                           = data.external.my_ip.result.ip
  vmsize                          = var.vmsize
}

