module "network" {
  source = "../../modules/virtual_network"
  hub_vnet_resource_group_name    = var.hub_vnet_resource_group_name
  spoke1_vnet_resource_group_name = var.spoke1_vnet_resource_group_name
  spoke2_vnet_resource_group_name = var.spoke2_vnet_resource_group_name
  location                        = var.location
}