locals {
  prefix-hub-nva         = "hub-nva"
  hub-nva-location       = "eastus"
  hub-nva-resource-group = "hub-nva-rg"
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