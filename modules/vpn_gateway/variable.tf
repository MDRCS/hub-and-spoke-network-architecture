locals {
  hub-vpn-gateway         = "hub-vpn-gateway"
  shared-key         = "4-v3ry-53cr37-1p53c-5h4r3d-k3y"
}

variable "hub_vnet_resource_group_name" {
  description = "Hub VNET Resource Group Name"
}

variable "location" {
  description = "Location of the network"
}