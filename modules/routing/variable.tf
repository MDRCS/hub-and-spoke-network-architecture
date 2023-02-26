locals {
  hub-gateway   = "hub-gateway"
  prefix-spoke1 = "spoke1"
  prefix-spoke2 = "spoke2"
}


variable "hub_nva_resource_group_name" {
  description = "Hub NVA Resource Group Name"
}

variable "spoke1_vnet_resource_group_name" {
  description = "Spoke1 VNET Resource Group Name"
}

variable "spoke2_vnet_resource_group_name" {
  description = "Spoke2 VNET Resource Group Name"
}

variable "location" {
  description = "Location of the network"
}
