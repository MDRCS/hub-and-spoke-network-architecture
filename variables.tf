locals {
  prefix-hub-vnet         = "hub-vnet"
  prefix-hub-nva          = "hub-nva"
  prefix-spoke1           = "spoke1"
  prefix-spoke2           = "spoke2"
  hub-nva-resource_group  = "hub-nva-rg"
  hub-vnet-resource-group = "hub-vnet-rg"
  spoke1-resource-group   = "spoke1-vnet-rg"
  spoke2-resource-group   = "spoke2-vnet-rg"
  shared-key              = "4-v3ry-53cr37-1p53c-5h4r3d-k3y"
  default_tags = {
    Environment = terraform.workspace
    Project     = var.project
    Owner       = var.contact
    ManagedBy   = "Terraform"
  }

}
variable "project" {
  default = "hub-spoke-network-architecture"
}

variable "contact" {
  default = "elrahali.md@gmail.com"
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

