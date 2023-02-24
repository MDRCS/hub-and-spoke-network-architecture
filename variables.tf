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

variable "location" {
  description = "Location of the network"
  default     = "eastus"
}

variable "username" {
  description = "Username for Virtual Machines"
  default     = "azureuser"
}

variable "password" {
  description = "Password for Virtual Machines"
  default     = "PasSWord-123"
}

variable "vmsize" {
  description = "Size of the VMs"
  default     = "Standard_DS1_v2"
}

variable "my_ip" {
  description = "My Laptop Public IP Address"
  default     = data.external.my_ip.result.ip
}