locals {
  prefix-hub-vnet         = "hub-vnet"
  prefix-hub-nva         = "hub-nva"
  hub-nva-resource-group = "hub-nva-rg"
}
locals {
  prefix-hub         = "hub"
  prefix-hub-nva         = "hub-nva"
  prefix-spoke1         = "spoke1"
  prefix-spoke2         = "spoke2"
  hub-nva-resource_group = "hub-nva-rg"
  hub-vnet-resource-group = "hub-vnet-rg"
  spoke1-resource-group = "spoke1-vnet-rg"
  spoke2-resource-group = "spoke2-vnet-rg"
  shared-key         = "4-v3ry-53cr37-1p53c-5h4r3d-k3y"
}

locals {
  spoke2-resource-group = "spoke2-vnet-rg"
  prefix-spoke2         = "spoke2"
}

variable "hub_nva_resource_group_name" {
  description = "Resource Group Name"
}

variable "hub_vnet_resource_group_name" {
  description = "Resource Group Name"
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