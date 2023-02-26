locals {
  prefix-hub-vnet         = "hub-vnet"
  prefix-hub-nva          = "hub-nva"
   prefix-spoke1         = "spoke1"
  prefix-spoke2         = "spoke2"
}

variable "hub_nva_resource_group_name" {
  description = "Hub NVA Resource Group Name"
}

variable "hub_vnet_resource_group_name" {
  description = "Hub VNET Resource Group Name"
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

variable "username" {
  description = "Username for Virtual Machines"
}

variable "password" {
  description = "Password for Virtual Machines"
}

variable "vmsize" {
  description = "Size of the VMs"
}

variable "my_ip" {
  description = "My Laptop Public IP Address"
}