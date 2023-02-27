resource "azurerm_virtual_network_peering" "spoke1-hub-peer" {
  name                      = "${local.prefix-spoke1}-${local.prefix-hub}-peer"
  resource_group_name       = var.spoke1_vnet_resource_group_name
  virtual_network_name      = module.network.spoke1_virtual_network_name
  remote_virtual_network_id = module.network.hub_virtual_network_id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = true
  depends_on                   = [module.network.spoke1_virtual_network, module.network.hub_virtual_network, module.vpn.gateway]
}


resource "azurerm_virtual_network_peering" "hub-spoke1-peer" {
  name                         = "${local.prefix-hub}-${local.prefix-spoke1}-peer"
  resource_group_name          = var.hub_vnet_resource_group_name
  virtual_network_name         = module.network.hub_virtual_network_name
  remote_virtual_network_id    = module.network.spoke1_virtual_network_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  use_remote_gateways          = false
  depends_on                   = [module.network.spoke1_virtual_network, module.network.hub_virtual_network, module.vpn.gateway]
}


resource "azurerm_virtual_network_peering" "spoke2-hub-peer" {
  name                      = "${local.prefix-spoke2}-${local.prefix-hub}-peer"
  resource_group_name       = var.spoke2_vnet_resource_group_name
  virtual_network_name      = module.network.spoke2_virtual_network_name
  remote_virtual_network_id = module.network.hub_virtual_network_id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = true
  depends_on                   = [module.network.spoke2_virtual_network, module.network.hub_virtual_network, module.vpn.gateway]
}

resource "azurerm_virtual_network_peering" "hub-spoke2-peer" {
  name                         = "${local.prefix-hub}-${local.prefix-spoke2}-peer"
  resource_group_name          = var.hub_vnet_resource_group_name
  virtual_network_name         = module.network.hub_virtual_network_name
  remote_virtual_network_id    = module.network.spoke2_virtual_network_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  use_remote_gateways          = false
  depends_on                   = [module.network.spoke2_virtual_network, module.network.hub_virtual_network, module.vpn.gateway]
}