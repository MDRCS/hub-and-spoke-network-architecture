# Hub Virtual Network & Subnets
resource "azurerm_virtual_network" "hub-vnet" {
  name                = "${local.prefix-hub}-vnet"
  resource_group_name = var.hub_vnet_resource_group_name
  location            = var.location
  address_space       = ["10.0.0.0/16"]

#   tags = {
#     environment = "hub-spoke"
#   }
}

resource "azurerm_subnet" "hub-gateway-subnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = var.hub_vnet_resource_group_name
  virtual_network_name = azurerm_virtual_network.hub-vnet.name
  address_prefixes     = ["10.0.0.0/27"]
}

resource "azurerm_subnet" "hub_firewall" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = var.hub_vnet_resource_group_name
  virtual_network_name = azurerm_virtual_network.hub-vnet.name
  address_prefixes     = ["10.0.3.0/26"]
}

resource "azurerm_subnet" "hub_firewall_mgmt" {
  name                 = "AzureFirewallManagementSubnet"
  resource_group_name  = var.hub_vnet_resource_group_name
  virtual_network_name = azurerm_virtual_network.hub-vnet.name
  address_prefixes     = ["10.0.5.0/26"]
}

resource "azurerm_subnet" "hub-mgmt" {
  name                 = "mgmt"
  resource_group_name  = var.hub_vnet_resource_group_name
  virtual_network_name = azurerm_virtual_network.hub-vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "hub-dmz" {
  name                 = "dmz"
  resource_group_name  = var.hub_vnet_resource_group_name
  virtual_network_name = azurerm_virtual_network.hub-vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}



# Spoke 1 Virtual Network & Subnets
resource "azurerm_virtual_network" "spoke1-vnet" {
  name                ="${local.prefix-spoke1}-vnet"
  resource_group_name = var.spoke1_vnet_resource_group_name 
  location            = var.location
  address_space       = ["10.1.0.0/16"]

#   tags = {
#     environment = local.prefix-spoke1
#   }
}

resource "azurerm_subnet" "spoke1-mgmt" {
  name                 = "${local.prefix-spoke1}-mgmt"
  resource_group_name = var.spoke1_vnet_resource_group_name 
  virtual_network_name = azurerm_virtual_network.spoke1-vnet.name
  address_prefixes     = ["10.1.0.64/27"]
}

resource "azurerm_subnet" "spoke1-workload" {
  name                 = "${local.prefix-spoke1}-workload"
  resource_group_name = var.spoke1_vnet_resource_group_name 
  virtual_network_name = azurerm_virtual_network.spoke1-vnet.name
  address_prefixes     = ["10.1.1.0/24"]
}


# Spoke 2 Virtual Network & Subnets
resource "azurerm_virtual_network" "spoke2-vnet" {
  name                = "${local.prefix-spoke2}-vnet"
  resource_group_name = var.spoke2_vnet_resource_group_name 
  location            = var.location
  address_space       = ["10.2.0.0/16"]

#   tags = {
#     environment = local.prefix-spoke2
#   }
}

resource "azurerm_subnet" "spoke2-mgmt" {
  name                 = "${local.prefix-spoke2}-mgmt"
  resource_group_name = var.spoke2_vnet_resource_group_name 
  virtual_network_name = azurerm_virtual_network.spoke2-vnet.name
  address_prefixes     = ["10.2.0.64/27"]
}

resource "azurerm_subnet" "spoke2-workload" {
  name                 = "${local.prefix-spoke2}-workload"
  resource_group_name = var.spoke2_vnet_resource_group_name 
  virtual_network_name = azurerm_virtual_network.spoke2-vnet.name
  address_prefixes     = ["10.2.1.0/24"]
}