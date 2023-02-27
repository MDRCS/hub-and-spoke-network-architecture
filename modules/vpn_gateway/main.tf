# Virtual Network Gateway
resource "azurerm_public_ip" "hub-vpn-gateway-public-ip" {
  name                = "${local.hub-vpn-gateway}-public-ip"
  resource_group_name = var.hub_vnet_resource_group_name
  location            = var.location
  allocation_method   = "Dynamic"

  tags = merge(
    tomap({ ResourceGroupe = var.hub_vnet_resource_group_name }),
    local.default_tags
  )
}

resource "azurerm_virtual_network_gateway" "hub-vnet-gateway" {
  name                = "${local.hub-vpn-gateway}-vnet"
  resource_group_name = var.hub_vnet_resource_group_name
  location            = var.location
  type                = "Vpn"
  vpn_type            = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "VpnGw1"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.hub-vpn-gateway-public-ip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = module.network.hub_vnet_gateway_subnet_id
  }
  depends_on = [azurerm_public_ip.hub-vpn-gateway-public-ip]

  tags = merge(
    tomap({ ResourceGroupe = var.hub_vnet_resource_group_name }),
    local.default_tags
  )
}
