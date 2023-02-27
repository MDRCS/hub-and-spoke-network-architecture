locals {
  prefix      = "az-firewall"
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

variable "my_ip" {
  description = "My Laptop Public IP Address"
}