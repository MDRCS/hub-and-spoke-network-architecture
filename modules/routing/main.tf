resource "azurerm_route_table" "hub-gateway-rt" {
  name                          = "${local.hub-gateway}-rt"
  location                      = var.location
  resource_group_name           = var.hub_nva_resource_group_name
  disable_bgp_route_propagation = false

  route {
    name           = "toHub"
    address_prefix = "10.0.0.0/16"
    next_hop_type  = "VnetLocal"
  }

  route {
    name                   = "toSpoke1"
    address_prefix         = "10.1.0.0/16"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.0.2.36"
  }

  route {
    name                   = "toSpoke2"
    address_prefix         = "10.2.0.0/16"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.0.2.36"
  }

  route {
    name           = "default"
    address_prefix = "0.0.0.0/1"
    next_hop_type  = "Internet" # To Allow Hub to communicate with outside resources
  }

  tags = merge(
    tomap({ ResourceGroupe = var.hub_nva_resource_group_name }),
    local.default_tags
  )
}

resource "azurerm_subnet_route_table_association" "hub-gateway-rt-hub-vnet-gateway-subnet" {
  subnet_id      = module.network.hub_vnet_gateway_subnet_id
  route_table_id = azurerm_route_table.hub-gateway-rt.id
  depends_on     = [module.network.hub_gateway_subnet]
}

resource "azurerm_route_table" "spoke1-rt" {
  name                          = "${local.prefix-spoke1}-rt"
  location                      = var.location
  resource_group_name           = var.hub_nva_resource_group_name
  disable_bgp_route_propagation = false

  route {
    name                   = "toSpoke2"
    address_prefix         = "10.2.0.0/16"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.0.2.36"
  }

  route {
    name           = "default"
    address_prefix = "0.0.0.0/1"
    next_hop_type  = "Internet" # To Allow Spoke 1 to communicate with outside resources
  }

  tags = merge(
    tomap({ ResourceGroupe = var.hub_nva_resource_group_name }),
    local.default_tags
  )
}

resource "azurerm_subnet_route_table_association" "spoke1-rt-spoke1-vnet-mgmt" {
  subnet_id      = module.network.spoke1_mgmt_subnet_id
  route_table_id = azurerm_route_table.spoke1-rt.id
  depends_on     = [module.network.spoke1_mgmt_subnet]
}

resource "azurerm_subnet_route_table_association" "spoke1-rt-spoke1-vnet-workload" {
  subnet_id      = module.network.spoke1_workload_subnet_id
  route_table_id = azurerm_route_table.spoke1-rt.id
  depends_on     = [module.network.spoke1_workload_subnet]
}

resource "azurerm_route_table" "spoke2-rt" {
  name                          = "${local.prefix-spoke2}-rt"
  resource_group_name           = var.hub_nva_resource_group_name
  location                      = var.location
  disable_bgp_route_propagation = false

  route {
    name                   = "toSpoke1"
    address_prefix         = "10.1.0.0/16"
    next_hop_in_ip_address = "10.0.2.36"
    next_hop_type          = "VirtualAppliance"
  }

  route {
    name           = "default"
    address_prefix = "0.0.0.0/1"
    next_hop_type  = "Internet" # To Allow Spoke 2 to communicate with outside resources
  }

  tags = merge(
    tomap({ ResourceGroupe = var.hub_nva_resource_group_name }),
    local.default_tags
  )
}

resource "azurerm_subnet_route_table_association" "spoke2-rt-spoke2-vnet-mgmt" {
  subnet_id      = module.network.spoke2_mgmt_subnet_id
  route_table_id = azurerm_route_table.spoke2-rt.id
  depends_on     = [module.network.spoke2_mgmt_subnet]
}

resource "azurerm_subnet_route_table_association" "spoke2-rt-spoke2-vnet-workload" {
  subnet_id      = module.network.spoke2_workload_subnet_id
  route_table_id = azurerm_route_table.spoke2-rt.id
  depends_on     = [module.network.spoke2_workload_subnet]
}