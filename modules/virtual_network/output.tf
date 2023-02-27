output "hub_vnet_firewall_subnet_id" {
  value = azurerm_subnet.hub_vnet_firewall.id
}

output "hub_vnet_firewall_mgmt_subnet_id" {
  value = azurerm_subnet.hub_vnet_firewall_mgmt.id
}

output "hub_vnet_dmz_subnet_address_prefixes" {
  value = azurerm_subnet.hub_vnet_dmz.address_prefixes
}

output "spoke1_mgmt_subnet_address_prefixes" {
  value = azurerm_subnet.spoke1-mgmt.address_prefixes
}

output "spoke2_mgmt_subnet_address_prefixes" {
  value = azurerm_subnet.spoke2-mgmt.address_prefixes
}

output "spoke1_mgmt_subnet_id" {
  value = azurerm_subnet.spoke1-mgmt.id
}

output "spoke2_mgmt_subnet_id" {
  value = azurerm_subnet.spoke2-mgmt.id
}

output "spoke1_mgmt_subnet" {
  value = azurerm_subnet.spoke1-mgmt
}

output "spoke2_mgmt_subnet" {
  value = azurerm_subnet.spoke2-mgmt
}

output "spoke1_workload_subnet_address_prefixes" {
  value = azurerm_subnet.spoke1-workload.address_prefixes
}

output "spoke2_workload_subnet_address_prefixes" {
  value = azurerm_subnet.spoke2-workload.address_prefixes
}

output "spoke1_workload_subnet_id" {
  value = azurerm_subnet.spoke1-workload.id
}

output "spoke2_workload_subnet_id" {
  value = azurerm_subnet.spoke2-workload.id
}

output "spoke1_workload_subnet" {
  value = azurerm_subnet.spoke1-workload
}

output "spoke2_workload_subnet" {
  value = azurerm_subnet.spoke2-workload
}


output "hub_vnet_gateway_subnet_id" {
  value = azurerm_subnet.hub_vnet_gateway.id
}

output "hub_vnet_gateway_subnet" {
  value = azurerm_subnet.hub_vnet_gateway
}

output "hub_vnet_dmz_subnet_id" {
  value = azurerm_subnet.hub_vnet_dmz.id
}

output "hub_vnet_mgmt_id" {
  value = azurerm_subnet.hub_vnet_mgmt.id
}

output "hub_virtual_network_id" {
  value = azurerm_virtual_network.hub-vnet.id
}

output "hub_virtual_network" {
  value = azurerm_virtual_network.hub-vnet
}

output "hub_virtual_network_name" {
  value = azurerm_virtual_network.hub-vnet.name
}

output "spoke1_virtual_network_name" {
  value = azurerm_virtual_network.spoke1-vnet.name
}

output "spoke1_virtual_network" {
  value = azurerm_virtual_network.spoke1-vnet
}

output "spoke1_virtual_network_id" {
  value = azurerm_virtual_network.spoke1-vnet.id
}

output "spoke2_virtual_network_name" {
  value = azurerm_virtual_network.spoke2-vnet.name
}

output "spoke2_virtual_network" {
  value = azurerm_virtual_network.spoke2-vnet
}

output "spoke2_virtual_network_id" {
  value = azurerm_virtual_network.spoke2-vnet.id
}



