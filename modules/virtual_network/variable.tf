locals {
  prefix-hub         = "hub"
  hub-location       = "eastus"
  hub-resource-group = "hub-vnet-rg"
  shared-key         = "4-v3ry-53cr37-1p53c-5h4r3d-k3y"
}

locals {
  spoke1-location       = "eastus"
  spoke1-resource-group = "spoke1-vnet-rg"
  prefix-spoke1         = "spoke1"
}

locals {
  spoke2-location       = "eastus"
  spoke2-resource-group = "spoke2-vnet-rg"
  prefix-spoke2         = "spoke2"
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